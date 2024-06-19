//
//  ManDownView.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 11/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManDownView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSBundleAdditions.h"
#import "NSHelpers.h"
#import "AudioPlayback2.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"
#import "TimerViewController.h"
#import "config.h"
#import "NSExtensions.h"
#import "AlertMapViewController.h"
#import "MobileInterface.h"
@import UserNotifications;

@interface ManDownView() {
    int secondsLeft;
}
@property (strong, nonatomic) IBOutlet UILabel *titleView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn1;
@property (weak, nonatomic) IBOutlet UIButton *addBtn2;
@property (weak, nonatomic) IBOutlet UIButton *addBtn3;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (weak, nonatomic) IBOutlet UIView *separator1;
@property (weak, nonatomic) IBOutlet UIView *separator2;
@property (weak, nonatomic) IBOutlet UIView *separator3;
@property (weak, nonatomic) IBOutlet UIView *separator4;


@property (weak, nonatomic) IBOutlet UIView *sixyVW;
@property (weak, nonatomic) IBOutlet UIView *fifteenVW;
@property (weak, nonatomic) IBOutlet UIView *fiveVW;



@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@property (nonatomic, assign) int minutes;
- (void) invalidateTimers;
@end

@implementation ManDownView

#pragma mark - Overrides

- (void)dealloc {
    [self stopCountDown];
}

#pragma mark - Private methods

- (void) invalidateTimers {
    if ([self.timer isValid]) [self.timer invalidate];
}

- (void) stopToneGenerator {
    [AudioPlayback2 stop];
}

#pragma mark - Public methods

+ (ManDownView*) manDownView:(BOOL)isTimer {
    ManDownView* view = (ManDownView*)[NSBundle loadFirstFromNib:@"ManDownView"];
    view.descriptionLabel.text = NSLocalizedString(@"Alarm automatically activates in", @"");
    view.secondsLabel.text = NSLocalizedString(@"seconds.", @"");
    [view.cancelBtn setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    if (isTimer) view.titleView.text = NSLocalizedString(@"Timer alarm", @"");
    else {
        view.cancelBtn.frame = view.addBtn1.frame;
        [view.addBtn1 removeFromSuperview];
        [view.addBtn2 removeFromSuperview];
        [view.addBtn3 removeFromSuperview];
        [view.separator1 removeFromSuperview];
        [view.separator2 removeFromSuperview];
        [view.separator4 removeFromSuperview];
        CGRect frame = view.alertView.bounds;
        frame.size.height = 156;
        view.alertView.bounds = frame;
    }
    
    view.isTimer = isTimer;
    return view;
}
+ (ManDownView*) manDownViewHome:(BOOL)isAlarm {
    ManDownView* view = (ManDownView*)[NSBundle loadFirstFromNib:@"ManDownView"];
    view.descriptionLabel.text = NSLocalizedString(@"Alarm automatically activates in", @"");
    view.secondsLabel.text = NSLocalizedString(@"seconds.", @"");
    [view.cancelBtn setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    if (isAlarm) view.titleView.text = NSLocalizedString(@"Home Alarm", @"");
    else {
        view.cancelBtn.frame = view.addBtn1.frame;
        [view.addBtn1 removeFromSuperview];
        [view.addBtn2 removeFromSuperview];
        [view.addBtn3 removeFromSuperview];
        [view.separator1 removeFromSuperview];
        [view.separator2 removeFromSuperview];
        [view.separator4 removeFromSuperview];
        CGRect frame = view.alertView.bounds;
        frame.size.height = 156;
        view.alertView.bounds = frame;
    }
    
    
    [view.sixyVW setHidden: YES];
    [view.fifteenVW setHidden: YES];
    [view.fiveVW setHidden: YES];

    view.isAlarm = isAlarm;
    return view;
}

- (void) showInView:(UIView *)view {
    if ([self.timer isValid]) [self.timer invalidate];
    if (![self superview]) {
        [view addSubview:self];
        self.frame = view.frame;
    }
    // vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
//    secondsLeft = self.isTimer ? [AlertySettingsMgr.timer timeIntervalSinceNow] : 30;
    secondsLeft = self.isTimer ? 30 : 180;

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    if(![AlertySettingsMgr discreteModeEnabled]){
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"beeping" ofType: @"aif"];
        [AudioPlayback2 start:soundFilePath loop:YES];
    }
}

- (void) stopCountDown {
    [self invalidateTimers];
    [self stopToneGenerator];
}

#pragma mark - IBActions


- (IBAction)addTime1Pressed:(id)sender {
    [self setTimeInTimer:[NSNumber numberWithLongLong:5]];
    [self.delegate closeManDown];
}

- (IBAction)addTime2Pressed:(id)sender {
    [self setTimeInTimer:[NSNumber numberWithLongLong:15]];
    [self.delegate closeManDown];
}

- (IBAction)addTime3Pressed:(id)sender {
    [self setTimeInTimer:[NSNumber numberWithLongLong:60]];
    [self.delegate closeManDown];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self clearAlarm];
}

