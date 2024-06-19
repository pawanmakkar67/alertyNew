//
//  UserAccountViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "config.h"
#import "NSHelpers.h"
#import "DataManager.h"
#import "AlertyAppDelegate.h"
#import "ICEContactCell.h"
#import "NSBundleAdditions.h"
#import "CGDrawingAdditions.h"
//#import "DrawView.h"
#import "NSExtensions.h"
#import "AlertySettingsMgr.h"
#import "VerifyPhoneViewController.h"

#define kUserSettingsViewControllerLabelColor [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0]

@interface UserAccountViewController () {
	BOOL					_pinChanged;
}

@property (nonatomic, strong) UITableView *userSettingsTableView;

@property (nonatomic, strong) UILabel         *userLabel;
@property (nonatomic, strong) UITextField		*txtName;
@property (nonatomic, strong) UITextField		*txtPin;
@property (nonatomic, strong) UITextField		*txtPhoneNr;

@property (nonatomic, strong) UIButton			*confirmPhoneButton;

@property (nonatomic, strong) UILabel *personalInfo;
@property (nonatomic, strong) UILabel *accountInfo;
@property (nonatomic, strong) UITextField* fullNameTextField;

@end

@implementation UserAccountViewController


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
}


//alertTitle, alertMessage

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
	
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleDone target:self action:@selector(saveUserAccountData)];
    self.navigationItem.rightBarButtonItem = backButtonItem;
    
	[self.userSettingsTableView setBackgroundView:nil];
	self.title = NSLocalizedString(@"User account", @"");
        
    self.personalInfo = [[UILabel alloc] init];
    self.personalInfo.text = NSLocalizedString(@"PERSONAL INFORMATION", @"");
    //self.personalInfo.backgroundColor = REDESIGN_COLOR_CANCEL;

    self.personalInfo.textColor = [UIColor colorNamed:@"color_text"];
    self.personalInfo.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.personalInfo.frame = CGRectMake(15, 0, 300, 45);
    self.personalInfo.numberOfLines = 1;
    self.personalInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.fullNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 170, 26)];
    self.fullNameTextField.placeholder = NSLocalizedString(@"ex. John Appleseed", @"");
    self.fullNameTextField.textColor = [UIColor colorNamed:@"color_text"];
    self.fullNameTextField.textAlignment = NSTextAlignmentRight;
    self.fullNameTextField.font = [UIFont fontWithName:@"Lato-Regular" size:14];

    //[self.fullNameTextField setValue:[UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    self.fullNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.accountInfo = [[UILabel alloc] init];
    self.accountInfo.backgroundColor = [UIColor clearColor];
    self.accountInfo.text = NSLocalizedString(@"ACCOUNT INFORMATION", @"");

    self.accountInfo.textColor = [UIColor colorNamed:@"color_text"];
    self.accountInfo.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.accountInfo.frame = CGRectMake(15, 0, 300, 45);
    self.accountInfo.numberOfLines = 1;
    self.accountInfo.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
	self.userLabel = [[UILabel alloc] init];
	self.userLabel.backgroundColor = [UIColor clearColor];
	self.userLabel.text = [NSLocalizedString(@"Name and PIN-code:", @"") uppercaseString];
	self.userLabel.textColor = [UIColor colorNamed:@"color_text"];
    self.userLabel.font = [UIFont systemFontOfSize:14];
	self.userLabel.frame = CGRectMake(15, 10, 300, 27);
	self.userLabel.numberOfLines = 1;

	self.txtName = [[UITextField alloc] initWithFrame:CGRectMake(125, 10, 175, 26)];
	self.txtName.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.txtName.font = [UIFont fontWithName:@"Lato-Regular" size:14];

	self.txtPin = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 190, 26)];
	self.txtPin.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.txtPin.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.txtPin.secureTextEntry = YES;

	self.txtPhoneNr = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 190, 26)];
	self.txtPhoneNr.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.txtPhoneNr.font = [UIFont fontWithName:@"Lato-Regular" size:14];

	self.confirmPhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 5, 286, 50)];
    [self.confirmPhoneButton setBackgroundImage:[UIImage imageNamed:@"button_enable"] forState:UIControlStateNormal];
	[self.confirmPhoneButton setBackgroundImage:[UIImage imageNamed:@"button_Gray.png"] forState:UIControlStateDisabled];
	[self.confirmPhoneButton setAdjustsImageWhenDisabled:NO];
	[self.confirmPhoneButton setTitle:NSLocalizedString(@"Verify phone number", @"") forState:UIControlStateNormal ];
    [self.confirmPhoneButton.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size: 18]];
	[self.confirmPhoneButton addTarget:self action:@selector(confirmPhone) forControlEvents:UIControlEventTouchUpInside];
	self.confirmPhoneButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	self.txtName.delegate = self;
	self.txtPin.delegate = self;
	self.txtPhoneNr.delegate = self;
    self.fullNameTextField.delegate = self;
    
	self.txtName.textColor = [UIColor colorNamed:@"color_text"];
	self.txtPin.textColor = [UIColor colorNamed:@"color_text"];
	self.txtPhoneNr.textColor = [UIColor colorNamed:@"color_text"];
	
	self.txtName.keyboardType = UIKeyboardTypeASCIICapable;
	self.txtName.returnKeyType = UIReturnKeyNext;

	self.txtName.textAlignment = NSTextAlignmentRight;
	
	self.txtPin.keyboardType = UIKeyboardTypeNumberPad;
	self.txtPin.returnKeyType = UIReturnKeyDone;
	self.txtPin.placeholder = NSLocalizedString(@"ex. 1234", @"");
	self.txtPin.textAlignment = NSTextAlignmentRight;
	
	self.txtPhoneNr.keyboardType = UIKeyboardTypePhonePad;
	self.txtPhoneNr.returnKeyType = UIReturnKeyDone;
	self.txtPhoneNr.placeholder = NSLocalizedString(@"ex. +47000000000", @"");
	self.txtPhoneNr.textAlignment = NSTextAlignmentRight;
    [self.txtPhoneNr addTarget:self action:@selector(phoneNumberChanged) forControlEvents:UIControlEventAllEditingEvents];
	
	[self reloadAllUserInfo:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reloadAllUserInfo:)  
												 name:kSyncFinishedNotification object:nil];
}

