//
//  GroupsViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupsViewController.h"
#import "AlertyDBMgr.h"
#import "NSExtensions.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"
#import "FriendCell.h"
#import "VideoViewController.h"
#import "MobileInterface.h"
#import <Alerty-Swift.h>
@import AddressBookUI;


@interface GroupsViewController() <FriendCellDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) Group *activeGroup;
@property (nonatomic, strong) NSMutableDictionary<NSString*, UIImage*>* contactImages;

@end

@implementation GroupsViewController

@synthesize groupsTableView = _groupsTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize activeGroup = _activeGroup;

#pragma mark - Super Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.groupsTableView setBackgroundView:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinishedNotification:) name:kSyncFinishedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    self.contactImages = [NSMutableDictionary dictionary];

	[[AlertyDBMgr sharedAlertyDBMgr] addActiveGroupIfNoneFound];
	if ([AlertySettingsMgr isBusinessVersion]) {
		[[AlertyDBMgr sharedAlertyDBMgr] addEnterpriseGroupIfNoneFound];
	} else {
		[[AlertyDBMgr sharedAlertyDBMgr] removeEnterpriseGroupIfFound];
	}
	
	self.fetchedResultsController = [[AlertyDBMgr sharedAlertyDBMgr] fetchedResultsControllerForGroups];
	self.fetchedResultsController.delegate = self;
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		cmdlogtext(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	
	self.navigationItem.leftBarButtonItem = NULL;
	self.navigationItem.rightBarButtonItem = NULL;

	[self.groupsTableView reloadData];
}