- (void)setTimeInTimer:(NSNumber *)newMinutes {
    NSDate* date = [NSDate now];
    long minutes = [newMinutes longLongValue];
    date = [date dateByAddingTimeInterval:60*minutes];
    
    [AlertySettingsMgr setTimer:date];
    
    [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateTimer];
    
    // send to server
    [self addTimer:date];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeDeliveredNotificationsWithIdentifiers:@[@"TIMER_PRE"]];
    
    UNMutableNotificationContent* contentPre = [[UNMutableNotificationContent alloc] init];
    contentPre.body = NSLocalizedString(@"An alarm will be activated within 30 seconds.", @"");
    contentPre.sound = [UNNotificationSound criticalSoundNamed:@"beeping30.aif" withAudioVolume:1.0];
    
    NSDateComponents *dateComponentsPre = [NSCalendar.currentCalendar components:(kCFCalendarUnitSecond | kCFCalendarUnitMinute | kCFCalendarUnitHour) fromDate:[date dateByAddingTimeInterval:-30.0]];
    UNCalendarNotificationTrigger* triggerPre = [UNCalendarNotificationTrigger
           triggerWithDateMatchingComponents:dateComponentsPre repeats:NO];
     
    // Create the request object.
    UNNotificationRequest* requestPre = [UNNotificationRequest requestWithIdentifier:@"TIMER_PRE" content:contentPre trigger:triggerPre];
    [center addNotificationRequest:requestPre withCompletionHandler:^(NSError * _Nullable error) {
       if (error != nil) {
           NSLog(@"%@", error.localizedDescription);
       }
    }];
}

- (void) clearAlarm {
    // clear notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
//    [center removeAllPendingNotificationRequests];

    if (_isAlarm) {
        if ([self.delegate respondsToSelector:@selector(didCancelTimer:)]) {
            [self.delegate didCancelAlarm:[NSNumber numberWithBool:self.isAlarm]];// 0 or 1
        }

//        [AlertySettingsMgr sethomeTimer:nil];
        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateHomeTimer];

        
    }
    else {
        if( self.stopTimerOnCancel ) {
            [self stopCountDown];
        }
        if ([self.delegate respondsToSelector:@selector(didCancelTimer:)]) {
            [self.delegate didCancelTimer:[NSNumber numberWithBool:self.isTimer]];// 0 or 1
        }
        
        [AlertySettingsMgr setTimer:nil];
        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController updateTimer];
        
        
        // clear on server
        [self addTimer:nil];
    }
}

#pragma mark - NSTimer handlers

- (void) timerFired:(NSTimer*)timer {
    secondsLeft--;
    if (secondsLeft > 0) {
        self.countLabel.text = [NSString stringWithFormat:@"%d", secondsLeft];
        if (secondsLeft < 10) {
            self.countLabel.textColor = [UIColor colorWithRed:(255/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0];
        }
        else if (secondsLeft < 20) {
            self.countLabel.textColor = [UIColor colorWithRed:(232/255.f) green:(126/255.f) blue:(4/255.f) alpha:1.0];
        }
        else {
            
        }
        
        if (![AudioPlayback2 isPlaying] && ![AlertySettingsMgr discreteModeEnabled]) {
            NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"beeping30" ofType: @"aif"];
            [AudioPlayback2 start:soundFilePath loop:NO];
        }
    }
    else {
        [self stopCountDown];
        
        if ([self.delegate respondsToSelector:@selector(didFinishTimer)]) {
            [self.delegate didFinishTimer];
        }
    }
}

- (void) addTimer:(NSDate*)date {
    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
    NSString* offset = @"-1";
    if (date) {
        NSTimeInterval diff = [date timeIntervalSinceNow];
        offset = [NSString stringWithFormat:@"%.0f", diff];
    }
    NSMutableDictionary *parameters = @{  @"user" : userId,
                                          @"userid" : userId,
                                          @"offset" : offset
    }.mutableCopy;
    if (AlertySettingsMgr.timerMessage.length) {
        [parameters setObject:AlertySettingsMgr.timerMessage forKey:@"message"];
    }
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



@end
