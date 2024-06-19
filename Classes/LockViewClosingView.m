//
//  LockViewClosingView.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/4/13.
//
//

#import "LockViewClosingView.h"
#import "NSBundleAdditions.h"
#import "AlertySettingsMgr.h"

@interface LockViewClosingView()
@end

@implementation LockViewClosingView

@synthesize delegate = _delegate;

@synthesize pincodeTitleLabel = _pincodeTitleLabel;
@synthesize cancellerView = _cancellerView;
@synthesize dummyField = _dummyField;
@synthesize firstDigit = _firstDigit;
@synthesize secondDigit = _secondDigit;
@synthesize thirdDigit = _thirdDigit;
@synthesize fourthDigit = _fourthDigit;

#pragma mark - Overrides


#pragma mark - Internal methods

#pragma mark - Public methods

+ (LockViewClosingView*) lockViewClosingView {
    
	LockViewClosingView *ret = [NSBundle loadFirstFromNib:@"LockViewClosingView"];
	[ret setPinCodeFrame];
    
    ret.firstDigit.layer.borderColor = UIColor.lightGrayColor.CGColor;
    ret.firstDigit.layer.borderWidth = 2.0;
    ret.firstDigit.layer.cornerRadius = 4.0;
    ret.secondDigit.layer.borderColor = UIColor.lightGrayColor.CGColor;
    ret.secondDigit.layer.borderWidth = 2.0;
    ret.secondDigit.layer.cornerRadius = 4.0;
    ret.thirdDigit.layer.borderColor = UIColor.lightGrayColor.CGColor;
    ret.thirdDigit.layer.borderWidth = 2.0;
    ret.thirdDigit.layer.cornerRadius = 4.0;
    ret.fourthDigit.layer.borderColor = UIColor.lightGrayColor.CGColor;
    ret.fourthDigit.layer.borderWidth = 2.0;
    ret.fourthDigit.layer.cornerRadius = 4.0;
    
	return ret;
}

+ (NSString *) strip:(NSString *)receiver
{
	return [receiver stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void) resetState
{
	[self.dummyField becomeFirstResponder];
	
	self.dummyField.text = @"";
	self.firstDigit.text = @"";
	self.secondDigit.text = @"";
	self.thirdDigit.text = @"";
	self.fourthDigit.text = @"";
}

- (void) setPinCodeFrame
{
	CGRect frame = self.firstDigit.frame;
	frame.size.height = frame.size.width;
	self.firstDigit.frame = frame;
	
	frame = self.secondDigit.frame;
	frame.size.height = frame.size.width;
	self.secondDigit.frame = frame;
	
	frame = self.thirdDigit.frame;
	frame.size.height = frame.size.width;
	self.thirdDigit.frame = frame;
	
	frame = self.fourthDigit.frame;
	frame.size.height = frame.size.width;
	self.fourthDigit.frame = frame;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL) canUnlockWithPin:(NSString*)pinCode
{
	NSString *input = [[[self.firstDigit.text stringByAppendingString:self.secondDigit.text] stringByAppendingString:self.thirdDigit.text] stringByAppendingString:self.fourthDigit.text];
	return ([input isEqualToString:pinCode]);
}

#pragma mark - GestureRecognizer handlers

- (IBAction)backBtn:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.dummyField resignFirstResponder];
    [self.delegate didCancelLockView];
}
- (IBAction) cancelStoping:(UIGestureRecognizer *)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self.dummyField resignFirstResponder];
	[self.delegate didCancelLockView];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	self.wrongPinView.hidden = YES;
	if ([string length] == 0) { // törlés
        switch (range.location) {
            case 3:
                self.fourthDigit.text = @"";
                break;
            case 2:
                self.thirdDigit.text = @"";
                break;
            case 1:
                self.secondDigit.text = @"";
                break;
            case 0:
                self.firstDigit.text = @"";
                break;
            default:
                break;
        }
    }
    else
    {
        if ([textField.text length] == 0) {
            self.firstDigit.text = string;
        } else
        if ([textField.text length] == 1) {
            self.secondDigit.text = string;
        } else
        if ([textField.text length] == 2) {
            self.thirdDigit.text = string;
        } else
        if ([textField.text length] == 3) {
            self.fourthDigit.text = string;
            [self performSelector:@selector(checkPinCode) withObject:nil afterDelay:0.1];
        } else {
			return FALSE;
		}
    }
	return YES;
}

- (void) checkPinCode {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.dummyField.text length] == 4) {
            NSString *pinCode = [LockViewClosingView strip:[[AlertySettingsMgr userPIN] lowercaseString]];
            if ([self.dummyField.text isEqualToString:pinCode]) {
                [self confirmStoping];
            }
            else {
                self.dummyField.text = @"";
                self.firstDigit.text = self.secondDigit.text = self.thirdDigit.text = self.fourthDigit.text = self.dummyField.text;
                self.wrongPinView.hidden = NO;
            }
        }
    });
}

- (void) confirmStoping {
	if ([self canUnlockWithPin:[[AlertySettingsMgr userPIN] lowercaseString]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
		if( [self.delegate respondsToSelector:@selector(didUnlockLocker)]) {
			[self.delegate didUnlockLocker];
		}
	}
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
	[self.dummyField becomeFirstResponder];
}

@end
