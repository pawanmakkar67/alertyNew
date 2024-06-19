//
//  GroupsViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupsViewController.h"
#import "ContactsViewController.h"
#import "AlertyDBMgr.h"
#import "NSExtensions.h"
#import "GroupCell.h"
#import "AlertySettingsMgr.h"

@interface GroupsViewController()
@property (nonatomic, retain) Group *activeGroup;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation GroupsViewController

@synthesize groupsTableView = _groupsTableView;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize activeGroup = _activeGroup;

#pragma mark - Super Overrides

- (void)dealloc {
	
	[_groupsTableView release];
	[_fetchedResultsController release];
	[_activeGroup release];

    [super dealloc];
}

- (void)viewDidUnload
{
	self.groupsTableView = nil;
	self.fetchedResultsController = nil;
	self.activeGroup = nil;
	
    [super viewDidUnload];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.groupsTableView setBackgroundView:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// bubble view for Active Group
	if (![AlertySettingsMgr groupsVCBubble1Shown]) {
		[self showBubbleViewInView:self.groupsTableView
						  withText:NSLocalizedString(@"Your alerts are sent to contacts in the active group. To change the active group, drag and drop a cell from below to this position using the icon to the right.", @"GroupsVC bubble text")
						atPosition:CGPointMake(10,90)
					  withArrowAtX:25.0
		 ];
		[AlertySettingsMgr setGroupsVCBubble1Shown:YES];
	}
	
	// bubble view for Add group
	if (![AlertySettingsMgr groupsVCBubble2Shown]) {
//		[self showBubbleViewInView:self.view 
//						  withText:NSLocalizedString(@"Create a new group by pressing this button.", @"GroupsVC bubble text")
//						atPosition:CGPointMake(90,0)
//					  withArrowAtX:250.0
//		 ];
		[AlertySettingsMgr setGroupsVCBubble2Shown:YES];
	}
	
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
	if ([AlertySettingsMgr isBusinessVersion] || [AlertySettingsMgr hasValidSubscription]) {
		/*UIBarButtonItem *editButton = nil;
		editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(setTableEditableAction:)];
		editButton.enabled = YES;
		if (editButton) {
			self.navigationItem.leftBarButtonItem = editButton;
			[editButton release];
		}*/
		self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
		UIBarButtonItem *addButton = nil;
		addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroupAction:)];
		
		NSInteger maxSlotCount;
		NSInteger contactCount;
		if ([AlertySettingsMgr isBusinessVersion]) {
			maxSlotCount = [AlertySettingsMgr maxCompanyContacts];
			contactCount = [[AlertyDBMgr sharedAlertyDBMgr] countAllPersonalContacts];
		} else {
			maxSlotCount = [AlertySettingsMgr maxCredit];
			contactCount = [[AlertyDBMgr sharedAlertyDBMgr] countAllContacts];
		}
		if (maxSlotCount <= contactCount) addButton.enabled = NO;
		if (addButton) {
			self.navigationItem.rightBarButtonItem = addButton;
			[addButton release];
		}
	}
	[self.groupsTableView reloadData];
}

#pragma mark - Internal Methods

// The editButtonItem will invoke this method.
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
	[self setTableEditableAction:nil];
}

- (void) setTableEditableAction:(id)sender
{
	BOOL willEdit = ![self.groupsTableView isEditing];
	[self.groupsTableView setEditing:willEdit animated:YES];
	
	if( !willEdit ) {
		NSInteger activeRow = 0;
		if ([AlertySettingsMgr isBusinessVersion]) {
			activeRow = 1;
		}
		else {
			activeRow = 0;
		}
		Group *group = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathWithSection:1 row:0]];
		switch ([group.type integerValue]) {
			case 0:
				// inactive, set it active
				cmdlogtext(@"setting group %@ active", group.name)
				[[AlertyDBMgr sharedAlertyDBMgr] setGroupActive:group];
				break;
			case 1:
				cmdlogtext(@"group %@ is already active", group.name)
				break;
			case 2:
				cmdlogtext(@"group %@ is of enterprise type, cannot be set active", group.name)
				break;
			default:
				cmdlogtext(@"b0rkeria : %@", group.name)
				break;
		}
		[self.groupsTableView reloadData];
	}	
}

- (void) addGroupAction:(id)sender
{
	UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create group", @"")
														 message:NSLocalizedString(@"Enter a name for the group", @"")
														delegate:self
											   cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
											   otherButtonTitles:NSLocalizedString(@"Create", @""), nil] autorelease];
	[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[alertView show];
}

- (NSIndexPath*) updatedPath:(NSIndexPath *)indexPath {
	NSIndexPath* ip = indexPath;
	if ([AlertySettingsMgr isBusinessVersion]) {
		if (ip.section == 0) {
			ip = [NSIndexPath indexPathForRow:0 inSection:ip.row];
		} else {
			ip = [NSIndexPath indexPathForRow:ip.row inSection:ip.section+1];
		}
	}
	return ip;
}

