//
//  addAlarmVC.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "addAlarmVC.h"
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


@interface addAlarmVC () <TimerSelectWlanViewControllerDelegate, TimerSelectLocationViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) NSTimer* timer;
//@property (strong, nonatomic) IBOutlet UILabel *counter;
//@property (strong, nonatomic) IBOutlet HoshiTextField *message;
//@property (weak, nonatomic) IBOutlet HoshiTextField *location;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *pickerExtraView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLeadingConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLeadingConstraint;
//@property (weak, nonatomic) IBOutlet UIButton *selectWlanButton;
//@property (weak, nonatomic) IBOutlet UIButton *selectLocationButton;


@end

@implementation addAlarmVC
@synthesize timer = _timer;

#pragma mark - Overrides


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    [self.datePicker setLocale:NSLocale.currentLocale];
//    [self.datePicker setTintColor:[UIColor whiteColor]];
    self.startButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.startButton.layer.cornerRadius = 4.0;
    self.cancelButton.backgroundColor = REDESIGN_COLOR_CANCEL;
    self.cancelButton.layer.cornerRadius = 4.0;
    
    //[self.message setValue:[UIColor colorWithRed:120.0/255.0 green:116.0/255.0 blue:115.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 400.0);
//    
//    self.message.placeholder = NSLocalizedString(@"e.g Floor 3, apartment 23", @"e.g Floor 3, apartment 23");
//    self.location.placeholder = NSLocalizedString(@"i.e street number", @"i.e street number");
    
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
    NSDate* date = [AlertySettingsMgr homeTimer];
    NSLog(@"Uptade status, date: %@", date);
//    if (date && [date timeIntervalSinceNow] < 0) 
    
//    [self.message setText:[AlertySettingsMgr homeTimerMessage]];

    if (!date) {
        [self.datePicker setEnabled:true] ;
        [self.startButton setHidden:NO];

        self.startButton.selected = NO;
        self.datePicker.hidden = NO;
        self.cancelButton.enabled = NO;
        self.cancelButton.alpha = 0.5;
//        self.counter.hidden = YES;
        [self.timer invalidate];
        self.timer = nil;
        self.messageLabel.text = NSLocalizedString(@"Describe what you will do and where you will be while the timer is running.", @"");
//        self.message.enabled = YES;
//        self.location.enabled = YES;
//        self.message.placeholderColor = COLOR_INACTIVE_BORDER;
//        self.message.borderActiveColor = COLOR_ACCENT;
//        self.message.borderInactiveColor = COLOR_INACTIVE_BORDER;
//        self.location.placeholderColor = COLOR_INACTIVE_BORDER;
//        self.location.borderActiveColor = COLOR_ACCENT;
//        self.location.borderInactiveColor = COLOR_INACTIVE_BORDER;
        
        self.pickerExtraView.hidden = NO;
    } else {
        [self.startButton setHidden:YES];
        [self.datePicker setEnabled:false] ;
        self.cancelButton.enabled = YES;
        [self.cancelButton setTitle:@"Cancel Alarm" forState:UIControlStateNormal];
//        self.counter.hidden = NO;
        
        self.messageLabel.text = NSLocalizedString(@"Ongoing activities:", @"");
//        self.message.enabled = NO;
//        self.message.placeholderColor = UIColor.clearColor;
//        self.message.borderActiveColor = UIColor.clearColor;
//        self.message.borderInactiveColor = UIColor.clearColor;
//        self.location.enabled = NO;
//        self.location.placeholderColor = UIColor.clearColor;
//        self.location.borderActiveColor = UIColor.clearColor;
//        self.location.borderInactiveColor = UIColor.clearColor;
        [self.datePicker setDate:date];
        
        self.pickerExtraView.hidden = YES;
        
//        self.counter.text = [NSString stringWithFormat:@"%@", date];
        
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];
        }
    }
}

-(void)onTick:(NSTimer *)timer {
    [self updateStatus];
}

- (IBAction)pickervalueChanged:(id)sender {

}

- (void) clearAlarm {
    [AlertySettingsMgr sethomeTimer:nil];
    [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateHomeTimer];
    
    // clear notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
    
    [self updateStatus];
    
    // clear on server
    [self removeAlarm];
}

- (void) removeAlarm {
    
    
    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
//    [center removeAllPendingNotificationRequests];

    
    NSMutableDictionary* parameters = @{ @"userid" : userId,
                                         @"alarm" : @"",
                                        @"alarmtime" : @"",
                                          @"comment" : @"",
                                         @"enable" : @"0",
    }.mutableCopy;


    [MobileInterface post:ADDALARM_URL body:parameters completion:^(NSDictionary *result, NSString *errorMessage) {
        
    }];
}
- (void) addTimer:(NSDate*)date {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:date];
    NSLog(@"newDateString %@", newDateString);
    
    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
    NSString* offset = @"-1";
    if (date) {
        NSTimeInterval diff = [date timeIntervalSinceNow];
        offset = [NSString stringWithFormat:@"%.0f", diff];
    }
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];

    
    NSMutableDictionary* parameters = @{ @"userid" : userId,
                                         @"alarm" : @"sdfsdfs",
                                        @"alarmtime" : newDateString,
                                          @"comment" : @"",
                                         @"enable" : @"1",

    }.mutableCopy;
//    if (AlertySettingsMgr.timerAddress.length) {
//        [parameters setObject:AlertySettingsMgr.timerAddress forKey:@"location"];
//    }
//    if (AlertySettingsMgr.timerLatitude && AlertySettingsMgr.timerLongitude) {
//        [parameters setObject:AlertySettingsMgr.timerLatitude forKey:@"latitude"];
//        [parameters setObject:AlertySettingsMgr.timerLongitude forKey:@"longitude"];
//    }
    [MobileInterface post:ADDALARM_URL body:parameters completion:^(NSDictionary *result, NSString *errorMessage) {
        
    }];
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

//    [self addTimer:self.datePicker.date];
    
    NSDate* date = [AlertySettingsMgr homeTimer];
    if (!date) {
        NSDate* date = [self.datePicker date];
        
//        date.seconds = 0;
        [AlertySettingsMgr sethomeTimer:date];
        [AlertySettingsMgr sethomeTimerMessage:@""];
        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateHomeTimer];

        // send to server
        [self addTimer:date];
        

        UNMutableNotificationContent* contentPre = [[UNMutableNotificationContent alloc] init];
        contentPre.body = NSLocalizedString(@"An alarm will be activated within 180 seconds.", @"");
        contentPre.sound = [UNNotificationSound criticalSoundNamed:@"beeping30.aif" withAudioVolume:1.0];
        NSDateComponents *dateComponentsPre = [NSCalendar.currentCalendar components:(kCFCalendarUnitSecond | kCFCalendarUnitMinute | kCFCalendarUnitHour) fromDate:[self.datePicker.date dateByAddingTimeInterval:-180.0]];
        UNCalendarNotificationTrigger* triggerPre = [UNCalendarNotificationTrigger
               triggerWithDateMatchingComponents:dateComponentsPre repeats:YES];
         
        // Create the request object.
        UNNotificationRequest* requestPre = [UNNotificationRequest requestWithIdentifier:@"HOME_PRE" content:contentPre trigger:triggerPre];
        
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
