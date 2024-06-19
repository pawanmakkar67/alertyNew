//
//  CreateAccountViewController.m
//  Koponyeg
//
//  Created by Mekom Ltd. on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NSExtensions.h"
#import "CreateAccountViewController.h"
#import "AlertyAppDelegate.h"
#import "AlertyDBMgr.h"
#import "AlertySettingsMgr.h"
#import "DataManager.h"
#import "AddNumberViewController.h"
#import "PermissionsViewController.h"
#import "HoshiTextField.h"
#import "MobileInterface.h"


@interface CreateAccountViewController () <ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate> {
	BOOL newContactAdded;
}

@property (readwrite,strong) UITapGestureRecognizer *tapGestureRecognizer;

// personal properties
@property (weak, nonatomic) IBOutlet HoshiTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet HoshiTextField *userPINTextField;
//@property (weak, nonatomic) IBOutlet HoshiTextField *referralTextField;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
    
@property (weak, nonatomic) IBOutlet HoshiTextField *emailTextField;
@property (weak, nonatomic) IBOutlet HoshiTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet HoshiTextField *passwordRepeatTextField;

@property (weak, nonatomic) IBOutlet UIButton *contactsNextButton;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@property (nonatomic, strong) NSString* contactName;
@property (nonatomic, strong) NSString* contactPhone;

@property (nonatomic, strong) GWCall* setReferralCall;
@property (nonatomic, strong) GWCall* createAccountCall;

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *page2ScrollView;
@property (weak, nonatomic) IBOutlet UIView *alertyDescription;
//@property (weak, nonatomic) IBOutlet UILabel *whiteLabelDescription;

@property (weak, nonatomic) IBOutlet UILabel *companyUser;
@property (weak, nonatomic) IBOutlet UILabel *companyUserDescription;
@property (weak, nonatomic) IBOutlet UILabel *individualUserDescription;
@property (weak, nonatomic) IBOutlet UILabel *individualUser;

@property (strong, nonatomic) UITapGestureRecognizer* gestureRecognizer;

    
@end

@implementation CreateAccountViewController

@synthesize tapGestureRecognizer = _tapGestureRecognizer;

#pragma mark - Overrides

- (void)dealloc {
	[self.view removeGestureRecognizer:_tapGestureRecognizer];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //TODO: move it to Localizable.strings
    self.companyUser.text = NSLocalizedString(@"Company user", @"Company user");
    self.companyUserDescription.text = NSLocalizedString(@"As a business user, you can not create an account here. Please contact info@getalerty.com", @"As a business user, you can not create an account here. Please contact info@getalerty.com");
    self.individualUser.text = NSLocalizedString(@"Individual user", @"Individual user");
    self.individualUserDescription.text = NSLocalizedString(@"Enter the email address and password.", @"Enter the email address and password.");
    self.passwordRepeatTextField.placeholder = NSLocalizedString(@"Repeat password", @"Repeat password");
    self.navigationItem.title = NSLocalizedString(@"Create account", @"Create account");
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	//[self.userNameTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
	//[self.userPINTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
	//[self.contactTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    //[self.referralTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    //[self.emailTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    //[self.passwordTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    //[self.passwordRepeatTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.contactTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"+ Add contact", @"+ Add contact") attributes:@{ NSFontAttributeName: self.contactTextField.font, NSForegroundColorAttributeName: UIColor.whiteColor }];
    
	[self loadFriend];
	[self subscribeToNotifications];
	
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	_tapGestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:_tapGestureRecognizer];
    
    self.contactsNextButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.contactsNextButton.layer.cornerRadius = 4.0;
    self.createAccountButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.createAccountButton.layer.cornerRadius = 4.0;
    [self.createAccountButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabel:)];
    // This if-statement is copied from SignInViewController.m
#if !defined(ALERTY)
    //.whiteLabelDescription.hidden = NO;
    self.alertyDescription.hidden = YES;
    
    /*NSString* text = self.whiteLabelDescription.text;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
                                                                                                                      NSFontAttributeName : self.whiteLabelDescription.font,
                                                                                                                      NSForegroundColorAttributeName: self.whiteLabelDescription.textColor}];
    NSRange linkRange = [text rangeOfString:@"info@getalerty.com"];
    [attributedString setAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:linkRange];
    self.whiteLabelDescription.attributedText = attributedString;
    [self.whiteLabelDescription addGestureRecognizer:self.gestureRecognizer];
    
    self.idField.placeholder = NSLocalizedString(@"LOGIN_PLACEHOLDER_WHITELABEL", @"");*/
    
