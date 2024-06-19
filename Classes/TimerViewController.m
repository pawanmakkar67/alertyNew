//
//  TimerViewController.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimerViewController.h"
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
@import UserNotifications;


@interface TimerViewController () <TimerSelectWlanViewControllerDelegate, TimerSelectLocationViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) IBOutlet UILabel *counter;
@property (strong, nonatomic) IBOutlet HoshiTextField *message;
@property (weak, nonatomic) IBOutlet HoshiTextField *location;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *pickerExtraView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *selectWlanButton;
@property (weak, nonatomic) IBOutlet UIButton *selectLocationButton;


@end

@implementation TimerViewController
@synthesize timer = _timer;

#pragma mark - Overrides


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
    [self.pickerView setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
    self.startButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.startButton.layer.cornerRadius = 4.0;
    self.cancelButton.backgroundColor = REDESIGN_COLOR_CANCEL;
    self.cancelButton.layer.cornerRadius = 4.0;
    
    //[self.message setValue:[UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 400.0);
    
    self.message.placeholder = NSLocalizedString(@"e.g Floor 3, apartment 23", @"e.g Floor 3, apartment 23");
    self.location.placeholder = NSLocalizedString(@"i.e street number", @"i.e street number");
    
    [self registerForKeyboardNotifications];
}

- (void) closePressed {
    [self dismissControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self updateStatus];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void) updateStatus {
    NSDate* date = [AlertySettingsMgr timer];
    NSLog(@"Uptade status, date: %@", date);
    if (date && [date timeIntervalSinceNow] < 0) {
        date = nil;
        [AlertySettingsMgr setTimer:nil];
        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateTimer];
    }
    [self.message setText:[AlertySettingsMgr timerMessage]];
    [self.location setText:AlertySettingsMgr.timerAddress];
    if (!date) {
        self.startButton.selected = NO;
        self.pickerView.hidden = NO;
        self.cancelButton.enabled = NO;
        self.cancelButton.alpha = 0.5;
        self.counter.hidden = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.messageLabel.text = NSLocalizedString(@"Describe what you will do and where you will be while the timer is running.", @"");
        self.message.enabled = YES;
        self.location.enabled = YES;
        self.message.placeholderColor = COLOR_INACTIVE_BORDER;
        self.message.borderActiveColor = COLOR_ACCENT;
        self.message.borderInactiveColor = COLOR_INACTIVE_BORDER;
        self.location.placeholderColor = COLOR_INACTIVE_BORDER;
        self.location.borderActiveColor = COLOR_ACCENT;
        self.location.borderInactiveColor = COLOR_INACTIVE_BORDER;
        
        self.pickerExtraView.hidden = NO;
    } else {
        self.startButton.selected = YES;
        self.pickerView.hidden = YES;
        self.cancelButton.enabled = YES;
        self.counter.hidden = NO;
        
        self.messageLabel.text = NSLocalizedString(@"Ongoing activities:", @"");
        self.message.enabled = NO;
        self.message.placeholderColor = UIColor.clearColor;
        self.message.borderActiveColor = UIColor.clearColor;
        self.message.borderInactiveColor = UIColor.clearColor;
        self.location.enabled = NO;
        self.location.placeholderColor = UIColor.clearColor;
        self.location.borderActiveColor = UIColor.clearColor;
        self.location.borderInactiveColor = UIColor.clearColor;

        
        self.pickerExtraView.hidden = YES;
        
        
        
        NSTimeInterval diff = [date timeIntervalSinceNow];
        int seconds = (int)diff % 60;
        int minutes = diff / 60;
        int hours = minutes / 60;
        minutes = minutes % 60;
        self.counter.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
        
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];
        }
    }
}

-(void)onTick:(NSTimer *)timer {
    [self updateStatus];
}

- (void) clearAlarm {
    [AlertySettingsMgr setTimer:nil];
    [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateTimer];
    
    // clear notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
//    [center removeAllPendingNotificationRequests];
    
    [self updateStatus];
    
    // clear on server
    [self addTimer:nil];
}