- (void) phoneNumberChanged {
    self.confirmPhoneButton.enabled = !([self.txtPhoneNr.text compare:[AlertySettingsMgr UserPhoneNr]] == NSOrderedSame);
}

- (void) closePressed {
    [self dismissControllerAnimated:YES];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.txtPhoneNr.text = [AlertySettingsMgr UserPhoneNr];
}

- (void) reloadAllUserInfo:(NSNotification*)notification {
	[[DataManager sharedDataManager] getUserSettings];
    
	NSString *userName = nil;
	if ([AlertySettingsMgr isBusinessVersion]) {
		BOOL isSubscriber = YES; //[AlertySettingsMgr businessType] == kBusinessTypeSubscription ? YES : NO;
		userName = isSubscriber ? [AlertySettingsMgr userNameServer] : [AlertySettingsMgr userFullName];
	}
	else {
		userName = [[DataManager sharedDataManager] userName];
	}
    
    self.fullNameTextField.text = [AlertySettingsMgr userFullName];
	self.txtName.text = [AlertySettingsMgr userName];
    if (AlertySettingsMgr.usePIN) {
        self.txtPin.text = AlertySettingsMgr.userPIN;
    } else {
        //self.txtPin.text = NSLocalizedString(@"USER_ACCOUNT_NO_PIN", @"");
    }
    self.txtPin.enabled = AlertySettingsMgr.usePIN;
    self.txtPin.secureTextEntry = AlertySettingsMgr.usePIN;
    //self.txtPin.textColor = AlertySettingsMgr.usePIN ? UIColor.whiteColor : COLOR_GRAY_CURSOR;
    self.txtPhoneNr.text = [AlertySettingsMgr UserPhoneNr];
    self.txtPhoneNr.userInteractionEnabled = !AlertySettingsMgr.isBusinessVersion;

	[self.userSettingsTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : (AlertySettingsMgr.isBusinessVersion ? 3 : 4);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!AlertySettingsMgr.usePIN && indexPath.row == 1) return 70.0f;
	if (indexPath.row == 3) return 50.0f;
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // full name
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PersonallInfoFullNameCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonallInfoFullNameCell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [self addSeparator:cell];

            UILabel *fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 140, 45)];
            fullNameLabel.text = NSLocalizedString(@"Full name", @"");
            fullNameLabel.textColor = [UIColor colorNamed:@"color_text"];
            fullNameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            
            [cell.contentView addSubview:fullNameLabel];
            [cell.contentView addSubview:self.fullNameTextField];
        }
        cell.backgroundColor = UIColor.clearColor;
        return cell;
    } else {
        switch( indexPath.row ) {
            case 0:
            {
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountSettingsNameCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingsNameCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [self addSeparator:cell];
                    
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 140, 21)];
                    nameLabel.textColor = [UIColor colorNamed:@"color_text"];
                    nameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
                    if ([AlertySettingsMgr isBusinessVersion]) {
                        nameLabel.text = NSLocalizedString(@"ID", @"");
                        self.txtName.placeholder = NSLocalizedString(@"ex. John", @"");
                    }
                    else {
                        nameLabel.text = NSLocalizedString(@"Email address", @"");
                        self.txtName.placeholder = NSLocalizedString(@"ex. john@email.com", @"");
                    }
                    [cell.contentView addSubview:nameLabel];
                    [cell.contentView addSubview:self.txtName];
                }
                cell.backgroundColor = UIColor.clearColor;
                return cell;
            }
            case 1:
            {
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountSettingsPinCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingsPinCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [self addSeparator:cell];

                    UILabel* pincodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 160, 21)];
                    pincodeLabel.text = NSLocalizedString(@"PIN-code", @"PIN-code");
                    pincodeLabel.textColor = [UIColor colorNamed:@"color_text"];
                    pincodeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
                    [cell.contentView addSubview:pincodeLabel];
                    if (!AlertySettingsMgr.usePIN) {
                        UILabel* noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, cell.height - 32, tableView.bounds.size.width - 50.0, 21)];
                        noteLabel.adjustsFontSizeToFitWidth = YES;
                        noteLabel.text = NSLocalizedString(@"USER_ACCOUNT_NO_PIN", @"");
                        noteLabel.textColor = COLOR_GRAY_CURSOR;
                        noteLabel.backgroundColor = [UIColor clearColor];
                        noteLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
                        noteLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
                        [cell.contentView addSubview:noteLabel];
                    } else {
                        [cell.contentView addSubview:self.txtPin];
                    }
                }
                cell.backgroundColor = UIColor.clearColor;
                return cell;
            }
            case 2:
            {
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountSettingsPhoneNrCell"];

                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingsPhoneNrCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [self addSeparator:cell];

                    UILabel *pincodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 130, 21)];
                    pincodeLabel.text = NSLocalizedString(@"Phone number:", @"");
                    pincodeLabel.textColor = [UIColor colorNamed:@"color_text"];
                    pincodeLabel.backgroundColor = [UIColor clearColor];
                    pincodeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];

                    [cell.contentView addSubview:pincodeLabel];
                    [cell.contentView addSubview:self.txtPhoneNr];
                }
                cell.backgroundColor = UIColor.clearColor;
                return cell;
            }
            case 3:
            {
                UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AccountSettingsConfirmPhoneCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountSettingsConfirmPhoneCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.contentView addSubview:self.confirmPhoneButton];
                }
                cell.backgroundColor = UIColor.clearColor;
                NSString* text = self.txtPhoneNr.text;
                self.confirmPhoneButton.enabled = !([text compare:[AlertySettingsMgr UserPhoneNr]] == NSOrderedSame);
                return cell;
            }
        }
    }
	return nil;
}

