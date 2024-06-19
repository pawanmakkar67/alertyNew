//
//  SettingsViewController.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "DataManager.h"
#import "config.h"
#import "AlertyAppDelegate.h"
#import "AlertView.h"
#import "NSExtensions.h"
#import "AlertySettingsMgr.h"
#import "AlertyDBMgr.h"
#import "UserAccountViewController.h"
#import "MotionViewController.h"
#import "MoreSettingCell.h"
#import "EmergencyContactViewController.h"
#import "IndoorLocationingViewController.h"
#import "HeadsetViewController.h"


@interface SettingsViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

NSArray *settingsArray = nil;
NSArray *moreSettingArray = nil;

@implementation SettingsViewController



#pragma mark - Overrides

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *barButtonTitleAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                               NSFontAttributeName :[UIFont fontWithName:@"Lato-Bold" size:18.0]};
    [self.navigationBar setTitleTextAttributes:barButtonTitleAttributes];
    self.navigationBar.topItem.title = [NSLocalizedString(@"Settings", @"Settings") uppercaseString];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellReuseIdentifier:@"SettingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MoreSettingCell" bundle:nil] forCellReuseIdentifier:@"MoreSettingCell"];
    /** settingsArray array of dictionaries
     key =  row title
     value = image name
     ***/

    settingsArray = @[@{NSLocalizedString(@"User account", @""):@"Icon-user"}, @{NSLocalizedString(@"Indoor locationing", @""): @"Icon-map-marker"}, @{NSLocalizedString(@"Motion sensitivity", @""):@"Icon-rss-square"}, @{NSLocalizedString(@"Accessories", @""):@"Icon-tools"}, @{NSLocalizedString(@"History", @""):@"Icon-book"}];

#ifdef OPUS
    moreSettingArray = @[NSLocalizedString(@"last_known_position", @""), NSLocalizedString(@"Discrete mode", @""), NSLocalizedString(@"Tracking", @""), NSLocalizedString(@"Switch to Front Facing Camera", @""), NSLocalizedString(@"Upload last screenshot on alert", @""), NSLocalizedString(@"Speakerphone", @""), NSLocalizedString(@"Use PIN", @""), NSLocalizedString(@"Info", @""), NSLocalizedString(@"contact", @""), NSLocalizedString(@"Privacy Settings", @""), NSLocalizedString(@"Terms of service", @""), NSLocalizedString(@"Send log in e-mail", @"")];
#else
    moreSettingArray = @[NSLocalizedString(@"last_known_position", @""), NSLocalizedString(@"Discrete mode", @""), NSLocalizedString(@"Tracking", @""), NSLocalizedString(@"Switch to Front Facing Camera", @""), NSLocalizedString(@"Upload last screenshot on alert", @""), NSLocalizedString(@"Speakerphone", @""), NSLocalizedString(@"Use PIN", @""), NSLocalizedString(@"Info", @""), NSLocalizedString(@"contact", @""), NSLocalizedString(@"Privacy Settings", @""), NSLocalizedString(@"help_contact", @""), NSLocalizedString(@"emergency_contact", @""), NSLocalizedString(@"Terms of service", @""), NSLocalizedString(@"Send log in e-mail", @"")];
#endif
    [self setNeedsStatusBarAppearanceUpdate];
}

//This code hides an unwanted keyboard.
- (void)viewDidAppear:(BOOL)animated {
    UITextField* tf = [[UITextField alloc] initWithFrame:CGRectMake(-10, -10, 5, 5)];
    [self.view addSubview:tf];
    [tf becomeFirstResponder];
    [tf endEditing:true];
}

#pragma mark - IBActions

-(IBAction) closeSettingsView:(id)sender {
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:
     UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}


/*- (IBAction)showMore:(id)sender {
 MoreSettingsViewController* msvc = [[MoreSettingsViewController alloc] init];
 UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:msvc];
 nvc.navigationBarHidden = NO;
 nvc.navigationBar.translucent = NO;
 [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
 }*/


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDelegate Functions

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return settingsArray.count;
    }
    return moreSettingArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        [cell setCell:indexPath.row datasource:settingsArray[indexPath.row]];

        return  cell;

    }else{
        MoreSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreSettingCell"];
        [cell setCell:indexPath.row title:moreSettingArray[indexPath.row]];
        cell.alertDelegate = self;
        return  cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        [self showDetail:indexPath.row];
    }else{
        [self showMoreSectionDetail:indexPath.row];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 10, 284, 27);
    label.textColor = [UIColor colorNamed:@"color_text"];
    label.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    label.backgroundColor = [UIColor clearColor];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    // header.backgroundColor = [UIColor redColor];

    UIView *viewI = [[UIView alloc] init];

    viewI.frame = CGRectMake(10, 10, tableView.bounds.size.width-20, 52);
    viewI.backgroundColor = REDESIGN_COLOR_CANCEL;
    viewI.layer.cornerRadius = 8.0;

    if (section == 0) {
        label.text = [NSLocalizedString(@"common_settings", @"") uppercaseString];
        [viewI addSubview:label];
    }else{
        label.text = [NSLocalizedString(@"More_settings", @"") uppercaseString];
        [viewI addSubview:label];
    }
    [header addSubview:viewI];
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}