- (void) addTimer:(NSDate*)date {
    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
    NSString* offset = @"-1";
    if (date) {
        NSTimeInterval diff = [date timeIntervalSinceNow];
        offset = [NSString stringWithFormat:@"%.0f", diff];
    }
    NSMutableDictionary* parameters = @{  @"user" : userId,
                                          @"userid" : userId,
                                          @"offset" : offset,
                                          @"message" : self.message.text
    }.mutableCopy;
    if (AlertySettingsMgr.timerAddress.length) {
        [parameters setObject:AlertySettingsMgr.timerAddress forKey:@"location"];
    }
    if (AlertySettingsMgr.timerLatitude && AlertySettingsMgr.timerLongitude) {
        [parameters setObject:AlertySettingsMgr.timerLatitude forKey:@"latitude"];
        [parameters setObject:AlertySettingsMgr.timerLongitude forKey:@"longitude"];
    }
    [MobileInterface post:ADDTIMER_URL body:parameters completion:^(NSDictionary *result, NSString *errorMessage) {
        
    }];
}

#pragma mark -
#pragma mark IBOutlets

- (IBAction)startPressed:(id)sender {
    long h = [self.pickerView selectedRowInComponent:0];
    long m = [self.pickerView selectedRowInComponent:1];

    NSDate* date = [AlertySettingsMgr timer];
    if (!date) {
        
        if ((h == 0) && (m == 0)) {
            [self showAlert:NSLocalizedString(@"Timer alarm", @"") :NSLocalizedString(@"Please set the time first!", @"") :@"OK"];
            return;
        }
        
        NSDate* date = [NSDate now];
        long minutes = [self.pickerView selectedRowInComponent:0] * 60 + [self.pickerView selectedRowInComponent:1];
        date = [date dateByAddingTimeInterval:60*minutes];
        [AlertySettingsMgr setTimer:date];
        [AlertySettingsMgr setTimerMessage:self.message.text];
        [AlertySettingsMgr setTimerAddress:self.location.text];
        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateTimer];

        // send to server
        [self addTimer:date];
        
        UNMutableNotificationContent* contentPre = [[UNMutableNotificationContent alloc] init];
        contentPre.body = NSLocalizedString(@"An alarm will be activated within 30 seconds.", @"");
        contentPre.sound = [UNNotificationSound criticalSoundNamed:@"beeping30.aif" withAudioVolume:1.0];
        NSDateComponents *dateComponentsPre = [NSCalendar.currentCalendar components:(kCFCalendarUnitSecond | kCFCalendarUnitMinute | kCFCalendarUnitHour) fromDate:[date dateByAddingTimeInterval:-30.0]];
        UNCalendarNotificationTrigger* triggerPre = [UNCalendarNotificationTrigger
               triggerWithDateMatchingComponents:dateComponentsPre repeats:NO];
         
        // Create the request object.
        UNNotificationRequest* requestPre = [UNNotificationRequest requestWithIdentifier:@"TIMER_PRE" content:contentPre trigger:triggerPre];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:requestPre withCompletionHandler:^(NSError * _Nullable error) {
           if (error != nil) {
               NSLog(@"%@", error.localizedDescription);
           }
        }];
        
        /*UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body = NSLocalizedString(@"An alarm has been activated", @"");
        
        NSDateComponents *dateComponents = [NSCalendar.currentCalendar components:(kCFCalendarUnitSecond | kCFCalendarUnitMinute | kCFCalendarUnitHour) fromDate:date];
        UNCalendarNotificationTrigger* trigger = [UNCalendarNotificationTrigger
               triggerWithDateMatchingComponents:dateComponents repeats:NO];
         
        // Create the request object.
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"TIMER" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
           if (error != nil) {
               NSLog(@"%@", error.localizedDescription);
           }
        }];*/

        [self updateStatus];

        [self closePressed];
    
    } else {
        [self clearAlarm];
        
        // start alarm
        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_TIMER] lock:nil];
    }
}

- (IBAction)cancelPressed:(id)sender {
    [self clearAlarm];
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
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.location.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.location.frame animated:YES];
    }
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
    [AlertySettingsMgr setTimerMessage:wifiap.name];
    [AlertySettingsMgr setTimerAddress:wifiap.info];
    AlertySettingsMgr.timerLatitude = wifiap.locationLat;
    AlertySettingsMgr.timerLongitude = wifiap.locationLon;
}

#pragma mark - TimerSelectLocationViewControllerDelegate

- (void) locationSelected:(NSString*)location latitude:(double)latitude longitude:(double)longitude {
    [AlertySettingsMgr setTimerAddress:location];
    AlertySettingsMgr.timerLatitude = [NSNumber numberWithDouble:latitude];
    AlertySettingsMgr.timerLongitude = [NSNumber numberWithDouble:longitude];
}


@end
