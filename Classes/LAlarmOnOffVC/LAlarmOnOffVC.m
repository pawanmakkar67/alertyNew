//
//  addAlarmVC.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LAlarmOnOffVC.h"
#import "config.h"
#import "AlertySettingsMgr.h"
#import "NSExtensions.h"
#import "AlertMapViewController.h"
#import "AlertyAppDelegate.h"
#import "HoshiTextField.h"
#import "TimerSelectWlanViewController.h"
#import "TimerSelectLocationViewController.h"
#import "WifiAP.h"
#import "MobileInterface.h"

@import Switches;
@import UserNotifications;


@interface LAlarmOnOffVC () <TimerSelectWlanViewControllerDelegate, TimerSelectLocationViewControllerDelegate,LockViewClosingViewDelegate, LockViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *circleVW;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *toggleBtn;
@property (strong, nonatomic) LockViewClosingView* lockViewClosingView;
@property (strong, nonatomic) UIBarButtonItem* prevBtn;


@end

@implementation LAlarmOnOffVC

#pragma mark - Overrides


- (void)viewDidLoad {
    [super viewDidLoad];
//    [_togg]
//    if (AlertySettingsMgr.lAlarmEnabled) {
        [_toggleBtn setImage: [UIImage imageNamed:@"btnActive"] forState:UIControlStateNormal];
//    }
//    else {
//        [_toggleBtn setImage: [UIImage imageNamed:@"btnInactive"] forState:UIControlStateNormal];
//    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2;
    [_circleVW.layer setCornerRadius:(width-50)];

    [_circleVW.layer setBorderWidth:11];
    [_circleVW.layer setBorderColor:[[UIColor alloc] initWithWhite:1 alpha:1].CGColor];
    

    
    
    _prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = _prevBtn;
    
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 400.0);
//    
//    self.message.placeholder = NSLocalizedString(@"e.g Floor 3, apartment 23", @"e.g Floor 3, apartment 23");
//    self.location.placeholder = NSLocalizedString(@"i.e street number", @"i.e street number");
    
//    [self registerForKeyboardNotifications];
    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerRight:)];
        [gestureRecognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.view addGestureRecognizer:gestureRecognizerRight];
 
}


-(void)swipeHandlerRight:(id)sender
{
    [self closePressed];
}


- (void) closePressed {
    if (AlertySettingsMgr.usePIN) {
        [_prevBtn setHidden:YES];
        self.lockViewClosingView = [LockViewClosingView lockViewClosingView];
        self.lockViewClosingView.delegate = self;
        self.lockViewClosingView.frame = self.view.frame;
        NSString* message =  NSLocalizedString(@"Please enter PIN-code to cancel Timer alarm!", @"");
        [self.lockViewClosingView.pincodeTitleLabel setText:message];
        
        [self.lockViewClosingView resetState];
        [self.view addSubview:self.lockViewClosingView];
    } else {
        [self didUnlockLocker];
    }

//    [self dismissControllerAnimated:YES];
}
- (void) didCancelLockView {
    [self.lockViewClosingView endEditing:YES];
    [self.lockViewClosingView removeFromSuperview];
    [_prevBtn setHidden:NO];

}

- (void) didUnlockLocker {
    [self.lockViewClosingView endEditing:YES];
    [self.lockViewClosingView removeFromSuperview];
    self.lockViewClosingView = nil;
    if (_toggleBtn.imageView.image == [UIImage imageNamed:@"btnInactive"] ) {
        [AlertySettingsMgr setLAlarmEnabled:NO];
    }
    else {
        [AlertySettingsMgr setLAlarmEnabled:YES];
    }
    [self.view endEditing:YES];
    [self dismissControllerAnimated:YES];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self updateStatus];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void) updateStatus {
    NSDate* date = [AlertySettingsMgr homeTimer];
    NSLog(@"Uptade status, date: %@", date);

}

-(void)onTick:(NSTimer *)timer {
    [self updateStatus];
}

- (IBAction)pickervalueChanged:(id)sender {

}

- (void) clearAlarm {
    
}

- (void) removeAlarm {
}
- (void) addTimer:(NSDate*)date {
    
}

- (UILocalNotification *)notificationForTime:(NSInteger)time withMessage:(NSString *)message soundName:(NSString *)soundName {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    localNotification.repeatInterval = NSDayCalendarUnit;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.soundName = soundName;

    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];

    [dateComponents setHour:time];

    NSDate *next = [calendar dateFromComponents:dateComponents];
    if ([next timeIntervalSinceNow] < 0) {
        next = [next dateByAddingTimeInterval:60*60*24];
    }
    localNotification.fireDate = next;

    return  localNotification;
}

#pragma mark -
#pragma mark IBOutlets

- (IBAction)startPressed:(id)sender {

}

- (IBAction)cancelPressed:(id)sender {
    
    [self clearAlarm];
}
- (IBAction)valueChange:(UIButton *)sender {
    if (sender.imageView.image == [UIImage imageNamed:@"btnActive"] ) {
        [sender setImage:[UIImage imageNamed:@"btnInactive"] forState:UIControlStateNormal];
    }
    else {
        [sender setImage:[UIImage imageNamed:@"btnActive"] forState:UIControlStateNormal];
    }
}

#pragma mark - Keyboard handling

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.

    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return 24;
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}


/*- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = [NSString stringWithFormat:@"%02lu", (long)row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.26 alpha:1.0],
          NSFontAttributeName:[UIFont systemFontOfSize:40.0]}];
    return attString;
}*/


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"Lato-Regular" size:30];
        tView.textColor = [UIColor whiteColor];
        tView.textAlignment = NSTextAlignmentCenter;
        //tView.backgroundColor = [UIColor colorWithWhite:0.26 alpha:1.0];
    }
    // Fill the label text here
    tView.text = [NSString stringWithFormat:@"%02lu", (long)row];
    return tView;
}

#pragma mark - IBActions

- (IBAction)selectWlanPressed:(id)sender {
    TimerSelectWlanViewController* vc = [[TimerSelectWlanViewController alloc] initWithNibName:@"TimerSelectWlanViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectLocationPressed:(id)sender {
    TimerSelectLocationViewController* vc = [[TimerSelectLocationViewController alloc] initWithNibName:@"TimerSelectLocationViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TimerSelectViewControllerDelegate

- (void) wlanSelected:(WifiAP*)wifiap {
    [AlertySettingsMgr sethomeTimerMessage:wifiap.name];
}

#pragma mark - TimerSelectLocationViewControllerDelegate

- (void) locationSelected:(NSString*)location latitude:(double)latitude longitude:(double)longitude {
    
}


@end
