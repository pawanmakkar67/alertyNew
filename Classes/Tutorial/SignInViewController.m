//
//  SignInViewController.m
//  Koponyeg
//
//  Created by Mekom Ltd. on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NSExtensions.h"
#import "SignInViewController.h"
#import "AlertyAppDelegate.h"
#import "AlertyDBMgr.h"
#import "AlertySettingsMgr.h"
#import "DataManager.h"
#import "AddNumberViewController.h"
#import "PermissionsViewController.h"
#import "HoshiTextField.h"
#import "VerifyPhoneViewController.h"
#import "MobileInterface.h"


@interface SignInViewController () <UITextFieldDelegate> {
}

@property (weak, nonatomic) IBOutlet HoshiTextField *idField;
@property (weak, nonatomic) IBOutlet HoshiTextField *pinField;
@property (nonatomic, strong) IBOutlet UIButton	*loginButton;
@property (nonatomic, strong) UITextField *lostPasswordField;

@property (weak, nonatomic) IBOutlet UIView *alertyDescription;
@property (weak, nonatomic) IBOutlet UILabel *alertyIndividual;

@property (strong, nonatomic) UITapGestureRecognizer* gestureRecognizer;

@property (weak, nonatomic) IBOutlet UIButton *lostPasswordButton;

@property (readwrite,strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *companyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *companySignInLabel;
@property (weak, nonatomic) IBOutlet UILabel *privateUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *privateSignInLabel;

@end

@implementation SignInViewController

#pragma mark - Overrides

- (void)dealloc {
	[self.view removeGestureRecognizer:_tapGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = [NSLocalizedString(@"Sign in", @"Sign in") uppercaseString];
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	self.personalLogin = NO;

	/*[self.idField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
	[self.pinField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];*/
	
    self.idField.text = [AlertySettingsMgr lastUserID];
    self.pinField.text = AlertySettingsMgr.lastAuthCode;
    self.loginButton.enabled = self.pinField.text.length;
    
    self.loginButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.loginButton.layer.cornerRadius = 4.0;
    [self.loginButton setTitle:NSLocalizedString(@"Sign in", @"Sign in") forState:UIControlStateNormal];

    [self.lostPasswordButton setTitle:NSLocalizedString(@"LOGIN_FORGOTTEN_PASSWORD", @"") forState:UIControlStateNormal];
    
	self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	_tapGestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:_tapGestureRecognizer];
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapLabel:)];
#if !defined(ALERTY)
    
    self.companyUserLabel.hidden = YES;
    /*self.companySignInLabel.text = NSLocalizedStringFromTable(@"WELCOME_WHITELABEL", @"Target", @"");*/
    self.privateUserLabel.hidden = YES;
    self.privateSignInLabel.hidden = YES;
    
    //self.whiteLabelDescription.hidden = NO;
    //self.alertyDescription.hidden = YES;
    
    NSString* text = NSLocalizedStringFromTable(@"WELCOME_WHITELABEL", @"Target", @"");
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName : self.companySignInLabel.font,
        NSForegroundColorAttributeName: self.companySignInLabel.textColor}];
#ifndef SAKERHETSAPPEN
    NSRange linkRange = [text rangeOfString:@" " options:NSBackwardsSearch];
    if (linkRange.location != NSNotFound) {
        linkRange = NSMakeRange(linkRange.location+1, text.length - linkRange.location - 1);
        [attributedString setAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:linkRange];
    }
    self.companySignInLabel.attributedText = attributedString;
    [self.companySignInLabel addGestureRecognizer:self.gestureRecognizer];
#endif
    /*self.whiteLabelDescription.attributedText = attributedString;
    self.idField.placeholder = NSLocalizedString(@"LOGIN_PLACEHOLDER_WHITELABEL", @"");*/
    
#else
    /*NSString* text = self.alertyIndividual.text;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
                                                                                                                      NSFontAttributeName : self.whiteLabelDescription.font,
                                                                                                                      NSForegroundColorAttributeName: self.whiteLabelDescription.textColor}];
    NSRange linkRange = [text rangeOfString:@"info@getalerty.com"];
    [attributedString setAttributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)} range:linkRange];
    self.alertyIndividual.attributedText = attributedString;*/

    [self.alertyIndividual addGestureRecognizer:self.gestureRecognizer];
#endif
}