- (void) syncFinishedNotification:(NSNotification*)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.groupsTableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([AlertySettingsMgr isBusinessVersion]) {
#ifdef SAKERHETSAPPEN
        return 1;
#else
        return 2;
#endif
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#ifdef SAKERHETSAPPEN
    Group *group = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    return [group.contacts count];
#else
    Group *group = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (![AlertySettingsMgr isBusinessVersion]) {
        int maxSlotCount = 1;
        NSInteger contactCount = [[AlertyDBMgr sharedAlertyDBMgr] countAllContacts];
        NSUInteger contactsInGroupCount = [group.contacts count];
        return contactsInGroupCount + (maxSlotCount - contactCount);
    }
    else {
        if ([group.type intValue] == 2) {
            // if enterprise group, no new ones are allowed to be added
            return [group.contacts count];
        }
        else {
            NSInteger maxSlotCount = [AlertySettingsMgr maxCompanyContacts];
            NSInteger contactCount = [[AlertyDBMgr sharedAlertyDBMgr] countAllContacts];
            NSUInteger contactsInGroupCount = [group.contacts count];
            return maxSlotCount - contactCount + contactsInGroupCount;
        }
    }
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
#ifdef SAKERHETSAPPEN
    Group *group = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
#else
    Group *group = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
#endif
    
    FriendCell *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    cell.backgroundColor = [UIColor clearColor];
    if (cell == nil) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    if (indexPath.row >= group.contacts.allObjects.count) {
        cell.titleLabel.textColor = [UIColor colorNamed:@"color_text"];
        cell.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        cell.title = NSLocalizedString(@"Free slot", @"");
        cell.backgroundColor = [UIColor clearColor];
        cell.deletable = NO;
        cell.canInteract = YES;
        cell.rowNumber = indexPath.row;
        cell.sectionNumber = indexPath.section;
        cell.cellDelegate = self;
        [cell setCellImage:nil];
        cell.status = @"";
        [cell.phoneIcon setImage:nil];
        cell.contact = nil;
        cell.callEnabled = NO;
        [self addSeparator:cell];
        return cell;
    }
    
    Contact *contact = [group.contacts.allObjects objectAtIndex:indexPath.row];
    UIImage* image = nil;
    if (contact.phone.length) {
        image = self.contactImages[contact.phone];
        if (!image) {
            image = [DataManager lookupFriendNameByPhone:contact orPhone:nil];
            if (image) {
                [self.contactImages setObject:image forKey:contact.phone];
            }
        }
    }
    cell.phoneIcon.image = image;
    cell.titleLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
    if (!contact.name.length) {
        [DataManager lookupFriendNameByPhone:contact orPhone:nil];
    }
    cell.title = contact.name;
    cell.deletable = NO;
    cell.canInteract = NO;
    cell.rowNumber = indexPath.row;
    cell.contact = contact;
#ifdef SAKERHETSAPPEN
    cell.sectionNumber = 1;
#else
    cell.sectionNumber = indexPath.section;
#endif
    cell.cellDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSInteger row = indexPath.row;
    if (indexPath.section == 1) row += [self tableView:tableView numberOfRowsInSection:0];
    NSInteger online = [contact.online integerValue];
    switch (online) {
        case 0: cell.status = NSLocalizedStringFromTable(@"Not yet a user of Alerty", @"Target", @""); break;
        case 1: cell.status = NSLocalizedStringFromTable(@"I am using Alerty!", @"Target", @""); break;
        case 2: cell.status = @"Offline"; break;
    }
    cell.statusLabel.textColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
    
    NSString *imageName = nil;;    
    switch ([contact.type intValue]) {
        case 0:
            cell.deletable = YES;
            cell.canInteract = YES;
            switch ([contact.status intValue]) {
                case kContactStatusInvited:
                    imageName = @"contact_question";
                    break;
                case kContactStatusAccepted:
                    imageName = @"contact_accepted";
                    break;
                case kContactStatusRejected:
                    imageName = @"contact_rejected";
                    break;
                case kContactStatusUnspecified:
                    cell.deletable = NO;
                    imageName = @"";
                    break;
                default:
                    imageName = @"";
                    break;
            }
            break;
        case 1:
            cell.deletable = NO;
            cell.canInteract = NO;
            cell.callEnabled = YES;
            imageName = @"";
            break;
    }
    [cell setCellImage:imageName];
    [self addSeparator:cell];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void) addSeparator:(UIView*)cell {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0];
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:view];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    Group *group = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    return [group.type intValue] == 2 || indexPath.row >= group.contacts.allObjects.count ? NO : YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteFriend:indexPath];
	}
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    //ContactsViewController *cvc = [[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil];
    //cvc.group = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    //[self.navigationController pushViewController:cvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    //[self.groupsTableView endUpdates];
    [self.groupsTableView reloadData];
}

#pragma mark FriendsCellDelegate

- (void) deleteFriend:(NSIndexPath*)indexPath {
    Group *group = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    Contact *contact = [group.contacts.allObjects objectAtIndex:indexPath.row];
    if( [contact.groups count] <= 1 ) {
        [[DataManager sharedDataManager] sendSosInvitationTo:contact.phone Name:@"" Position:-1];
    }
    [[AlertyDBMgr sharedAlertyDBMgr] delContact:contact];
    [self.groupsTableView reloadData];
}