#pragma mark - private functions

- (void)showDetail:(NSInteger)index {
    switch (index) {
        case 0:
            [self showUserAccount];
            break;
        case 1:
            [self showIndoorLocation];
            break;
        case 2:
            [self showSensitivity];
            break;
        case 3:
            [self showAccessories];
            break;
        case 4:
            [self showHistory];
            break;
        default:
            break;
    }
}

- (void)showMoreSectionDetail:(NSInteger)index {
#ifdef OPUS
    if (index >= 10) {
        index += 2;
    }
#endif
    switch (index) {
        case 7:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"URL_MANUAL", @"")] options:@{} completionHandler:nil];
            break;
        case 8:
            if ([MFMailComposeViewController canSendMail]) {
                // Show the composer
                NSString *mailSubject = NSLocalizedStringFromTable(@"Alerty feedback", @"Target", @"");
                MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                [controller setMailComposeDelegate:self];
                [controller setSubject:mailSubject];
                [controller setToRecipients:[NSArray arrayWithObject:@"support@getalerty.com"]];
                [controller.navigationBar setTintColor: UIColor.blueColor];
                if (controller) {
                    [self presentViewController:controller animated:YES completion:^{
                        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                    }];
                }
            }
            break;
        case 9:
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            break;
        case 10:
            [self showHelp];
            break;
        case 11:
            [self showEmergency];
            break;
        case 12:
            [self showTos];
            break;
        case 13:
            [[AlertyAppDelegate sharedAppDelegate] composeEmailWithDebugAttachment];
            break;
        default:
            break;
    }
}

#pragma mark - Navigation functions


- (void)showUserAccount {
    UserAccountViewController* usvc = [[UserAccountViewController alloc] initWithNibName:@"UserAccountViewController" bundle:nil];
    usvc.title = NSLocalizedString(@"User account", @"");
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:usvc];
    nvc.navigationBarHidden = NO;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}

- (void)showIndoorLocation {
    IndoorLocationingViewController* ilvc = [[IndoorLocationingViewController alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:ilvc];
    nvc.navigationBarHidden = NO;
    nvc.navigationBar.translucent = YES;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}

- (void)showSensitivity {
    MotionViewController* motionViewController = [[MotionViewController alloc] init];
    motionViewController.title = NSLocalizedString(@"Sensitivity", @"");
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:motionViewController];
    nvc.navigationBarHidden = NO;
    nvc.navigationBar.translucent = YES;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}


- (void)showAccessories {
    HeadsetViewController* headsetViewController = [[HeadsetViewController alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:headsetViewController];
    nvc.navigationBarHidden = NO;
    nvc.navigationBar.translucent = YES;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}

- (void)showHistory {
    VideoListViewController *historyViewController = [[VideoListViewController alloc] initWithNibName:@"VideoListViewController" bundle:nil];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:historyViewController];
    nvc.navigationBarHidden = NO;
    nvc.navigationBar.translucent = YES;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}


- (void) showTos {
    NSString *lang = [[AlertyAppDelegate language] substringToIndex:2];
    NSString *htmlPage = nil;
    if ([lang isEqualToString:@"sv"]) {
#ifdef OPUS
        htmlPage = @"https://sites.google.com/innovationpush.com/opuslf-anvandarvillkor/home";
#else
        htmlPage = @"https://getalerty.se/allmanna-villkor/";
#endif
    }
    else {
#ifdef OPUS
        htmlPage = @"https://sites.google.com/innovationpush.com/opuslf-toc/home";
#else
        htmlPage = @"https://www.getalerty.com/general-terms/";
#endif
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:htmlPage] options:@{} completionHandler:nil];

}

-(void) showHelp{
    EmergencyContactViewController* vc = [[EmergencyContactViewController alloc] initWithNibName:@"EmergencyContactViewController" bundle:nil];
    vc.isEmergencyContact = NO;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = NO;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}

-(void) showEmergency{
    EmergencyContactViewController* vc = [[EmergencyContactViewController alloc] initWithNibName:@"EmergencyContactViewController" bundle:nil];
    vc.isEmergencyContact = YES;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = NO;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error; {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
