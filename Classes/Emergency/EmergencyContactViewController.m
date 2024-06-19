//
//  EmergencyContactViewController.m
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 11..
//

#import "EmergencyContactViewController.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"
#import "EmergencyContactInfoViewController.h"
@import Contacts;
@import ContactsUI;

@interface EmergencyContactViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageNoteLabel;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIImageView *helpImage;

@end

@implementation EmergencyContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.createBtn.layer.cornerRadius = 4.0;
    [self.createBtn setTitle:NSLocalizedString(@"Create", @"Create") forState:UIControlStateNormal];
    self.title = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_ALERT_NAV" : @"CREATE_HELP_ALERT_NAV", @"");

    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;

    self.titleLabel.text = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_ALERT_TITLE" : @"CREATE_HELP_ALERT_TITLE", @"");
    self.messageLabel.text = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_ALERT" : @"CREATE_HELP_ALERT", @"");
    self.messageContentLabel.text = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_ALERT_CONTENT" : @"CREATE_HELP_ALERT_CONTENT", @"");
    self.messageNoteLabel.text = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_ALERT_NOTE" : @"CREATE_HELP_ALERT_NOTE", @"");

    [self.createButton setTitle:NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_SAVE" : @"CREATE_HELP_SAVE", @"") forState:UIControlStateNormal];
    self.createButton.layer.cornerRadius = 25.0;

    if (self.isEmergencyContact) {
        self.helpImage.image = [UIImage imageNamed:@"create_alarm_contact"];

        NSAttributedString* link = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"CREATE_EC_LINK", @"") attributes:@{ NSForegroundColorAttributeName: COLOR_ACCENT, NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
        [self.linkButton setAttributedTitle:link forState:UIControlStateNormal];
    } else {
        [self.linkButton setTitle:@"" forState:UIControlStateNormal];
        self.linkButton.hidden = YES;
    }
}

- (IBAction)readMorePressed:(id)sender {
    EmergencyContactInfoViewController* vc = [[EmergencyContactInfoViewController alloc] initWithNibName:@"EmergencyContactInfoViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) closePressed {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = REDESIGN_COLOR_NAVIGATIONBAR;
}

- (IBAction)createPressed:(id)sender {

    CNMutableContact* contact = [[CNMutableContact alloc] init];
    contact.givenName = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_NAME" : @"CREATE_HELP_NAME", @"");
    contact.organizationName = @"Alerty";
    contact.note = NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_NOTE" : @"CREATE_HELP_NOTE", @"");
    contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"logo_blue"]);

    CNPhoneNumber* phoneNumber = [CNPhoneNumber phoneNumberWithStringValue:(self.isEmergencyContact ? @"+46766864415" : @"+46108848611")];
    CNLabeledValue* labeledValue = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:phoneNumber];
    contact.phoneNumbers = [contact.phoneNumbers arrayByAddingObject:labeledValue];
    CNSaveRequest* saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:contact toContainerWithIdentifier:nil];
    CNContactStore *store = [[CNContactStore alloc] init];
    NSError* error = nil;
    [store executeSaveRequest:saveRequest error:&error];

    //CNContactViewController* vc = [CNContactViewController viewControllerForContact:contact];
    //vc.allowsActions = YES;
    //vc.shouldShowLinkedContacts = YES;
    //vc.allowsEditing = YES;
    //[self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(self.isEmergencyContact ? @"CREATE_EC_SUCCESS" : @"CREATE_HELP_SUCCESS", @"") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