- (void)configureCell:(GroupCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
	Group *group = [_fetchedResultsController objectAtIndexPath:[self updatedPath:indexPath]];
	cell.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
	//cell.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
	//[cell.contentView setBackgroundColor:];
	cell.textLabel.text = group.name;
	cell.textLabel.textColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0];
	cell.indexPath = indexPath; // needed to get the object inside
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([AlertySettingsMgr isBusinessVersion])
		return [[_fetchedResultsController sections] count] - 1;
	return [[_fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section) {
		case 0:
			return NSLocalizedString(@"Active group", @"GroupsViewController titleForHeaderInSection");
		default:
			return NSLocalizedString(@"Groups", @"GroupsViewController titleForHeaderInSection");
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([AlertySettingsMgr isBusinessVersion]) {
		if (section == 0) {
			int count = [[[_fetchedResultsController sections] objectAtIndex:0] numberOfObjects] +
				[[[_fetchedResultsController sections] objectAtIndex:1] numberOfObjects];
			return count;
		} else {
			return [[[_fetchedResultsController sections] objectAtIndex:2] numberOfObjects];
		}
	} else {
		id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	[self configureCell:cell atIndexPath:indexPath];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	// if it falls in the active section
	NSInteger activeRow = 0;
	if ([AlertySettingsMgr isBusinessVersion]) {
		activeRow = 1;
	}
	else {
		activeRow = 0;
	}
	if( toIndexPath.section == 0 ) {
		NSIndexPath *toIndex = [NSIndexPath indexPathForRow:0 inSection:fromIndexPath.section];
		[self performSelector:@selector(moveSelected:) withObject:toIndex afterDelay:0.5];
	}
}

- (void)moveSelected:(NSIndexPath*)toIndex {
	NSInteger activeRow = 0;
	if ([AlertySettingsMgr isBusinessVersion]) {
		activeRow = 2;
	}
	else {
		activeRow = 1;
	}
	NSIndexPath *fromIndex = [NSIndexPath indexPathForRow:activeRow inSection:0];
	cmdlogtext(@"moving from %d/%d to %d/%d", fromIndex.section, fromIndex.row, toIndex.section, toIndex.row)
	[self.groupsTableView beginUpdates];
	[self.groupsTableView moveRowAtIndexPath:fromIndex toIndexPath:toIndex];
	[self.groupsTableView endUpdates];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*if ([AlertySettingsMgr isBusinessVersion]) {
		return indexPath.section < 2 ? NO : YES;
	}
	else */{
		return indexPath.section < 1 ? NO : YES;
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*if ([AlertySettingsMgr isBusinessVersion]) {
		return indexPath.section < 2 ? NO : YES;
	}
	else */{
		return indexPath.section < 1 ? NO : YES;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	cmdlog
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		cmdlogtext(@"Delete row");
		Group *group = [self.fetchedResultsController objectAtIndexPath:[self updatedPath:indexPath]];
		[[AlertyDBMgr sharedAlertyDBMgr] delGroup:group];
		NSInteger maxSlotCount;
		NSInteger contactCount;
		if ([AlertySettingsMgr isBusinessVersion]) {
			maxSlotCount = [AlertySettingsMgr maxCompanyContacts];
			contactCount = [[AlertyDBMgr sharedAlertyDBMgr] countAllPersonalContacts];
		} else {
			maxSlotCount = [AlertySettingsMgr maxCredit];
			contactCount = [[AlertyDBMgr sharedAlertyDBMgr] countAllContacts];
		}
		self.navigationItem.rightBarButtonItem.enabled = (maxSlotCount > contactCount);
		//[[AlertyDBMgr sharedAlertyDBMgr] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
	}
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(13, 10, 284, 27);
    label.textColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0];
    label.font = [UIFont fontWithName:@"Helvetica" size:14];
    label.backgroundColor = [UIColor clearColor];
	label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
	
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    [view addSubview:label];
	
    return view;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Group *group = [_fetchedResultsController objectAtIndexPath:[self updatedPath:indexPath]];
	return [group.type intValue] == 2 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	ContactsViewController *cvc = [[[ContactsViewController alloc] initWithNibName:@"ContactsViewController" bundle:nil] autorelease];
	cvc.group = [self.fetchedResultsController objectAtIndexPath:[self updatedPath:indexPath]];
	[self.navigationController pushViewController:cvc animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	cmdlogtext(@"moving from %d/%d to %d/%d", sourceIndexPath.section, sourceIndexPath.row, proposedDestinationIndexPath.section, proposedDestinationIndexPath.row)
	NSInteger activeRow = 0;
	if ([AlertySettingsMgr isBusinessVersion]) {
		activeRow = 1;
	}
	else {
		activeRow = 0;
	}
	return (proposedDestinationIndexPath.section == 0 && proposedDestinationIndexPath.row == activeRow) ? proposedDestinationIndexPath : sourceIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 37.0;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	cmdlog
    [self.groupsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject 
	   atIndexPath:(NSIndexPath *)indexPath 
	 forChangeType:(NSFetchedResultsChangeType)type 
	  newIndexPath:(NSIndexPath *)newIndexPath
{
	cmdlog
	UITableView *tableView = self.groupsTableView;
	switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
			
        case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id)sectionInfo 
		   atIndex:(NSUInteger)sectionIndex 
	 forChangeType:(NSFetchedResultsChangeType)type
{
	cmdlog
	UITableView *tableView = self.groupsTableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	cmdlog
    [self.groupsTableView endUpdates];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	switch( buttonIndex ) {
		case 0:	 // cancel
			break;
		default: // create
		{
			UITextField *groupNameTextField = [alertView textFieldAtIndex:0];
			[[AlertyDBMgr sharedAlertyDBMgr] addGroupWithName:groupNameTextField.text];
			break;
		}
	}
}

@end