- (void)didTapLabel:(id)sender {
    NSLog(@"didTap");
#if defined(OPUS) || defined(SAKERHETSAPPEN)
    NSRange range = [self.companySignInLabel.text rangeOfString:@"info@getalerty.com"];
    BOOL didTap = [self didTapAttributedTextInLabel:self.companySignInLabel inRange:range];
    if (didTap) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"mailto:getalerty.com"] options:@{} completionHandler:nil];
    }
    /*NSString* text = NSLocalizedStringFromTable(@"WELCOME_WHITELABEL", @"Target", @"");
    NSRange linkRange = [text rangeOfString:@" " options:NSBackwardsSearch];
    if (linkRange.location != NSNotFound) {
        linkRange = NSMakeRange(linkRange.location+1, text.length - linkRange.location - 1);
        BOOL didTap = [self didTapAttributedTextInLabel:self.whiteLabelDescription inRange:linkRange];
        if (didTap) {
            NSString* mailto = [NSString stringWithFormat:@"mailto:%@", [text substringFromIndex:linkRange.location]];
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:mailto]];
        }
    }*/
#else
    NSRange range = [self.alertyIndividual.text rangeOfString:@"info@getalerty.com"];
    BOOL didTap = [self didTapAttributedTextInLabel:self.alertyIndividual inRange:range];
    if (didTap) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:@"mailto:info@getalerty.com"] options:@{} completionHandler:nil];
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [DataManager sharedDataManager].subscribing = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncFinishedNotification:) name:kSyncFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationSuccessful:) name:kNotifRegistrationSuccessful object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationFailed:) name:kNotifRegistrationFailed object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(userIdChanged) name:kUserIdReceivedNotification object:nil];
}

- (void) userIdChanged {
    if (!self.idField.text.length) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            self.idField.text = [AlertySettingsMgr lastUserID];
            [self.idField animateViewsForTextEntry];
        }];
    }
}

- (void) closePressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) didTap:(id)sender {
	UIView *responder = [self.view findFirstResponder];
	[responder resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[DataManager sharedDataManager].subscribing = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods

- (BOOL) isTextAllDigits:(NSString *)text {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [text rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

/*- (void)next:(int)toPage {
	int page = [self currentPage];
	int nextPage = page + 1;
	if (![AlertySettingsMgr isBusinessVersion] && nextPage == 3 && [AlertySettingsMgr UserPhoneNr].length == 0) {
		AddNumberViewController* vc = [[AddNumberViewController alloc] initWithNibName:@"AddNumberViewController" bundle:nil];
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		[self scrollToPage:((toPage >= 0) ? toPage : nextPage) animated:YES];
	}
}*/

- (void) setUserName:(NSString*)userName andUserPIN:(NSString*)userPIN {
	[AlertySettingsMgr setUserName:userName];
	[AlertySettingsMgr setUserPIN:userPIN];
	[[DataManager sharedDataManager] getUserSettings];
}

#pragma mark - Web service calls

- (void) registerNewBizUser {
  	[AlertySettingsMgr setBusinessVersion:YES];
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self showWaitView:YES animated:YES];
    [AlertySettingsMgr setLastUserID:self.idField.text];
    [AlertySettingsMgr setLastAuthCode:self.pinField.text];
	[[DataManager sharedDataManager] registerNewBizUser:self.idField.text pincode:self.pinField.text];
}

- (void) login:(NSString*)userEmail pass:(NSString*)userPass {
	[AlertySettingsMgr setBusinessVersion:NO];
    NSDictionary* post = @{ @"imei" : DEVICE_ID, @"email" : userEmail, @"pass" : userPass};
    [MobileInterface postForString:LOGIN_URL body:post completion:^(NSString *result, NSString *errorMessage) {
        
        NSArray* results = [result componentsSeparatedByString:@"|"];
        int error = [results[0] intValue];
        if (error == -1 ) {
            // mark user as subscription type user
            //[AlertySettingsMgr setBusinessType:kBusinessTypeSubscription];
            // store groupid in nsuserdefaults
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [AlertySettingsMgr setUserEmail:self.idField.text];
                [AlertySettingsMgr setUserName:self.idField.text];
                [AlertySettingsMgr setLastUserID:self.idField.text];
                [AlertySettingsMgr setUserPassword:self.pinField.text];
                [AlertySettingsMgr setLastAuthCode:self.pinField.text];
                [AlertySettingsMgr setUserPIN:results[1]];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[DataManager sharedDataManager] getUserSettings];
                // finished subscribing
                [DataManager sharedDataManager].subscribing = YES;
                [[DataManager sharedDataManager] startSynchronization];
            }];
        }
        else {

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString* message = NSLocalizedString(@"The specified account and/or the password is incorrect.", @"The specified account and/or the password is incorrect.");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                               message:message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
        [self showWaitView:NO animated:YES];
    }];

}

#pragma mark - NSNotification handlers

/**
 * Called on kTransactionSucceededNotification, kTransactionFailedNotification, kTransactionCanceledNotification notifications.
 */


- (void) registrationSuccessful:(NSNotification*)notification {
	[self showWaitView:NO animated:NO];
    
    PermissionsViewController* pvc = [[PermissionsViewController alloc] initWithNibName:@"PermissionsViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void) registrationFailed:(NSNotification*)notification {
	[self showWaitView:NO animated:NO];
	self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) syncFinishedNotification:(NSNotification*)notification {
    if (![AlertySettingsMgr isBusinessVersion]) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([AlertySettingsMgr UserPhoneNr].length == 0) {
                if (![self.navigationController.topViewController isKindOfClass:AddNumberViewController.class] &&
                    ![self.navigationController.topViewController isKindOfClass:VerifyPhoneViewController.class]) {
                    AddNumberViewController* vc = [[AddNumberViewController alloc] initWithNibName:@"AddNumberViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                if (![self.navigationController.topViewController isKindOfClass:PermissionsViewController.class] &&
                    ![self.navigationController.topViewController isKindOfClass:VerifyPhoneViewController.class]) {
                    PermissionsViewController* pvc = [[PermissionsViewController alloc] initWithNibName:@"PermissionsViewController" bundle:nil];
                    [self.navigationController pushViewController:pvc animated:YES];
                }
            }
        }];
    }
}


