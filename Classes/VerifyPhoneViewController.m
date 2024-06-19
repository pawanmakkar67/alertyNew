//
//  VerifyPhoneViewController.m
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "AlertySettingsMgr.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"
#import "PermissionsViewController.h"
#import "HoshiTextField.h"


@interface VerifyPhoneViewController() <GWCallDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;

@property (strong, nonatomic) IBOutlet HoshiTextField *txtVerificationCode;
@property (nonatomic, strong) GWCall *confirmPhoneCall;
@property (nonatomic, assign) int stage;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end


@implementation VerifyPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.navigationItem setTitle:NSLocalizedString(@"Verify Number", @"")];
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	self.txtVerificationCode.keyboardType = UIKeyboardTypeNumberPad;
	self.txtVerificationCode.returnKeyType = UIReturnKeyDone;
	//self.txtVerificationCode.font = [UIFont systemFontOfSize:17.0];
	//[self.txtVerificationCode setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];

    self.resendButton.layer.cornerRadius = 4.0;
    self.verifyButton.layer.cornerRadius = 4.0;
    self.verifyButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    
	self.stage = 0;
    [self requestCode:NO];
    self.navigationController.navigationBar.translucent = NO;
}

- (void) backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // add top edge/border to Number Pad
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0 / [UIScreen mainScreen].scale)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    textField.inputAccessoryView = separatorView;
    return YES;
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark IBActions

-(IBAction) closeVerifyPhoneViewController:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resend:(id)sender {
	self.stage = 1;
    [self requestCode:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestCode:(BOOL)force {
	[self.activityIndicator startAnimating];
	NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
    NSString* pin = [AlertySettingsMgr userPIN];
    NSString* language = NSLocalizedString(@"LANGUAGE", @"");
	NSString* phoneNrDotEnc = [self.phoneNr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary *get = _nsdictionary(_nsdictionary(userId, @"id", language, @"lang", phoneNrDotEnc, @"p", pin, @"pin", force ? @"1" : @"0", @"force",userId, @"userid"), GWMethodGETKey);
	self.confirmPhoneCall = [GWCall dataCall:self
									 baseURL:CONFIRMPHONE_URL
								  parameters:get
									userInfo:nil];
    NSLog(@"confirmPhoneCall %@",self.confirmPhoneCall);
}

- (void)verifyCode {
	self.stage = 2;
	[self.activityIndicator startAnimating];
	NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
    NSString* pin = [AlertySettingsMgr userPIN];
	NSString* language = NSLocalizedString(@"LANGUAGE", @"");
	NSString* phoneNrDotEnc = [self.phoneNr stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSDictionary *get = _nsdictionary(_nsdictionary(userId, @"id", language, @"lang", phoneNrDotEnc, @"p", self.txtVerificationCode.text, @"code", pin, @"pin",userId, @"userid"), GWMethodGETKey);
	self.confirmPhoneCall = [GWCall dataCall:self
									 baseURL:CONFIRMPHONE_URL
								  parameters:get
									userInfo:nil];
    
}

#pragma mark Buttons

- (IBAction)verify:(id)sender {
	[self verifyCode];
}

#pragma mark GWCallDelegate

- (void) gwCallDidSucceed:(GWCall*)gwCall {
	NSString* result = ((NSData*)[gwCall.response objectForKey:GWCRawDataResponseKey]).string;
	NSLog(@"%@", result);
	
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        if (self.stage == 0) {
            if ([result compare:@"1"] == NSOrderedSame) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"PHONENUMBER_ALREADY_EXISTS", @"")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"PHONENUMBER_ALREADY_EXISTS_PROCEED", @"")
                                                      otherButtonTitles:NSLocalizedString(@"Cancel", @""), nil];
                alert.tag = 1;
                [alert show];
            }
        } else if (self.stage == 1){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:NSLocalizedString(@"A new verification code were sent to you.", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
            [alert show];
        } else if (self.stage == 2) {
            if ([result compare:@"1"] == NSOrderedSame) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"The entered code was accepted.", @"")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
                alert.tag = 0;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:NSLocalizedString(@"The entered code is invalid. Please try again.", @"")
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    });
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        [AlertySettingsMgr setUserPhoneNr:self.phoneNr];
        //[self.navigationController popViewControllerAnimated:YES];
        if (self.showPermission) {
            PermissionsViewController* pvc = [[PermissionsViewController alloc] initWithNibName:@"PermissionsViewController" bundle:nil];
            [self.navigationController pushViewController:pvc animated:YES];
        } else {
            [[AlertyAppDelegate sharedAppDelegate].mainController dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (buttonIndex == 0) {
        [self requestCode:YES];
    } else {
        //[self.navigationController popViewControllerAnimated:YES];
        if (self.showPermission) {
            PermissionsViewController* pvc = [[PermissionsViewController alloc] initWithNibName:@"PermissionsViewController" bundle:nil];
            [self.navigationController pushViewController:pvc animated:YES];
        } else {
            [[AlertyAppDelegate sharedAppDelegate].mainController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