#else
   /* NSString* text = self.companyUserDescription.text;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{

                                                                                                                      NSFontAttributeName : self.whiteLabelDescription.font,
                                                                                                                      NSForegroundColorAttributeName: self.whiteLabelDescription.textColor}];
    NSRange linkRange = [text rangeOfString:@"info@getalerty.com"];
    [attributedString setAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:linkRange];
    self.companyUserDescription.attributedText = attributedString;*/
    
    [self.companyUserDescription addGestureRecognizer:self.gestureRecognizer];
#endif
}

- (void)didTapLabel:(id)sender {
#if defined(OPUS) || defined(SAKERHETSAPPEN)
    NSRange range = [self.companyUserDescription.text rangeOfString:@"info@getalerty.com"];
    BOOL didTap = [self didTapAttributedTextInLabel:self.companyUserDescription inRange:range];
#else
    NSRange range = [self.companyUserDescription.text rangeOfString:@"info@getalerty.com"];
    BOOL didTap = [self didTapAttributedTextInLabel:self.companyUserDescription inRange:range];
#endif
    if (didTap) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"mailto:info@getalerty.com"] options:@[] completionHandler:nil];
    }
}

- (void) closePressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didTap:(id)sender {
	UIView *responder = [self.view findFirstResponder];
	[responder resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	[DataManager sharedDataManager].subscribing = YES;

	[self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[DataManager sharedDataManager].subscribing = NO;
	
	[self removeObservers];
}

#pragma mark - Private methods

- (BOOL) isTextAllDigits:(NSString *)text {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [text rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

- (void) subscribeToNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinishedNotification:) name:kSyncFinishedNotification object:nil];
}

- (void)loadFriend {
	NSArray *friends = [[AlertyDBMgr sharedAlertyDBMgr] getAllContacts];
	if (friends.count) {
		Contact *contact = [friends objectAtIndex:0];
		NSString* name = contact.name;
		NSString* phone = contact.phone;
		if (!name.length) {
			name = [[DataManager sharedDataManager] lookupFriendNameByPhone:phone];
		}
		self.contactName = name;
		self.contactPhone = phone;
        self.contactTextField.text = name;
	}
}

- (void) setUserName:(NSString*)userName andUserPIN:(NSString*)userPIN {
    [AlertySettingsMgr setUserName:userName];
    [AlertySettingsMgr setUserPIN:userPIN];
    [[DataManager sharedDataManager] getUserSettings];
}

- (void) scrollToPage:(int)page animated:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(page*self.scrollView.frame.size.width, 0) animated:animated];
}

#pragma mark - Web service calls

- (void) createAccount:(NSString*)userEmail pass:(NSString*)userPass {
    
    [AlertySettingsMgr setBusinessVersion:NO];
    
    NSDictionary* body = @{ @"imei" : DEVICE_ID, @"email" : userEmail, @"pass" : userPass, @"lang":@"sv"};
    [MobileInterface postForString:CREATE_ACCOUNT_URL body:body completion:^(NSString *result, NSString *errorMessage) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            int error = [result intValue];
            if( error == 0 ||        // no error
                error == -1 )        // user already exists
            {
                // mark user as subscription type user
                //[AlertySettingsMgr setBusinessType:kBusinessTypeSubscription];
                // store groupid in nsuserdefaults
                //[AlertySettingsMgr setValidSubscription:YES];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[DataManager sharedDataManager] getUserSettings];
                // finished subscribing
                [DataManager sharedDataManager].subscribing = YES;
                [[DataManager sharedDataManager] startSynchronization];
                [self scrollToPage:1 animated:YES];
            }
            else {
                NSString* message = NSLocalizedString(@"The specified account and/or the password is incorrect.", @"The specified account and/or the password is incorrect.");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self showWaitView:NO animated:YES];
        }];
    }];
    
    /*self.createAccountCall = [GWCall dataCall:self
                               baseURL:CREATE_ACCOUNT_URL
                            parameters:get
                              userInfo:nil];*/
}

#pragma mark - NSNotification handlers