- (void) addSeparator:(UIView*)cell {
    /*UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0];
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:view];*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float padding = 35;
    switch( section ) {
        case 0: // personal info
            return self.personalInfo.frame.size.height + padding;
        case 1: // account info
            return self.accountInfo.frame.size.height + padding;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.bounds.size.width, 100);
    UIView *viewI = [[UIView alloc] init];

    viewI.frame = CGRectMake(10, 20, tableView.bounds.size.width-20, 50);
    viewI.backgroundColor = REDESIGN_COLOR_CANCEL;
    viewI.layer.cornerRadius = 8.0;

    //header.layer.cornerRadius = 8.0;
    switch( section ) {
        case 0: // personal info
        {
            //header.frame = CGRectMake(0, 0, tableView.bounds.size.width, self.personalInfo.frame.size.height);
            [viewI addSubview:self.personalInfo];
            break;
        }
        case 1: // account info
        {
            //header.frame = CGRectMake(40, 25, tableView.bounds.size.width-40, self.accountInfo.frame.size.height);
            [viewI addSubview:self.accountInfo];
            break;
        }
    }
    [header addSubview:viewI];

    return header;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mar - IBActions

- (void) saveUserAccountData {
    [self resignAllFirstResponders];
	
	self.txtName.text = [self.txtName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.txtPin.text = AlertySettingsMgr.usePIN ? [self.txtPin.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] : @"";
	
    if ([self.txtName.text length] > 0 && ([self.txtPin.text length] == 4 || !AlertySettingsMgr.usePIN)) {
		[AlertySettingsMgr setUserName:self.txtName.text];
        [AlertySettingsMgr setUserPIN:self.txtPin.text];
        [AlertySettingsMgr setUserFullName:self.fullNameTextField.text];
		[[DataManager sharedDataManager] getUserSettings];
        
        if ([AlertySettingsMgr userID] > 0) {
            [AlertySettingsMgr setUserFullName:self.fullNameTextField.text];
            [DataManager.sharedDataManager storeUserSettings:self.fullNameTextField.text pin:AlertySettingsMgr.userPIN];
            [self showAlert:NSLocalizedString(@"User account", @"") :NSLocalizedString(@"New user details are saved!", @"") :@"OK"];
        }
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"VALIDATE_ERROR",@"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - TextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.fullNameTextField) {
        return [textField.text length] + [string length] <= 23;
    }
	if (textField == self.txtPin) {
        _pinChanged = YES;
        if ([textField.text length] + [string length] == 4)
        {
            textField.text = [textField.text stringByAppendingString:string];
            [textField resignFirstResponder];
        }
	}
	else if (textField == self.txtName) {
        return [textField.text length] + [string length] <= 50;//23
	} else if (textField.tag == 999) {
		return [textField.text length] + [string length] <= 12;
	}
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
	
	if ([AlertySettingsMgr isBusinessVersion]) {
		if (textField == self.txtPin) {
			if (!_pinChanged) {
				textField.text = textField.placeholder;
			}
		}
		else if (textField == self.txtName) {
			[[DataManager sharedDataManager] registerNewBizUser:self.txtName.text pincode:self.txtPin.text];
		}
	} else {
		if (textField == self.txtPin) {
			if (!_pinChanged) {
				textField.text = textField.placeholder;
			}
		}
	}
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // add top edge/border to Number Pad
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1.0 / [UIScreen mainScreen].scale)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    textField.inputAccessoryView = separatorView;
    
	if ((textField == self.txtPin) && [textField.text length] == 4) {
        textField.placeholder = textField.text;
        textField.text = @"";
        _pinChanged = NO;
    }
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtName) {
		[textField resignFirstResponder];
		[self.txtPin becomeFirstResponder];
	}
    else if (textField == self.txtPin) {
        if (!_pinChanged) {
            textField.text = textField.placeholder;
        }
    } else {
        [textField resignFirstResponder];
    }
	return YES;
}

#pragma mark - UIButton actions

- (void) confirmPhone {
	[self.txtPhoneNr resignFirstResponder];
	[self.txtName resignFirstResponder];
	[self.txtPin resignFirstResponder];

	VerifyPhoneViewController* vc = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
	vc.phoneNr = self.txtPhoneNr.text;
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)keyboardHandlerBtnPressed:(id)sender {
	[self resignAllFirstResponders];
}

- (void) resignAllFirstResponders {
	[self.txtName resignFirstResponder];
    [self.txtPin resignFirstResponder];
   	[self.fullNameTextField resignFirstResponder];
}

@end
