//
//  EmergencyContactInfoViewController.m
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 11..
//

#import "EmergencyContactInfoViewController.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"

@interface EmergencyContactInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;

@end

@implementation EmergencyContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"CREATE_EC_INFO_NAV", @"");

    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;

    self.titleLabel.text = NSLocalizedString(@"CREATE_EC_INFO_TITLE", @"");
    /*self.messageContentLabel.text = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_ALERT_CONTENT" : @"CREATE_HELP_ALERT_CONTENT", @"");*/

    self.linkButton.titleLabel.numberOfLines = 2;
    NSAttributedString* link = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"CREATE_EC_INFO_LINK", @"") attributes:@{ NSForegroundColorAttributeName: COLOR_ACCENT, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [self.linkButton setAttributedTitle:link forState:UIControlStateNormal];
}

- (IBAction)readMorePresseds:(id)sender {
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:NSLocalizedString(@"CREATE_EC_INFO_LINK", @"")] options:@{} completionHandler:nil];
}

- (void) closePressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = self.view.backgroundColor;
}

@end

