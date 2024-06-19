//
//  addAlarmVC.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LAlarmTimerVC.h"
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


@interface LAlarmTimerVC () <LockViewClosingViewDelegate, LockViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *circleVW;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *cancelAlarmBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondsShow;
@property (strong, nonatomic) LockViewClosingView* lockViewClosingView;


@end

@implementation LAlarmTimerVC
NSTimer *timer;
BOOL *cancelAlarm;

#pragma mark - Overrides


- (void)viewDidLoad {
    [super viewDidLoad];
    _cancelAlarmBtn.layer.cornerRadius = 33;
    [_secondsShow setText:[NSString stringWithFormat:@"%02d",currSeconds]];

    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    [self start];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/2;
    [_circleVW.layer setCornerRadius:(width-50)];

    [_circleVW.layer setBorderWidth:11];
    [_circleVW.layer setBorderColor:[[UIColor alloc] initWithWhite:1 alpha:1].CGColor];

}

-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];

}


-(void)timerFired
{
if(currSeconds>=0)
{
    if(currSeconds>0)
    {
        currSeconds-=1;
    }
    else {
        [timer invalidate];
        NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
        if (![userId  isEqual: @""] && cancelAlarm == NO) {
            [self.lockViewClosingView.dummyField resignFirstResponder];
            [self.lockViewClosingView removeFromSuperview];
            self.lockViewClosingView = nil;
            [self dismissControllerAnimated:YES];
            [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_BUTTON] lock:nil];
            UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
            [window resignFirstResponder];
        }
    }
    if(currSeconds>-1)
        [_secondsShow setText:[NSString stringWithFormat:@"%02d",currSeconds]];
}
    else
    {
        [timer invalidate];
    }
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    cancelAlarm = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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




- (IBAction)valueChange:(UIButton *)sender {
//    [timer invalidate];
    if (AlertySettingsMgr.usePIN) {
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

}

#pragma mark - UnlockViewDelegate
- (void) didCancelLockView {
    [self.lockViewClosingView removeFromSuperview];
    self.lockViewClosingView = nil;
    
    
}

- (void) didUnlockLocker {
    
    [self.lockViewClosingView removeFromSuperview];
    self.lockViewClosingView = nil;
    AlertySettingsMgr.lAlarmEnabled = YES;
    cancelAlarm = YES;
    [timer invalidate];
    [self dismissControllerAnimated:YES];

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


@end