#pragma mark - IBActions

- (IBAction) checkLoginButtonPressed:(id)sender {
	[self.idField resignFirstResponder];
	[self.pinField resignFirstResponder];

    if ([self.idField.text containsString:@"@"]) {
        [self login:self.idField.text pass:self.pinField.text];
    } else {
        [self registerNewBizUser];
    }
}

- (IBAction)alertOK:(id)sender {
	UIViewController* vc = self.parentViewController;
	if (vc == nil) vc = self.presentingViewController;
	[vc dismissControllerAnimated:YES];
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WizardFinished"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

/*- (IBAction)getStartedSignInButtonPressed:(id)sender {
	cmdlog
	_wizardChosenButton = 0;
	[AlertySettingsMgr setBusinessVersion:YES];
	[AlertySettingsMgr setBusinessType:kBusinessTypeNormal];
	self.businessLogin = YES;
	[self setupWizardFrames];
	[self next:1];
}

- (IBAction)getStartedCreateAccountButtonPressed:(id)sender {
	cmdlog
	long tag = ((UIButton*)sender).tag;
	self.personalLogin = (tag == 99);
	self.TOSView.hidden = self.personalLogin;
	CGRect frame = self.createAccountNextButton.frame;
	frame.origin.y = self.personalLogin ? 142 : 186;
	self.createAccountNextButton.frame = frame;
	
	_wizardChosenButton = 1;
	[AlertySettingsMgr setBusinessType:kBusinessTypeSubscription];
	self.businessLogin = NO;
	[self setupWizardFrames];
	[self next:1];
	[self.createAccountTableView reloadData];
}*/

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == self.pinField) {
		if (![string length]) {
			self.loginButton.enabled = NO;
			return YES;
		}
        if (![self.idField.text containsString:@"@"]) {
            if ([textField.text length] + [string length] == 4) {
                if ([self isTextAllDigits:textField.text]) {
                    textField.text = [textField.text stringByAppendingString:string];
                    [textField resignFirstResponder];
                    self.loginButton.enabled = YES;
                    return YES;
                } else {
                    return NO;
                }
            } else {
                self.loginButton.enabled = NO;            
            }
        }
        else {
            self.loginButton.enabled = YES;
        }
	}
	return YES;
}

- (IBAction)textFieldChanged:(id)sender {
    //self.loginButton.enabled = self.pinField.text.length > 0;
}

/*- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
	if ([AlertySettingsMgr isBusinessVersion]) {
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.idField) {
        if ([self.idField.text containsString:@"@"]) {
            self.pinField.keyboardType = UIKeyboardTypeDefault;
        } else {
            self.pinField.keyboardType = UIKeyboardTypeNumberPad;
        }
        [self.pinField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)idFieldEditingEnd:(id)sender {
    if ([self.idField.text containsString:@"@"]) {
        self.pinField.keyboardType = UIKeyboardTypeDefault;
    } else {
        self.pinField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (IBAction)lostPasswordPressed:(id)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"FORGOTTEN_PASSWORD_TITLE", @"")
                                                                   message:NSLocalizedString(@"FORGOTTEN_PASSWORD_MESSAGE", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.lostPasswordField = textField;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"FORGOTTEN_PASSWORD_CANCEL", @"") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"FORGOTTEN_PASSWORD_SEND", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.lostPasswordField.text.length) {
            [MobileInterface postForString:RESET_PASSWORD_URL
                                      body:@{ @"email": self.lostPasswordField.text,
                                              @"language": NSLocalizedString(@"LANGUAGE", @"") }
                                completion:^(NSString *result, NSString *errorMessage) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                                   message:NSLocalizedString(@"FORGOTTEN_PASSWORD_SENT", @"")
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }];
            }];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // add top edge/border to Number Pad
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0 / [UIScreen mainScreen].scale)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    textField.inputAccessoryView = separatorView;
    return YES;
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