- (void) addFriend:(FriendCell*)cell {
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No permission", @"")
                                                                       message:NSLocalizedString(@"This App has no permission to access your contacts. Please check it in your privacy settings of your device.", @"")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    self.activeGroup = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cell.sectionNumber]];
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    if (picker){
        picker.peoplePickerDelegate = self;
        NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
        picker.displayedProperties = displayedItems;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void) showFriend:(Contact*)contact {
    if ([contact.online integerValue] == 1) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alerty", @"Target", @"") message:NSLocalizedString(@"contact_call", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"contact_call_video", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            VideoViewController* vc = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
            vc.phoneNr = [AlertyDBMgr internationalizeNumber:contact.phone];
            vc.recipient = contact.name;
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"contact_call_phone", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *phone = [@"tel://" stringByAppendingString:contact.phone];
            phone = [AlertyDBMgr internationalizeNumber:phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
        }]];
        if ([contact.lastPosition intValue] == 1) {
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"contact_call_last_position", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self showPosition:contact];
            }]];
        }
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"contact_call_follow_me", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *phone = [AlertyDBMgr internationalizeNumber:contact.phone];
            [AlertyAppDelegate.sharedAppDelegate.mainController.alertyViewController startFollowMeMode:phone recipient:contact.name];
            [AlertyAppDelegate.sharedAppDelegate.mainController didPressHomeButton:nil];
            [AlertyAppDelegate.sharedAppDelegate.mainController hideFunctions];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alerty", @"Target", @"") message:NSLocalizedString(@"contact_call", @"") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"contact_call_follow_me", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phone = [AlertyDBMgr internationalizeNumber:contact.phone];
        [AlertyAppDelegate.sharedAppDelegate.mainController.alertyViewController startFollowMeMode:phone recipient:contact.name];
        [AlertyAppDelegate.sharedAppDelegate.mainController didPressHomeButton:nil];
        [AlertyAppDelegate.sharedAppDelegate.mainController hideFunctions];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"contact_call_phone", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *phone = [@"tel://" stringByAppendingString:contact.phone];
        phone = [AlertyDBMgr internationalizeNumber:phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone] options:@{} completionHandler:nil];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showPosition:(Contact*)contact {
    ShowPositionViewController* viewController = [[ShowPositionViewController alloc] initWithNibName:@"ShowPositionViewController" bundle:nil];
    viewController.contact = contact;
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:viewController];
    nc.navigationBarHidden = NO;
    [self presentViewController:nc animated:TRUE completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self selectPerson:person property:property identifier:identifier];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self selectPerson:person property:property identifier:identifier];
    return NO;
}

- (void)selectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef phoneProperty = ABRecordCopyValue(person, property);
    long idx = ABMultiValueGetIndexForIdentifier (phoneProperty, identifier);
    NSString *phone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneProperty, idx));
    CFRelease(phoneProperty);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if( [phone rangeOfString:@"00"].location != 0 && [phone rangeOfString:@"+"].location != 0) {
        [self showAlert:@"" : NSLocalizedString(@"The mobile phone number must be in international format (e.g. +46708123456). Please change the number.", @"") : NSLocalizedString(@"OK", @"")];
    }
    else {
        NSString* stripped = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
        stripped = [stripped stringByReplacingOccurrencesOfString:@" " withString:@""];
        stripped = [stripped stringByReplacingOccurrencesOfString:@"-" withString:@""];
        stripped = [stripped stringByReplacingOccurrencesOfString:@"(" withString:@""];
        stripped = [stripped stringByReplacingOccurrencesOfString:@")" withString:@""];
        /*if ([stripped compare:[AlertySettingsMgr UserPhoneNr]] == NSOrderedSame) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Cannot add yourself as contact", @"Cannot add yourself as contact") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } else if (![[AlertyDBMgr sharedAlertyDBMgr] doesContactExistWithPhone:phone inGroup:self.activeGroup] ) {*/
            NSMutableDictionary *friend = [NSMutableDictionary dictionary];
            [friend setObject:phone forKey:@"phone"];
            [friend setObject:@"" forKey:@"name"];
            [friend setObject:[NSNumber numberWithInt:0] forKey:@"type"];
            [friend setObject:[NSNumber numberWithInt:0] forKey:@"status"];
            [[AlertyDBMgr sharedAlertyDBMgr] addContactFromDictionary:friend toGroup:self.activeGroup];
            
            NSString *name = [[DataManager sharedDataManager] lookupFriendNameByPhone:phone];
            [[DataManager sharedDataManager] sendSosInvitationTo:phone Name:name == nil ? @"" : name Position:0];
        /*}
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Contact already on list.", @"Contact already on list.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }*/
    }
    
    [self.groupsTableView reloadData];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