- (void) syncFinishedNotification:(NSNotification*)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self loadFriend];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)alertOK:(id)sender {
	UIViewController* vc = self.parentViewController;
	if (vc == nil) vc = self.presentingViewController;
	[vc dismissControllerAnimated:YES];
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WizardFinished"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)contactsNextButtonPressed:(id)sender {
	
	if (!self.userNameTextField.text.length) {
		[self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please specify a Username.", @"") :@"OK"];
		return;
	}
	if (!self.userPINTextField.text.length) {
		[self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please choose a PIN code.", @"") :@"OK"];
		return;
	}
	if (self.contactPhone == NULL) {
		[self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please select a contact!", @"") :@"OK"];
		return;
	}

    [self setUserName:self.emailTextField.text  andUserPIN:self.userPINTextField.text];
    
    [DataManager.sharedDataManager storeUserSettings: self.userNameTextField.text
                                                 pin: AlertySettingsMgr.userPIN];
    
	/*if (self.referralTextField.text.length > 0) {
		[self setReferralCode:self.referralTextField.text];
	}*/
	
	// save it to server-db also
	if (newContactAdded) {
		[[DataManager sharedDataManager] sendSosInvitationTo:self.contactPhone Name:self.contactName == nil ? @"":self.contactName Position:0];
	}
	
    if ([AlertySettingsMgr UserPhoneNr].length == 0) {
        AddNumberViewController* vc = [[AddNumberViewController alloc] initWithNibName:@"AddNumberViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PermissionsViewController* pvc = [[PermissionsViewController alloc] initWithNibName:@"PermissionsViewController" bundle:nil];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

- (void)addContact:(id)sender {
	// login&contacts view
	if (!self.userNameTextField.text.length) {
		[self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please specify a Username.", @"") :@"OK"];
		return;
	}
	if (!self.userPINTextField.text.length) {
		[self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please choose a PIN code.", @"") :@"OK"];
		return;
	}
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        [self showAlert:NSLocalizedString(@"No permission", @"") :NSLocalizedString(@"This App has no permission to access your contacts. Please check it in your privacy settings of your device.", @"") :@"OK"];
        return;
    }
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self addContact:sender];
            }];
        });
        return;
    }
    
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	if (picker){	
		picker.peoplePickerDelegate = self;
		NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
		picker.displayedProperties = displayedItems;
		[self presentViewController:picker animated:YES completion:nil];
		//[self presentModalViewController:picker animated:YES];
	}
}

/*- (void) setReferralCode:(NSString*) code {
    NSDictionary *get = _nsdictionary(_nsdictionary(code, @"code", [NSNumber numberWithInteger:[AlertySettingsMgr userID]], @"user"), GWMethodGETKey);
    self.setReferralCall = [GWCall dataCall:self
                                    baseURL:SETREFERRAL_URL
                                 parameters:get
                                   userInfo:nil];
}*/

- (IBAction)createAccountNextButtonPressed:(id)sender {
    
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordRepeatTextField resignFirstResponder];
    
    if (!self.emailTextField.text.length || !self.emailTextField.text.isEmail) {
        [self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please check email address!", @"") :@"OK"];
        return;
    }
    if (!self.passwordTextField.text.length) {
        [self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Please fill password fields!", @"") :@"OK"];
        return;
    }
    if (self.passwordTextField.text.length < 4) {
        [self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"Password must be at least 4 characters!", @"") :@"OK"];
        return;
    }
    if (![self.passwordRepeatTextField.text isEqualToString:self.passwordTextField.text]) {
        [self showAlert:NSLocalizedString(@"Form error", @"") :NSLocalizedString(@"The entered passwords are different!", @"") :@"OK"];
        return;
    }
    
    //self.userEmail = self.createAccountEmailTextField.text;
    //self.userPassword = self.createAccountPasswordTextField.text;
    
    [self createAccount:self.emailTextField.text pass:self.passwordTextField.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == self.userPINTextField)
    {
		if (![string length]) {
			self.contactsNextButton.enabled = NO;
			return YES;
		}
        if ([textField.text length] + [string length] == 4)
        {
			if ([self isTextAllDigits:textField.text]) {
				textField.text = [textField.text stringByAppendingString:string];
				[textField resignFirstResponder];
				self.contactsNextButton.enabled = YES;
				return YES;
			}
			else {
				return NO;
			}
        } else {
            self.contactsNextButton.enabled = NO;
        }
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.userNameTextField) {
		[textField resignFirstResponder];
		[self.userPINTextField becomeFirstResponder];
	}
    else if (textField == self.userPINTextField) {
    }
    else if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.passwordRepeatTextField becomeFirstResponder];
    }
    else {
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // add top edge/border to Number Pad
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0 / [UIScreen mainScreen].scale)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    textField.inputAccessoryView = separatorView;
    
    if (textField == self.contactTextField) {
        [self addContact:nil];
        return NO;
    }
    return YES;
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	return YES;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	[self didSelectPerson:person property:property identifier:identifier];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	[self didSelectPerson:person property:property identifier:identifier];
	return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self dismissControllerAnimated:YES];
}

