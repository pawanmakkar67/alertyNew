//
//  AddNumberViewController.m
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddNumberViewController.h"
#import "AlertySettingsMgr.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"
#import "VerifyPhoneViewController.h"
#import "HoshiTextField.h"

@interface AddNumberViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@property (strong, nonatomic) IBOutlet HoshiTextField *txtVerificationCode;

@end


@implementation AddNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.navigationItem setTitle:NSLocalizedString(@"Verify phone number", @"")];
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(backPressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	self.txtVerificationCode.keyboardType = UIKeyboardTypePhonePad;
	self.txtVerificationCode.returnKeyType = UIReturnKeyDone;
	//[self.txtVerificationCode setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    self.txtVerificationCode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtVerificationCode.placeholder attributes:@{NSFontAttributeName: self.txtVerificationCode.font, NSForegroundColorAttributeName: self.txtVerificationCode.textColor}];
    
    self.verifyButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.verifyButton.layer.cornerRadius = 4.0;
    
    [_txtVerificationCode setDelegate:self];
}

- (void) backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
	if ([AlertySettingsMgr UserPhoneNr].length > 0) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

// doesn't work
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // add top edge/border to Number Pad
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0 / [UIScreen mainScreen].scale)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    textField.inputAccessoryView = separatorView;
    return YES;
}

#pragma mark -

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Buttons

- (IBAction)verify:(id)sender {
	[self.txtVerificationCode resignFirstResponder];
	
	if ([self.txtVerificationCode.text rangeOfString:@"00"].location != 0 && [self.txtVerificationCode.text rangeOfString:@"+"].location != 0) {
		[self showAlert:@"" : NSLocalizedString(@"The mobile phone number must be in international format (e.g. +46708123456). Please change the number.", @"") : NSLocalizedString(@"OK", @"")];
	} else {
		VerifyPhoneViewController* vc = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
		vc.phoneNr = self.txtVerificationCode.text;
        vc.showPermission = YES;
		[self.navigationController pushViewController:vc animated:YES];
	}
}



@end