- (void) didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	ABMultiValueRef phoneProperty = ABRecordCopyValue(person, property);
	long idx = ABMultiValueGetIndexForIdentifier(phoneProperty, identifier);
	NSString *phone = (NSString *)CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneProperty, idx));
	CFRelease(phoneProperty);
	[self dismissControllerAnimated:YES];
	
	if( [phone rangeOfString:@"00"].location != 0 && [phone rangeOfString:@"+"].location != 0) {
		[self showAlert:@"" : NSLocalizedString(@"The mobile phone number must be in international format (e.g. +46708123456). Please change the number.", @"") : NSLocalizedString(@"OK", @"")];
	}
	else {
		[[AlertyDBMgr sharedAlertyDBMgr] addActiveGroupIfNoneFound];
		if( ![[AlertyDBMgr sharedAlertyDBMgr] doesContactExistWithPhone:phone] ) {
			NSMutableDictionary *friend = [NSMutableDictionary dictionary];
			[friend setObject:phone forKey:@"phone"];
			[friend setObject:@"" forKey:@"name"];
			[friend setObject:[NSNumber numberWithInt:0] forKey:@"type"];
			[friend setObject:[NSNumber numberWithInt:0] forKey:@"status"];
			Group *group = [[AlertyDBMgr sharedAlertyDBMgr] getActiveGroup];
			[[AlertyDBMgr sharedAlertyDBMgr] addContactFromDictionary:friend toGroup:group];
			
			NSString *name = [[DataManager sharedDataManager] lookupFriendNameByPhone:phone];
			self.contactName = name;
			self.contactPhone = phone;
			newContactAdded = YES;
			
			[self loadFriend];
		}
		else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Contact already on list.", @"Contact already on list.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
		}
	}
}

#pragma mark keyboard observers

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UIKeyboardWillHideNotification" object:nil];
}

// keyboard hadlers to override
- (void) keyboardWillShow:(NSNotification*)notification {

    //get the end position keyboard frame
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //convert it to the same view coords as the tableView it might be occluding
    keyboardFrame = [self.scrollView convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrame, self.page2ScrollView.bounds);
    if (!CGRectIsNull(intersect)) {
        //yes they do - adjust the insets on tableview to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        // adjust the animation curve - untested
        NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
        //change the table insets to match - animated to the same duration of the keyboard appearance
        [UIView animateWithDuration:duration delay:0.0 options:curve animations: ^{
            self.page2ScrollView.contentInset = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
            self.page2ScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, intersect.size.height, 0);
        } completion:nil];
    }
}

- (void) keyboardWillHide:(NSNotification*)notification {
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    //change the table insets to match - animated to the same duration of the keyboard appearance
    [UIView animateWithDuration:duration delay:0.0 options:curve animations: ^{
        self.page2ScrollView.contentInset = UIEdgeInsetsZero;
        self.page2ScrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
    } completion:nil];
}

- (BOOL)didTapAttributedTextInLabel:(UILabel *)label inRange:(NSRange)targetRange {
    NSParameterAssert(label != nil);
    
    CGSize labelSize = label.bounds.size;
    // create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:label.attributedText];
    
    // configure layoutManager and textStorage
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    // configure textContainer for the label
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = label.lineBreakMode;
    textContainer.maximumNumberOfLines = label.numberOfLines;
    textContainer.size = labelSize;
    
    // find the tapped character location and compare it to the specified range
    CGPoint locationOfTouchInLabel = [self.gestureRecognizer locationInView:label];
    CGRect textBoundingBox = [layoutManager usedRectForTextContainer:textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                       inTextContainer:textContainer
                              fractionOfDistanceBetweenInsertionPoints:nil];
    if (NSLocationInRange(indexOfCharacter, targetRange)) {
        return YES;
    } else {
        return NO;
    }
}


@end
