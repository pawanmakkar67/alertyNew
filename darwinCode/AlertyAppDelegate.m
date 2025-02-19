

//
//  AlertyAppDelegate.m
//  Alerty
//
//  Created by moni on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Alerty-Swift.h>

#import "AlertyAppDelegate.h"
#import "DataManager.h"
#import "UIDeviceAdditions.h"
#import "config.h"
#import "NSExtensions.h"
#import "AlertySettingsMgr.h"
#import "AlertyDBMgr.h"
#import "AlertyViewController.h"
#import "WifiApMgr.h"
#import "VideoViewController.h"
#import "AlertMapViewController.h"
#import "ReachabilityManager.h"
#import "MeasuredBeacon.h"

#import "SettingsViewController.h"
#import "IndoorLocationingViewController.h"
#import "MobileInterface.h"
#import "TRZDarwinNotificationCenter.h"
#import "LAlarmTimerVC.h"
#import "LAlarmOnOffVC.h"

@import Firebase;
@import Proximiio;
@import UserNotifications;


NSString* const ALERTINFOCALL_URL = HOME_URL @"/ws/alertinfo.php";
NSString * const DarwinNotificationName = @"com.apple.springboard.lockcomplete";
//ContextManager* contextM;

@interface AlertyAppDelegate() <MFMailComposeViewControllerDelegate, ProximiioDelegate, UNUserNotificationCenterDelegate, FLICManagerDelegate> {
	NSURLConnection	*_tokenRequest;
	GeoAddress *_getGeoCode;
	BOOL incomingCall;
    BOOL alarmRejected;
    
	UIBackgroundTaskIdentifier reconnectTask;
    TRZDarwinNotificationCenter *notificationHandle;
}

@property (nonatomic, strong) ManDownMgr *manDownMgr;
@property (nonatomic, strong) Reachability30* reachability;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSDictionary* callDetails;
@property (nonatomic, strong) NSTimer* flicTimer;

@property (nonatomic, strong) UIAlertController* flicAlert;
@property (nonatomic, strong) UILocalNotification* flicNotification;

@property (nonatomic, strong) DDFileLogger *fileLogger;
@property (nonatomic, assign) UIBackgroundTaskIdentifier flicInitTask;
@property (nonatomic, assign) UIBackgroundTaskIdentifier flic2InitTask;
@property (nonatomic, assign) UIBackgroundTaskIdentifier manDownTask;

@property (nonatomic, assign) NSInteger sosCounter;
@property (nonatomic, assign) BOOL locationFromBeacon;

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) NSDate* lastPosition;

@property (nonatomic, strong) CLLocationManager* locationManager;

@property (nonatomic, strong) AlertManager* alertManager;

@end


@implementation AlertyAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// "business" or "personal" version
	//[AlertySettingsMgr setBusinessVersion:YES];
    _contextM = [ContextManager new];
    [FIRApp configure];

    //[DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDOSLogger sharedInstance]]; // ASL = Apple System Logs
#ifdef SHOW_SEND_EMAIL
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:self.fileLogger];
#endif
    
    DDLogInfo(@"AlertyApplication didFinishLaunchingWithOptions");
    DDLogInfo(@"User ID: %ld", (long)[AlertySettingsMgr userID]);
    DDLogInfo(@"User name: %@", [AlertySettingsMgr userName]);
    DDLogInfo(@"User PIN: %@", [AlertySettingsMgr userPIN]);
    
	self.daysLeft = -999999;
	self.showUserSettings = NO;
    
    // Create the beacon region to be monitored.
    //NSString* bt = @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
    //NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:bt];
    //self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"beacon"];
    //self.beacons = [NSMutableArray array];

	// set our audio session to ambient
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    application.applicationIconBadgeNumber = 0;
    
    self.alertManager = [[AlertManager alloc] init];
    self.alertManager.delegate = self.mainController.alertyViewController;
	
	/*self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 5; //  100;
	self.locationManagerTracking = [[CLLocationManager alloc] init];
	self.locationManagerTracking.delegate = self;
	self.locationManagerTracking.desiredAccuracy = kCLLocationAccuracyBest;  //kCLLocationAccuracyHundredMeters;
	self.locationManagerTracking.distanceFilter = 20;

    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 9) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManagerTracking.allowsBackgroundLocationUpdates = YES;
    }*/
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)@"com.apple.springboard.lockcomplete";
    CFNotificationCenterAddObserver(center, (__bridge const void *)(self), notificationCallback, str, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

    self->notificationHandle = [[TRZDarwinNotificationCenter defaultCenter] addObserverForName:@"com.apple.springboard.lockcomplete" queue:nil usingBlock:^(NSNotification* notification) {
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            
            NSDate *thisMagicMoment = [NSDate date];
            NSDate *lastMagicMoment =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastMagicMoment"];

            if (lastMagicMoment==nil)
            {
                NSLog (@"First launch!");
            }
            else
            {
                NSTimeInterval timeOfNoMagic = [thisMagicMoment timeIntervalSinceDate:lastMagicMoment];
                NSLog (@"Application was in background for %.1f seconds", timeOfNoMagic);
                if ([AlertySettingsMgr userID] != 0) {
                    
                    //do your stuff - treat NSTimeInterval as double
                    if (AlertySettingsMgr.lAlarmEnabled) {
                        if (timeOfNoMagic < 4.0)
                        {
                            UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
                            localNotification.title = [NSString localizedUserNotificationStringForKey:@"Alerty - LARM!!" arguments:nil];
                            localNotification.body = [NSString localizedUserNotificationStringForKey:@"PÅGÅENDE LARM - Aktiveras om 20 sekunder!." arguments:nil];
                            localNotification.sound = [UNNotificationSound defaultSound];
                            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
                            
                            localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
                            
                            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"App Active" content:localNotification trigger:trigger];
                            
                            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                                NSLog(@"Notification created");
                            }];
                            
                            self->alarmRejected = YES;
                            double delayInSeconds = 20; // set the time
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                if (self->alarmRejected == YES) {
                                    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
                                    if (![userId  isEqual: @""]) {
                                        self->alarmRejected = NO;
                                        [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_BUTTON] lock:nil];
                                    }
                                }
                            });
                        }
                    }
                }
            }
            
    }
        //do something here
    }];
    
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
	// start man down manager
	[self startManDown];
		
	[self.window makeKeyAndVisible];
	
	if ([launchOptions objectForKey:UIApplicationLaunchOptionsAnnotationKey]) {
		[self showRemoteNotification:[launchOptions objectForKey:UIApplicationLaunchOptionsAnnotationKey]];
	}
	
	UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    device.proximityMonitoringEnabled = YES;
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:@"UIDeviceBatteryLevelDidChangeNotification" object:device];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryChanged:) name:@"UIDeviceBatteryStateDidChangeNotification" object:device];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
	self.reachability = [Reachability30 reachabilityForInternetConnection];
	[self.reachability startNotifier];

	incomingCall = NO;
        
	// do we need this?
//    [UNUserNotificationCenter.currentNotificationCenter removeAllPendingNotificationRequests];
    
	//[self restartConnectionTimer];
	
	reconnectTask = UIBackgroundTaskInvalid;
	
	//TEST
	//[self performSelector:@selector(didDetectManDown) withObject:nil afterDelay:5.0];
	
    self.interval = 60.0;
    
    [Proximiio.sharedInstance requestPermissions:YES];
    
    if ([AlertySettingsMgr userID] != 0) {
        [self registerNotifications];
        [DataManager.sharedDataManager getMaps];
	[self registerServices];
    }
	return YES;
}


- (BOOL)didUserPressLockButton {
    CGFloat oldBrightness = [UIScreen mainScreen].brightness;
    [UIScreen mainScreen].brightness = oldBrightness + (oldBrightness <= 0.01 ? 0.01 : -0.01);
    return oldBrightness != [UIScreen mainScreen].brightness;
}


//- (void)startListening:(DarwinNotificationBlock)block
//{
//    self.listenBlock = block;
//}

void notificationCallback(CFNotificationCenterRef center, void * observer, CFStringRef name, void const * object, CFDictionaryRef userInfo)
{
    NSString *identifier = (__bridge NSString *)name;
    [[NSNotificationCenter defaultCenter] postNotificationName:DarwinNotificationName object:nil userInfo:@{@"identifier" : identifier}];
}


- (void)didReceiveMessageNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *identifier = [userInfo valueForKey:@"identifier"];

//    if (self.listenBlock != nil) {
//        self.listenBlock(identifier);
//    }
}


- (void) initProximi {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [ProximiioAPI.sharedManager setApiVersion:@"v5"];
        [ProximiioAPI.sharedManager setApi:@"https://api.proximi.fi"];
        Proximiio.sharedInstance.delegate = self;
        //Proximiio.sharedInstance.desiredAccuracy = kIALocationAccuracyLow;
        [Proximiio.sharedInstance authWithToken:PROXIMIIO_TOKEN callback:^(ProximiioState result) {
            NSLog(@"proximio: %d", result);
            
            if (result == kProximiioReady) {
                       [[Proximiio sharedInstance] enable];
                       [[Proximiio sharedInstance] startUpdating];

                       [[Proximiio sharedInstance] setDelegate: self];

                       [[Proximiio sharedInstance] setBufferSize:kProximiioBufferMini];
                       [Proximiio sharedInstance].desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                   }
        }];
    }];
}

- (void) registerServices {
#if !(TARGET_IPHONE_SIMULATOR)
    DDLogInfo(@"SCLFlicManager configureWithDelegate");
    UIApplication* app = [UIApplication sharedApplication];
    self.flicInitTask = [app beginBackgroundTaskWithExpirationHandler:^{
        DDLogInfo(@"Flic init task expired");
        [app endBackgroundTask:self.flicInitTask];
        self.flicInitTask = UIBackgroundTaskInvalid;
    }];
    self.flic2InitTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask: self.flic2InitTask];
        self.flic2InitTask = UIBackgroundTaskInvalid;
    }];

    [SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:SCL_APP_ID appSecret:SCL_APP_SECRET backgroundExecution:YES];
    [FLICManager configureWithDelegate:self buttonDelegate:self background:YES];
#endif
}

- (void)showIncomingCall:(NSDictionary*)userInfo {
    incomingCall = YES;
    NSString* roomName = [userInfo objectForKey:@"room"];
    NSString* token = [userInfo objectForKey:@"token"];
    VideoViewController* vc = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    vc.roomName = roomName;
    vc.token = token;
    vc.recipient = [userInfo objectForKey:@"name"];
    vc.alertUserId = [userInfo objectForKey:@"user"];
    incomingCall = NO;
    [self.mainController.alertyViewController presentViewController:vc animated:YES completion:nil];
}

- (void) answerIncomingCall:(NSDictionary*)userInfo {
    incomingCall = YES;
    NSString* roomName = [userInfo objectForKey:@"room"];
    NSString* token = [userInfo objectForKey:@"token"];
    VideoViewController* vc = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    vc.roomName = roomName;
    vc.token = token;
    vc.recipient = [userInfo objectForKey:@"name"];
    vc.startIncomingCall = YES;
    incomingCall = NO;
    [self.mainController.alertyViewController presentViewController:vc animated:YES completion:nil];
}

- (void) openIncomingAlarm:(NSDictionary*)userInfo message:(NSString*)message {
    if ([self.mainController.presentedViewController isKindOfClass:UINavigationController.class]) {
        UINavigationController* nc = (UINavigationController*) self.mainController.presentedViewController;
        if ([nc.viewControllers.firstObject isKindOfClass:AlertMapViewController.class]) {
            AlertMapViewController* alertMapViewController = (AlertMapViewController*) nc.viewControllers.firstObject;
            NSInteger alert = [userInfo[@"alert"] integerValue];
            if (alertMapViewController.alertID == alert) {
                return;
            }
        }
    }
    incomingCall = NO;
	AlertInfo* alert = [self.alertManager addAlertWithAlertId:[userInfo[@"alert"] integerValue]
                                                  alertUserId:userInfo[@"user"]
                                                     userName:userInfo[@"name"]
                                                      message:message
                                                     roomName:[userInfo objectForKey:@"room"]
                                                        token:[userInfo objectForKey:@"token"]];
    [self showAlert: alert openAlert:YES];
}

- (void) rejectCall:(NSDictionary *)userInfo {
    NSString* user = [userInfo objectForKey:@"user"];
    [self dismissCall:user];
}

/*- (void) restartConnectionTimer {
	
	if (self.connectionNotification) [[UIApplication sharedApplication] cancelLocalNotification:self.connectionNotification];
	
	self.connectionNotification = [[[UILocalNotification alloc] init] autorelease];
	self.connectionNotification.fireDate = [[NSDate now] addSeconds:130];
	self.connectionNotification.timeZone = [NSTimeZone systemTimeZone];
	
	self.connectionNotification.alertAction = NSLocalizedString(@"Open", @"");
	self.connectionNotification.alertBody = NSLocalizedString(@"Connection is lost!", @"");
	[[UIApplication sharedApplication] scheduleLocalNotification:self.connectionNotification];
}*/

- (void) startAlert:(NSNumber*) source {
	NSLog(@"start alert");
	if ([AlertyViewController canSendAlert] && ![DataManager sharedDataManager].underSosMode) {
		// start alert instantly
		NSLog(@"start sos mode");
        [self.mainController.alertyViewController startSosMode:source lock:nil];
        [self.mainController addTimer:nil];
        
		if (![AlertySettingsMgr discreteModeEnabled] && !([UIApplication sharedApplication].applicationState == UIApplicationStateActive)) {
			[AlertyAppDelegate showLocalNotification:NSLocalizedString(@"An alarm has been activated", @"") action:NSLocalizedString(@"Open", @"") userInfo:nil];
		}
	}
}

- (void)batteryChanged:(NSNotification *)notification {
	NSLog(@"BATTERY CHANGED --------------------");
	[[DataManager sharedDataManager] startSynchronization];
}

- (void)networkChanged:(NSNotification *)notification {
	
	if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) return;
	if (![AlertySettingsMgr userName]) return;
	if (![AlertySettingsMgr askNetwork]) return;
	if ([DataManager sharedDataManager].sos) return;
	
	UINavigationController *settingsNavController = (UINavigationController*)self.mainController.selectedViewController;
	UIViewController *settingsController = [settingsNavController.viewControllers objectAtIndex:0];
	UIViewController *topViewController = [settingsController.navigationController topViewController];
	if ([topViewController isKindOfClass:[VideoViewController class]]) return;
	if ([topViewController isKindOfClass:[WifiApInfoViewController class]]) return;
	
	WifiAP* currentWifiAp = [WifiApMgr currentWifiAp];
	NSString* bssid = [WifiApMgr fetchBSSIDInfo];
	if (bssid && !currentWifiAp) {
		if (![AlertySettingsMgr isNoWifi:bssid]) {
			NSString* caption = NSLocalizedString(@"New access point", @"");
			NSString* message = NSLocalizedString(@"Do you you want to save this access point to improve your indoor location?", @"");
			message = [[message stringByAppendingString:@"\nBSSID: "] stringByAppendingString:bssid];

            UIAlertController* alert = [UIAlertController alertControllerWithTitle:caption message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSString* bssid = [WifiApMgr fetchBSSIDInfo];
                if (bssid) {
                    [AlertySettingsMgr addNoWifi:bssid];
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.showIndoorPositioning = YES;
                
                IndoorLocationingViewController* ilvc = [[IndoorLocationingViewController alloc] init];
                UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:ilvc];
                nvc.navigationBarHidden = NO;
                nvc.navigationBar.translucent = NO;
                [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
            }]];
            [self.mainController presentViewController:alert animated:YES completion:nil];
		}
	}
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if ([ self didUserPressLockButton]) {
        printf("lock button  pressed didUserPressLockButton");
    }
    
    //[self.manDownMgr stopManDown];
    [Proximiio.sharedInstance extendBackgroundTime];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    [[DataManager sharedDataManager] startSynchronization];
    if ([AlertySettingsMgr userID] != 0) {
        [self startSignificantLocationService];
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            if ((AlertySettingsMgr.lAlarmEnabled) && (self->alarmRejected == NO)) {
                
                UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
                localNotification.title = [NSString localizedUserNotificationStringForKey:@"Alerty - LARM!" arguments:nil];
                localNotification.body = [NSString localizedUserNotificationStringForKey:@"Håll din app aktiv i ditt larmaktiva tillstånd." arguments:nil];
                localNotification.sound = [UNNotificationSound defaultSound];
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
                
                localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
                
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"App Active" content:localNotification trigger:trigger];
                
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    NSLog(@"Notification created");
                }];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
	application.applicationIconBadgeNumber = 0;
    NSDate *thisMagicMoment = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:thisMagicMoment forKey:@"lastMagicMoment"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

	application.applicationIconBadgeNumber = 0;
	
	// check upgrade
	//[self checkForUpgrade];
    
    [self startManDown];
    
    //[[DataManager sharedDataManager] reloadFriends:TRUE];
    
    if ([AlertySettingsMgr userID] != 0) {
        [DataManager.sharedDataManager getMaps];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSDate *thisMagicMoment = [NSDate date];
    NSDate *lastMagicMoment =  (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lastMagicMoment"];
    int timeNew;

    if (lastMagicMoment==nil)
    {
        NSLog (@"First launch!");
    }
    else
    {
        
        NSTimeInterval timeOfNoMagic = [thisMagicMoment timeIntervalSinceDate:lastMagicMoment];
        NSLog (@"Application was in background for %.1f seconds", timeOfNoMagic);
        timeNew = round(timeOfNoMagic);
        timeNew = 20-timeNew;
    }
    if (AlertySettingsMgr.lAlarmEnabled && self->alarmRejected == YES) {
        
        UINavigationController *settingsNavController = (UINavigationController*)self.mainController.selectedViewController;
        UIViewController *settingsController = [settingsNavController.viewControllers objectAtIndex:0];
        UIViewController *topViewController = [settingsController.navigationController topViewController];
//        if ([topViewController isKindOfClass:[LAlarmOnOffVC class]]) {
            [settingsController.navigationController dismissControllerAnimated:YES];
//        }
        LAlarmTimerVC* vc = [[LAlarmTimerVC alloc] initWithNibName:@"LAlarmTimerVC" bundle:nil];
        vc->currSeconds = timeNew;
        vc.modalPresentationStyle =UIModalPresentationFullScreen;
        [self.mainController.alertyViewController presentViewController:vc animated:YES completion:nil];
    }
    self->alarmRejected = NO;

#if !(TARGET_IPHONE_SIMULATOR)
    [SCLFlicManager.sharedManager onLocationChange];
#endif

    [[DataManager sharedDataManager] startSynchronization];

    application.applicationIconBadgeNumber = 0;
	[DataManager sharedDataManager].lastLocation.userAddress = nil;
	[DataManager sharedDataManager].lastLocation.userCity = nil;
	[DataManager sharedDataManager].lastLocation.userCountry = nil;
    self.sosCounter = 0;
	[self networkChanged:nil];
	
	[self.mainController clearNetworkNotification];
	[self.mainController.alertyViewController.lockView startAnimation];
    
    if (self.manDownTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.manDownTask];
        self.manDownTask = UIBackgroundTaskInvalid;
    }
    
    NSDate* timer = AlertySettingsMgr.timer;
    if (timer && [timer timeIntervalSinceNow] < 30 && [timer timeIntervalSinceNow] > 0) {
        [self.mainController showManDownView:YES];
    }
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
    DDLogInfo(@"applicationProtectedDataDidBecomeAvailable");
    [NSUserDefaults resetStandardUserDefaults];
    
#if !(TARGET_IPHONE_SIMULATOR)
    if (![SCLFlicManager sharedManager].knownButtons.count) return;
    
    DDLogInfo(@"SCLFlicManager configureWithDelegate");

    UIApplication* app = [UIApplication sharedApplication];
    self.flicInitTask = [app beginBackgroundTaskWithExpirationHandler:^{
        DDLogInfo(@"Flic init task expired");
        [app endBackgroundTask:self.flicInitTask];
        self.flicInitTask = UIBackgroundTaskInvalid;
    }];
    //[SCLFlicManager configureWithDelegate:self defaultButtonDelegate:self appID:SCL_APP_ID appSecret:SCL_APP_SECRET backgroundExecution:YES];
    SCLFlicManager* manager = SCLFlicManager.sharedManager;
    NSArray* keys = manager.knownButtons.allKeys;
    for (int i=0; i<keys.count; i++) {
        for(id key in manager.knownButtons)
        {
            SCLFlicButton *button = manager.knownButtons[key];
            //[button setMode:SCLFlicButtonModeForeground];
            button.delegate = self;
            [button connect];
        }
    }
    if (FLICManager.sharedManager.buttons.count) {
        self.flic2InitTask = [app beginBackgroundTaskWithExpirationHandler:^{
            [app endBackgroundTask: self.flic2InitTask];
            self.flic2InitTask = UIBackgroundTaskInvalid;
        }];
        [FLICManager configureWithDelegate:self buttonDelegate:self background:YES];
    }

#endif
    //[[SCLFlicManager sharedManager] onLocationChange];
}

#pragma mark - Notification handling

- (void) registerNotifications {

    UNUserNotificationCenter.currentNotificationCenter.delegate = self;
    
    [UNUserNotificationCenter.currentNotificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusDenied) {
            [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCriticalAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
                [self initProximi];
                [self registerServices];
            }];
        } else {
            [self initProximi];
            [self registerServices];
        }
    }];
    
    UNNotificationAction* acceptCallAction = [UNNotificationAction actionWithIdentifier:@"ANSWER_CALL" title:NSLocalizedString(@"Answer", @"") options:UNNotificationActionOptionForeground];
    UNNotificationAction* rejectCallAction = [UNNotificationAction actionWithIdentifier:@"REJECT_CALL" title:NSLocalizedString(@"Reject", @"") options:UNNotificationActionOptionForeground];
    
    UNNotificationCategory* callCategory = [UNNotificationCategory categoryWithIdentifier:@"CALL_CATEGORY" actions:@[acceptCallAction, rejectCallAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    
    UNNotificationAction* acceptAlertAction = [UNNotificationAction actionWithIdentifier:@"OPEN_ALERT" title:NSLocalizedString(@"View", @"") options:UNNotificationActionOptionForeground];
    UNNotificationAction* rejectAlertAction = [UNNotificationAction actionWithIdentifier:@"REJECT_ALERT" title:NSLocalizedString(@"Reject", @"") options:UNNotificationActionOptionForeground];
    
    UNNotificationCategory* alertCategory = [UNNotificationCategory categoryWithIdentifier:@"ALERT_CATEGORY" actions:@[acceptAlertAction, rejectAlertAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    NSSet *categories = [NSSet setWithObjects:callCategory, alertCategory, nil];
    [UNUserNotificationCenter.currentNotificationCenter setNotificationCategories:categories];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
   
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (notification.userInfo.count) {
        if ([notification.userInfo objectForKey:@"mandown"]) {
            [self.mainController showManDownView:NO];
            return;
        };
        [self showRemoteNotification:notification.userInfo];
        return;
    }
	/*if (application.applicationState == UIApplicationStateActive) */
    {
        if ([notification.alertBody isEqualToString:NSLocalizedString(@"An alarm will be activated within 30 seconds.", @"")]) {
            // show mandownview
            [self.mainController showManDownView:YES];
        } else {
            self.flicNotification = nil;
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Confirmation", @"")
                                                                           message:notification.alertBody
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self.mainController presentViewController:alert animated:YES completion:nil];
        }
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSDictionary* aps = userInfo[@"aps"];
    NSNumber* contentAvailable = aps[@"content-available"];
    if (contentAvailable && [contentAvailable integerValue] == 1) {

        NSString* command = userInfo[@"custom"];
        if ([command isEqualToString:@"rejectcall"]) {
            UINavigationController *selectedController = (UINavigationController*)self.mainController.selectedViewController;
            UIViewController *topViewController = [selectedController topViewController];
            id y = [topViewController presentedViewController];
            id x = [self.mainController.alertyViewController presentedViewController];
            if ([y isKindOfClass:[VideoViewController class]] || [x isKindOfClass:[VideoViewController class]]) {
                VideoViewController* vc = (VideoViewController*)y;
                [vc performSelectorOnMainThread:@selector(callRejected) withObject:nil waitUntilDone:NO];
            }
        } else if ([command compare:@"missed"] == NSOrderedSame) {
            UINavigationController *selectedController = (UINavigationController*)self.mainController.selectedViewController;
            UIViewController *topViewController = [selectedController topViewController];
            id y = [topViewController presentedViewController];
            id x = [self.mainController.alertyViewController presentedViewController];
            if ([y isKindOfClass:[VideoViewController class]] || [x isKindOfClass:[VideoViewController class]]) {
                VideoViewController* vc = (VideoViewController*)y;
                [vc performSelectorOnMainThread:@selector(callEnded) withObject:nil waitUntilDone:NO];
                return;
            }
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            notif.fireDate = [NSDate now];
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.hasAction = NO;
            notif.alertBody = [NSLocalizedString(@"Missed call from", @"") stringByAppendingString:userInfo[@"aps"][@"alert"]];
            notif.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        }
        
        [[DataManager sharedDataManager] startSynchronization];
        
        /*[MobileInterface keepAlive:^(BOOL success) {
            completionHandler(success ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultFailed);
            if (success) [AlertySettingsMgr setLastPositionDate:[NSDate now]];
        }];*/
    } else {
        [self showRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self sendTokenToServer:[AlertyAppDelegate encodeToHexString:deviceToken]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [_contextM stopContext];
	//[self stopAllLocation];
    [self startSignificantLocationService];
    
	//[self.client disconnectWithCompletionHandler:nil];
    if ([AlertySettingsMgr userID] != 0) {
        
        NSLog(@"applicationWillTerminate");
        UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
        localNotification.title = [NSString localizedUserNotificationStringForKey:@"Alerty - LARM!" arguments:nil];
        localNotification.body = [NSString localizedUserNotificationStringForKey:@"Håll din app aktiv i ditt larmaktiva tillstånd." arguments:nil];
        localNotification.sound = [UNNotificationSound defaultSound];
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
        
        localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"App Active" content:localNotification trigger:trigger];
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
//
//    UILocalNotification *_localNotification = [[UILocalNotification alloc] init];
//           _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
//           _localNotification.timeZone = [NSTimeZone defaultTimeZone];
//           _localNotification.alertBody = @"Beep... Beep... Beep...";
//           _localNotification.soundName = UILocalNotificationDefaultSoundName;
//           [[UIApplication sharedApplication]scheduleLocalNotification:_localNotification];
}



- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
    if (dynamicLink) {
        if (dynamicLink.url) {
            [self handleURL:dynamicLink.url];
        } else {
            // Dynamic link has empty deep link. This situation will happens if
            // Firebase Dynamic Links iOS SDK tried to retrieve pending dynamic link,
            // but pending link is not available for this device/App combination.
            // At this point you may display default onboarding view.
        }
        return YES;
    }
#if !(TARGET_IPHONE_SIMULATOR)
    if ([[SCLFlicManager sharedManager] handleOpenURL:url]) return YES;
    if ([[url scheme] isEqualToString:@"alertyFlic"]) {
        return [[SCLFlicManager sharedManager] handleOpenURL:url];
    }
    else
#endif
    if ([[url scheme] isEqualToString:@"getalerty"]) {
        NSString *taskName = [url host];
        if (taskName && [taskName compare:@"activate"] == NSOrderedSame) {
            [self.mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_WEB] lock:nil];
        }
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    BOOL handled = [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                            completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                                                         NSError * _Nullable error) {
                                                                [self handleURL:dynamicLink.url];
                                                            }];
    return handled;
}


- (void) handleURL:(NSURL*)url {
    NSString* query = url.query;
    NSArray* parameters = [query componentsSeparatedByString:@"&"];
    for (NSString* parameter in parameters) {
        NSArray* parts = [parameter componentsSeparatedByString:@"="];
        if (parts.count == 2) {
            NSString* key = parts[0];
            NSString* value = parts[1];
            if ([key isEqualToString:@"id"]) {
                [AlertySettingsMgr setLastUserID:value];
                [NSNotificationCenter.defaultCenter postNotificationName:kUserIdReceivedNotification object:self userInfo:nil];
            }
        }
    }
}

#pragma mark - Private Methods

- (void) dismissCall:(NSString*)user {
    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];

    NSString* userName = [AlertySettingsMgr isBusinessVersion] ? [AlertySettingsMgr userNameServer] : [AlertySettingsMgr userFullName];
    NSDictionary *body = @{ @"user": user, @"name": userName, @"userid":userId};
    [MobileInterface post:CANCELDIRECTCALL2_URL body:body completion:^(NSDictionary *result, NSString *errorMessage) {
            
    }];
}

+ (NSString *)encodeToHexString:(NSData*)data{
    unsigned char *d = (unsigned char*)[data bytes];
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i <[data length]; i++)
        [hash appendFormat:@"%02X", d[i]];
    return [hash lowercaseString];
}

#pragma mark - Public static methods

+ (AlertyAppDelegate*)sharedAppDelegate {
	return (AlertyAppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (NSString*) country {
	return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString*) language {
	return [[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2];
}

+ (NSString*) locale {
	return [NSString stringWithFormat:@"%@_%@", [self language], [self country]];
}

+ (UILocalNotification*) showLocalNotification:(NSString *)body action:(NSString *)action userInfo:(NSDictionary*)userInfo
{
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	if (localNotif) {
		localNotif.alertBody = body;
		localNotif.alertAction = action;
		localNotif.soundName = UILocalNotificationDefaultSoundName;
		localNotif.applicationIconBadgeNumber = 0;
		localNotif.userInfo = userInfo;
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];
	}
	return localNotif;
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) startManDown {
	if( !self.manDownMgr ) {
		self.manDownMgr = [[ManDownMgr alloc] initWithDelegate:self];
	}
    if ([AlertySettingsMgr hasManDownMgr] || [AlertySettingsMgr hasPreactivation]) {
        [self.manDownMgr startManDown];
        [self.mainController.alertyViewController updateManDown];
    }
}

- (void) showAlertWithId: (int)alertId message:(NSString*) message user:(int)alertUserId roomName:(NSString*)roomName token:(NSString*)token userName:(NSString *)userName {
    [self.alertManager addAlertWithAlertId:alertId
                               alertUserId:[NSString stringWithFormat:@"%ld", (long)alertUserId]
                                  userName:userName
                                   message:message
                                  roomName:roomName
                                     token:token];
}

#pragma mark - Public instance methods

- (void) stopManDown {
	/*if( ![AlertySettingsMgr hasManDownMgr] && ![AlertySettingsMgr hasPreactivation] ) */{
		[self.manDownMgr stopManDown];
        [AlertySettingsMgr setManDownManager:NO];
        [self.mainController.alertyViewController updateManDown];
	}
}

- (void) stopManDownForTest {
	[self.manDownMgr stopManDown];
}

- (void) showRemoteNotification:(NSDictionary *)userInfo {
	NSString *message = nil;
	id aps = [userInfo objectForKey:@"aps"];
    id alert = [aps objectForKey:@"alert"];
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
	if ([alert isKindOfClass:[NSString class]]) {
        message = alert;
    } else if ([alert isKindOfClass:[NSDictionary class]]) {
        message = [alert objectForKey:@"body"];
    }
    if (message != nil) {
        if ([message endsWith:@"ended the call."] || [message endsWith:@"avslutade samtalet."]) {
            UINavigationController *selectedController = (UINavigationController*)self.mainController.selectedViewController;
            UIViewController *topViewController = [selectedController topViewController];
            id y = [topViewController presentedViewController];
            id x = [self.mainController.alertyViewController presentedViewController];
            if ([y isKindOfClass:[VideoViewController class]] || [x isKindOfClass:[VideoViewController class]]) {
                VideoViewController* vc = (VideoViewController*)y;
                [vc callRejected];
                return;
            }
        }
    }
    
	NSString* session = [userInfo objectForKey:@"session"];
	if (session && [userInfo objectForKey:@"alert"]) {
        AlertInfo* alert =  [self.alertManager addAlertWithAlertId:[userInfo[@"alert"] integerValue]
                                   alertUserId:userInfo[@"user"]
                                      userName:userInfo[@"name"]
                                       message:message
                                      roomName:userInfo[@"room"]
                                         token:userInfo[@"token"]];
		incomingCall = NO;
		[self showAlert: alert openAlert:YES];
	} else if (session) {
        [self showIncomingCall:userInfo];
    } else if (message) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Alerty", @"Target", @"")
															message:message
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
		[alertView show];
	}
	[[DataManager sharedDataManager] reloadFriends:YES];
}

- (void)sendTokenToServer:(NSString *)tokenString {
    NSDictionary* body = @{
        @"token": tokenString,
        @"udid": DEVICE_ID,
        @"type": ([AlertySettingsMgr isBusinessVersion] ? @"business" : @"personal")
    };
    [MobileInterface post:REGISTER_TOKEN body:body completion:^(NSDictionary *result, NSString *errorMessage) {
    }];
}

#pragma mark - ManDownMgrDelegate

- (void) didDetectManDown {
	if (![AlertyViewController canSendAlert]) return;
	if ([DataManager sharedDataManager].underSosMode) return;
	if ([self.mainController isManDownViewShowing]) return;
	
	if ([AlertySettingsMgr hasPreactivation]) {
		// start alert instantly
        [self.mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_MANDOWN] lock:nil];
	}
	else {
		// show man down view first
        
        UNMutableNotificationContent* contentPre = [[UNMutableNotificationContent alloc] init];
        contentPre.body = NSLocalizedString(@"An alarm will be activated within 30 seconds.", @"");
        contentPre.sound = [UNNotificationSound criticalSoundNamed:@"beeping30.aif" withAudioVolume:1.0];
        contentPre.userInfo = @{@"mandown" : @YES};
        UNNotificationTrigger* triggerPre = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
        
        // Create the request object.
        UNNotificationRequest* requestPre = [UNNotificationRequest requestWithIdentifier:@"MANDOWN" content:contentPre trigger:triggerPre];
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:requestPre withCompletionHandler:^(NSError * _Nullable error) {
           if (error != nil) {
               NSLog(@"%@", error.localizedDescription);
           }
        }];
            
            /*UILocalNotification *notif = [[UILocalNotification alloc] init];
            notif.fireDate = [NSDate now];
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.hasAction = NO;
            notif.alertBody = NSLocalizedString(@"An alarm will be activated within 30 seconds.", @"");
            notif.soundName = @"beeping.aif";
            notif.userInfo = @{@"mandown" : @YES};
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];*/
            
            self.manDownTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                [[UIApplication sharedApplication] endBackgroundTask: self.manDownTask];
                self.manDownTask = UIBackgroundTaskInvalid;
            }];
        //}
        [self.mainController showManDownView:NO];
	}
}

#pragma mark - Start/stop location services

- (void) startUpdatingLocation {
    
    //NSInteger status = CLLocationManager.authorizationStatus;
    if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        self.locationManager = [[CLLocationManager alloc] init];
        //self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
    } else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied ||
               CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:NSLocalizedString(@"location_alert_title", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"location_alert_settings", @"")
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"location_alert_cancel", @"")
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        [self.mainController presentViewController:alert animated:YES completion:nil];
    }
    
    Proximiio.sharedInstance.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.interval = 5.0;
}

- (void) startSignificantLocationService {
    if (![DataManager sharedDataManager].underSosMode) {
        Proximiio.sharedInstance.desiredAccuracy = kCLLocationAccuracyBest;
        
        //[Proximiio.sharedInstance setAllowsBackgroundLocationUpdates:NO];
        
        self.interval = 60.0;
        
		if ([AlertySettingsMgr trackingEnabled] || [DataManager sharedDataManager].followMe) {
			/*[_locationManager startMonitoringSignificantLocationChanges];
			_locationManagerTracking.desiredAccuracy = [DataManager sharedDataManager].followMe ? kCLLocationAccuracyBest : kCLLocationAccuracyHundredMeters;
			[_locationManagerTracking startUpdatingLocation];*/

            //[Proximiio.sharedInstance selectApplication:@"Alerty Tracking"];
            
            //Proximiio.sharedInstance.desiredAccuracy = [DataManager sharedDataManager].followMe ? kCLLocationAccuracyBest : kCLLocationAccuracyThreeKilometers;
            //[Proximiio.sharedInstance enable];
            
#if !(TARGET_IPHONE_SIMULATOR)
        } else if ([SCLFlicManager sharedManager].knownButtons.count) {
            // we need this for flic and pebble update
			//[_locationManager startMonitoringSignificantLocationChanges];
			//[_locationManagerTracking stopUpdatingLocation];
#endif
        } else {
            //[_locationManager stopMonitoringSignificantLocationChanges];
            //[_locationManagerTracking stopUpdatingLocation];
        }
        if ([AlertySettingsMgr hasManDownMgr]) {
            //[_locationManager stopMonitoringSignificantLocationChanges];
            //_locationManager.distanceFilter = kCLDistanceFilterNone;
            //_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            //[_locationManager startUpdatingLocation];
            //[_locationManagerTracking stopUpdatingLocation];
        }
    } else {
        Proximiio.sharedInstance.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.interval = 5.0;

        //[Proximiio.sharedInstance setAllowsBackgroundLocationUpdates:YES];
        /*[_locationManager stopUpdatingLocation];
        [_locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:20.0];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        [_locationManager startUpdatingLocation];*/
        //[_locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void) stopAllLocation {
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self.mainController.alertyViewController resignFirstResponder];
}


- (void) showAlert:(AlertInfo*)alert openAlert:(BOOL)openAlert {
	if (!incomingCall) {
//        [UNUserNotificationCenter.currentNotificationCenter removeAllDeliveredNotifications];
		AlertMapViewController* alertVC = [[AlertMapViewController alloc] initWithNibName:@"AlertMapViewController" bundle:nil];
		alertVC.alertUserId = alert.alertUserId;
		alertVC.alertID  = alert.alertId;
        alertVC.alertUserName = alert.userName;
		alertVC.roomName = alert.roomName;
		alertVC.token  =alert.token;
        alertVC.openAlert = openAlert;
        alertVC.statusText = alert.message;
        UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:alertVC];
        controller.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0];
        controller.navigationBar.tintColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [controller.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]}];
        controller.navigationBar.translucent = NO;
        //controller.navigationBarHidden = YES;
        [self.mainController.alertyViewController.navigationController dismissControllerAnimated:NO];
        [self.mainController.alertyViewController.navigationController presentController:controller animated:YES];
	}
}

#pragma mark UNNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    /*if ([notification.request.identifier isEqualToString:@"TIMER"]) {
        [self performSelectorOnMainThread:@selector(startAlert:) withObject:[NSNumber numberWithInt:ALERT_SOURCE_TIMER] waitUntilDone:NO];
        [self.mainController.alertyViewController removeTimer];
    }*/

    if ([notification.request.identifier isEqualToString:@"TIMER_PRE"]) {
        [self.mainController showManDownView:YES];
    }
    if ([notification.request.identifier isEqualToString:@"HOME_PRE"]) {
        [self.mainController showManDownViewHome:YES];
    }

    if ([notification.request.content.categoryIdentifier isEqualToString:@"ALERT_CATEGORY"]) {
        incomingCall = NO;
        
        NSDictionary* alertInfo = notification.request.content.userInfo[@"session"];
        [self.alertManager addAlertWithAlertId:[alertInfo[@"alert"] integerValue]
                                   alertUserId:alertInfo[@"user"]
                                      userName:alertInfo[@"name"]
                                       message:notification.request.content.body
                                      roomName:alertInfo[@"room"]
                                         token:alertInfo[@"token"]];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {

    NSString* identifier = response.actionIdentifier;
    
    if ([identifier compare:@"ANSWER_CALL"] == NSOrderedSame) {
        [self answerIncomingCall: response.notification.request.content.userInfo[@"session"]];
        completionHandler();
        return;
    }
    
    if ([identifier compare:@"REJECT_CALL"] == NSOrderedSame) {
        NSString* user = response.notification.request.content.userInfo[@"session"][@"user"];
        [self dismissCall:user];
        completionHandler();
        return;
    }
    
    if ([identifier compare:@"OPEN_ALERT"] == NSOrderedSame) {
        NSDictionary* userData = response.notification.request.content.userInfo[@"session"];
        [self openIncomingAlarm:userData message:response.notification.request.content.body];
        completionHandler();
        return;
    }
    
    if ([identifier compare:@"REJECT_ALERT"] == NSOrderedSame) {
        NSDictionary* alertInfo = response.notification.request.content.userInfo[@"session"];
        [self.alertManager addAlertWithAlertId:[alertInfo[@"alert"] integerValue]
                                   alertUserId:alertInfo[@"user"]
                                      userName:alertInfo[@"name"]
                                       message:response.notification.request.content.body
                                      roomName:alertInfo[@"room"]
                                         token:alertInfo[@"token"]];
        completionHandler();
        return;
    }
    
    if ([response.notification.request.identifier isEqualToString:@"TIMER_PRE"]) {
        if ([AlertySettingsMgr.timer timeIntervalSinceNow] > 0) {
            [self.mainController showManDownView:YES];
        }
        //[self.mainController.alertyViewController removeTimer];
    }
    if ([response.notification.request.identifier isEqualToString:@"HOME_PRE"]) {
        if ([AlertySettingsMgr.homeTimer timeIntervalSinceNow] > 0) {
            [self.mainController showManDownView:YES];
        }
        //[self.mainController.alertyViewController removeTimer];
    }
    
    
    id session = [response.notification.request.content.userInfo objectForKey:@"session"];
    if (session) {
        if ([session isKindOfClass:NSString.class]) {
            if ([session startsWith:@"https://"]) {
                NSURLComponents* components = [NSURLComponents componentsWithString:session];
                if ([components.path.lastPathComponent isEqualToString:@"followmap.php"]) {
                    NSString* userId;
                    NSString* name;
                    for (NSURLQueryItem* item in components.queryItems) {
                        if ([item.name isEqualToString:@"id"]) {
                            userId = item.value;
                        }
                        if ([item.name isEqualToString:@"name"]) {
                            name = item.value;
                        }
                    }
                    [self.mainController.alertyViewController followMeReceived:name userId:userId showFollowing:YES];
                } else {
                    [UIApplication.sharedApplication openURL:[NSURL URLWithString:session] options:@{} completionHandler:nil];
                }
            }
            else if ([session isEqualToString:@"alarm"]) {
                [self.mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_TWILIO] lock:nil];
            }
        }
        if ([session isKindOfClass:NSDictionary.class]) {
            NSDictionary* userData = (NSDictionary*)session;
            NSString* command = userData[@"command"];
            if ([command isEqualToString:@"incoming"]) {
                [self answerIncomingCall:userData];
            }
            else if ([command isEqualToString:@"voipalarm"]) {
                [self openIncomingAlarm:userData message:response.notification.request.content.body];
            }
        }
    }

    if (completionHandler) {
        completionHandler();
    }
}

#pragma mark - SCLFlicManagerDelegate

- (void) flicManager:(SCLFlicManager *)manager didChangeBluetoothState: (SCLFlicManagerBluetoothState) state {
    
}

- (void) flicManager:(SCLFlicManager *)manager didDiscoverButton:(SCLFlicButton *)button withRSSI:(NSNumber *)RSSI {
    
}

- (void) flicManager:(SCLFlicManager *)manager didForgetButton:(NSUUID *)buttonIdentifier error:(NSError *)error {
    
}

- (void) flicManager:(SCLFlicManager *)manager didGrabFlicButton:(SCLFlicButton *)button withError:(NSError *) error {
}

- (void) flicManagerDidRestoreState:(SCLFlicManager *)manager {
    DDLogInfo(@"AlertyApplication flicManagerDidRestoreState: %ld buttons", (long)manager.knownButtons.allKeys.count);

#if !(TARGET_IPHONE_SIMULATOR)
    NSArray* keys = manager.knownButtons.allKeys;
    for (int i=0; i<keys.count; i++) {
        for(id key in manager.knownButtons)
        {
            SCLFlicButton *button = manager.knownButtons[key];
            //[button setMode:SCLFlicButtonModeForeground];
            button.delegate = self;
            [button connect];
        }
    }
    //UIApplication* app = [UIApplication sharedApplication];
    //[app endBackgroundTask:self.flicInitTask];
#endif
}

- (void) flicButton:(SCLFlicButton *) button didReceiveButtonHold:(BOOL) queued age: (NSInteger) age {
}

- (void) flicButton:(SCLFlicButton *) button didReceiveButtonClick:(BOOL) queued age: (NSInteger) age {
    [self handleFlicButtonClick];
}

- (void)startVibration:(NSNumber*) count {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    int c = [count intValue];
    if (c > 0) [self performSelector:@selector(startVibration:) withObject:[NSNumber numberWithInt:c-1] afterDelay:0.1];
}

- (void) flicButtonDidConnect:(SCLFlicButton *)button {
    if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(flicButtonDidConnect:)]) {
        [self.buttonDelegate flicButtonDidConnect:button];
    }
}

- (void) flicButtonIsReady:(SCLFlicButton *)button {
    if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(flicButtonIsReady:)]) {
        [self.buttonDelegate flicButtonIsReady:button];
    }
}

- (void) flicButton:(SCLFlicButton *) button didReceiveButtonDown:(BOOL) queued age: (NSInteger) age {
    [self.flicTimer invalidate];
    self.flicTimer = nil;
    if (!queued || age < 2) {
        self.flicTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(flicAlertStarted) userInfo:nil repeats:NO];
    }
}

- (void) flicButton:(SCLFlicButton *) button didReceiveButtonUp:(BOOL) queued age: (NSInteger) age {
    [self.flicTimer invalidate];
    self.flicTimer = nil;
}
    
- (void) flicButton:(SCLFlicButton *)button didFailToConnectWithError:(NSError *)error {
    if (self.buttonDelegate && [self.buttonDelegate respondsToSelector:@selector(flicButton:didFailToConnectWithError:)]) {
        [self.buttonDelegate flicButton:button didFailToConnectWithError:error];
    }
}

- (void) flicAlertStarted {
    [self.flicTimer invalidate];
    self.flicTimer = nil;
    if ([AlertyViewController canSendAlert] && ![DataManager sharedDataManager].underSosMode) {
        // start alert instantly
        [self.mainController.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_EXTERNAL_BUTTON] lock:nil];
            
        if (![AlertySettingsMgr discreteModeEnabled] && !([UIApplication sharedApplication].applicationState == UIApplicationStateActive)) {
            [AlertyAppDelegate showLocalNotification:NSLocalizedString(@"An alarm has been activated", @"") action:NSLocalizedString(@"Open", @"") userInfo:nil];
        }
    }
}

#pragma mark Logs 

- (NSMutableArray *)errorLogData {
    NSUInteger maximumLogFilesToReturn = MIN(self.fileLogger.logFileManager.maximumNumberOfLogFiles, 10);
    NSMutableArray *errorLogFiles = [NSMutableArray arrayWithCapacity:maximumLogFilesToReturn];
    NSArray *sortedLogFileInfos = [self.fileLogger.logFileManager sortedLogFileInfos];
    for (int i = 0; i < MIN(sortedLogFileInfos.count, maximumLogFilesToReturn); i++) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:i];
        NSData *fileData = [NSData dataWithContentsOfFile:logFileInfo.filePath];
        [errorLogFiles insertObject:fileData atIndex:0];
    }
    return errorLogFiles;
}

- (void)composeEmailWithDebugAttachment {
    if ([MFMailComposeViewController canSendMail]) {
        //[UINavigationBar appearance].barTintColor = [UIColor redColor];
        //[[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;

        NSMutableData *errorLogData = [NSMutableData data];
        for (NSData *errorLogFileData in [self errorLogData]) {
            [errorLogData appendData:errorLogFileData];
            [errorLogData appendString:@"----------------------------------\r\n"];
        }
        [mailViewController addAttachmentData:errorLogData mimeType:@"text/plain" fileName:@"errorLog.txt"];
        [mailViewController setSubject:NSLocalizedString(@"Alerty Personal Alarm log", @"")];
        [mailViewController setToRecipients:[NSArray arrayWithObject:@"info@getalerty.com"]];
        //[mailViewController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.mainController presentViewController:mailViewController animated:YES completion:^{
            //[UINavigationBar appearance].barTintColor = REDESIGN_COLOR_CANCEL;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }];
    }
    else {
        NSString *message = NSLocalizedString(@"Sorry, your issue can't be reported right now. This is most likely because no mail accounts are set up on your mobile device.", @"");
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil] show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ProximiioDelegate

- (void)proximiioLostiBeacon:(ProximiioIBeacon *)beacon {
    [DataManager sharedDataManager].lastLocation.userAddress = nil;
    [DataManager sharedDataManager].lastLocation.userCountry = nil;
    [DataManager sharedDataManager].lastLocation.userCity = nil;
}

- (void)proximiioPositionUpdated:(ProximiioLocation*)location {
    
    if (location != nil) {
        NSLog(@"User position updated to: %@", location);
        
#if !(TARGET_IPHONE_SIMULATOR)
        [SCLFlicManager.sharedManager onLocationChange];
        
        /*    NSArray* keys = SCLFlicManager.sharedManager.knownButtons.allKeys;
         for (int i=0; i<keys.count; i++) {
         for(id key in SCLFlicManager.sharedManager.knownButtons) {
         SCLFlicButton *button = SCLFlicManager.sharedManager.knownButtons[key];
         switch (button.connectionState) {
         case SCLFlicButtonConnectionStateConnected:
         //DDLogInfo(@"FLIC button connected");
         break;
         case SCLFlicButtonConnectionStateConnecting:
         //DDLogInfo(@"FLIC button connecting");
         break;
         case SCLFlicButtonConnectionStateDisconnected:
         DDLogInfo(@"FLIC button disconnected");
         button.delegate = self;
         [button connect];
         break;
         case SCLFlicButtonConnectionStateDisconnecting:
         DDLogInfo(@"FLIC button disconnecting");
         button.delegate = self;
         [button connect];
         break;
         default:
         DDLogInfo(@"FLIC button unknown state");
         break;
         }
         
         }
         }*/
        
#endif
        
        if (self.lastPosition && (-1 * [self.lastPosition timeIntervalSinceNow]) < self.interval) {
            return;
        }
        self.lastPosition = [NSDate now];
        
        if (!AlertySettingsMgr.trackingEnabled && !DataManager.sharedDataManager.followMe && !AlertySettingsMgr.lastPositionEnabled &&
            !DataManager.sharedDataManager.underSosMode) {
            return;
        }
        
        self.sosCounter++;
        if (self.sosCounter % 60 == 59) {
            [DataManager sharedDataManager].lastLocation.userAddress = nil;
            [DataManager sharedDataManager].lastLocation.userCountry = nil;
            [DataManager sharedDataManager].lastLocation.userCity = nil;
        }
        
        /*if (newLocation.horizontalAccuracy <= 300) */{
            
            double distance = 0;
            /*if ([DataManager sharedDataManager].lastLocation && [DataManager sharedDataManager].underSosMode) {
             distance = [DataManager sharedDataManager].lastLocation.distance;
             distance += [self metersBetweenCoordinates:newLocation.coordinate :[DataManager sharedDataManager].lastLocation.coordinate];
             }*/
            MyLocation *myLoc = [[MyLocation alloc] initWithCoordinate:location.coordinate
                                                                 Speed:(int)(location.speed * 3.6)
                                                              Altitude:location.altitude
                                                               Heading:location.course
                                                              Accuracy:location.horizontalAccuracy
                                                      VerticalAccuracy:location.verticalAccuracy
                                                              Distance:distance
                                                              Duration:SOS_SYNC_INTERVAL
                                                             Timestamp:[location.timestamp timeIntervalSince1970]
                                                                   SOS:FALSE];
            
            WifiAP *wifiap = [WifiApMgr currentWifiAp];
            if (wifiap && wifiap.locationLat && wifiap.locationLon && ![location.source isKindOfClass:ProximiioIBeacon.class]) {
                CLLocationCoordinate2D wificoords = CLLocationCoordinate2DMake([wifiap.locationLat doubleValue], [wifiap.locationLon doubleValue]);
                myLoc = [[MyLocation alloc] initWithCoordinate:wificoords
                                                         Speed:0
                                                      Altitude:0
                                                       Heading:0
                                                      Accuracy:0
                                              VerticalAccuracy:0
                                                      Distance:0
                                                      Duration:SOS_SYNC_INTERVAL
                                                     Timestamp:[[NSDate date] timeIntervalSince1970]
                                                           SOS:FALSE];
                myLoc.wifiapname = wifiap.name;
                myLoc.wifiapbssid = wifiap.bssid;
                myLoc.mapId = wifiap.map;
                [DataManager sharedDataManager].lastLocation.userAddress = wifiap.info;
                [DataManager sharedDataManager].lastLocation.userCountry = nil;
                [DataManager sharedDataManager].lastLocation.userCity = nil;
            }
            
            if ([location.source isKindOfClass:ProximiioIBeacon.class]) {
                ProximiioIBeacon* beacon = (ProximiioIBeacon*)location.source;
                ProximiioInput* input = [ProximiioResourceManager.sharedManager inputWithUUID:beacon.uuid major:beacon.major minor:beacon.minor];
                if (input.floor) {
                    ProximiioFloor* floor = input.floor;
                    if (floor.floorId.length) {
                        NSInteger mapId = [input.floor.floorId integerValue];
                        myLoc.mapId = [NSNumber numberWithInteger:mapId];
                    }
                }
                /*NSString* bssid = [NSString stringWithFormat:@"%d:%d", beacon.major, beacon.minor];
                 NSArray* wifiaps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
                 for (int i=0; i<wifiaps.count; i++) {
                 WifiAP* ap = [wifiaps objectAtIndex:i];
                 if ([bssid compare:ap.bssid] == NSOrderedSame) {
                 myLoc.mapId = ap.map;
                 break;
                 }
                 }*/
            }
            if  (myLoc != nil) {
                [DataManager sharedDataManager].lastLocation = myLoc;
                [[DataManager sharedDataManager] registerMyLocation:myLoc];
                [[DataManager sharedDataManager] registerCurrentLocation:location.coordinate];
            }
            if( _getGeoCode == nil ) {
                _getGeoCode = [[GeoAddress alloc] init];
            }
            
            if ([location.source isKindOfClass:ProximiioIBeacon.class]) {
                ProximiioIBeacon* beacon = (ProximiioIBeacon*)location.source;
                ProximiioInput* input = [ProximiioResourceManager.sharedManager inputWithUUID:beacon.uuid major:beacon.major minor:beacon.minor];
                if (input && input.floor) {
                    [DataManager sharedDataManager].lastLocation.userAddress = input.floor.place.address == nil ? @"NA" : input.floor.place.address;
                    [DataManager sharedDataManager].lastLocation.wifiapname = [NSString stringWithFormat:@"%@/%@/%@", input.floor.place.name, input.floor.name, input.department.name];
                    [DataManager sharedDataManager].lastLocation.userCountry = nil;
                    [DataManager sharedDataManager].lastLocation.userCity = nil;
                } else {
                    NSString* bssid = [NSString stringWithFormat:@"%d:%d", beacon.major, beacon.minor];
                    NSArray* wifiaps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
                    for (int i=0; i<wifiaps.count; i++) {
                        WifiAP* ap = [wifiaps objectAtIndex:i];
                        if ([bssid compare:ap.bssid] == NSOrderedSame) {
                            [DataManager sharedDataManager].lastLocation.userAddress = ap.info;
                            [DataManager sharedDataManager].lastLocation.wifiapname = ap.name;
                            [DataManager sharedDataManager].lastLocation.userCountry = nil;
                            [DataManager sharedDataManager].lastLocation.userCity = nil;
                            break;
                        }
                    }
                    /*NSArray* wifiAps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
                     for (NSUInteger i=0; i<self.beacons.count; i++) {
                     MeasuredBeacon* mb = [self.beacons objectAtIndex:i];
                     NSString* bssid = [NSString stringWithFormat:@"%d:%d", [mb.beacon.major intValue], [mb.beacon.minor intValue]];
                     for (int i=0; i<wifiAps.count; i++) {
                     WifiAP* ap = [wifiAps objectAtIndex:i];
                     if ([ap.bssid compare:bssid] == NSOrderedSame) {
                     if ((!self.closestAP || mb.accuracy < distance) && mb.beacon.accuracy > 0) {
                     distance = mb.accuracy;
                     self.closestAP = ap;
                     break;
                     }
                     }
                     }*/
                }
            } else if (self.locationFromBeacon) {
                [DataManager sharedDataManager].lastLocation.userAddress = nil;
                [DataManager sharedDataManager].lastLocation.userCountry = nil;
                [DataManager sharedDataManager].lastLocation.userCity = nil;
            }
            self.locationFromBeacon = [location.source isKindOfClass:ProximiioIBeacon.class];
            
            if ([DataManager sharedDataManager].lastLocation.userAddress == nil) {
                [_getGeoCode getGeoAddressByCoordinate:location.coordinate];
            }
            
            if (DataManager.sharedDataManager.followMe || DataManager.sharedDataManager.underSosMode) {
                [[DataManager sharedDataManager] startSynchronization];
            } else if (AlertySettingsMgr.lastPositionEnabled) {
                NSDate* last = AlertySettingsMgr.lastPositionDate;
                if (!last || [last timeIntervalSinceNow] < -60.0) {
                    [MobileInterface keepAlive:DataManager.sharedDataManager.lastLocation source: @"ios" completion:^(BOOL success) {
                        if (success) {
                            [AlertySettingsMgr setLastPositionDate:[NSDate date]];
                        }
                    }];
                }
            }
        }
    }
}
    
    // call requestPermission if you want to handle location permission by Proximio.io SDK
- (void)onProximiioReady {
    //[[Proximiio sharedInstance] requestPermissions];
    
    //[Proximiio.sharedInstance selectApplication:@"Alerty GPS"];
    
    [self startSignificantLocationService];
    
    //NSArray<ProximiioDepartment*>* departments = Proximiio.sharedInstance.departments;
    //NSLog(@"departments: %ld", departments.count);
    
    //[Proximiio.sharedInstance stopUpdating];
    
    //Proximiio.sharedInstance.desiredAccuracy = kCLLocationAccuracyHundredMeters;
}

- (void) proximiioFoundiBeacon:(ProximiioIBeacon *)beacon {
}

- (void) proximiioUpdatediBeacon:(ProximiioIBeacon *)beacon {
}

#pragma mark - FLICManagerDelegate

- (void)managerDidRestoreState:(FLICManager *)manager {
    for(FLICButton* button in FLICManager.sharedManager.buttons) {
        //[button setMode:SCLFlicButtonModeForeground];
        button.delegate = self;
        [button connect];
    }
    UIApplication* app = [UIApplication sharedApplication];
    [app endBackgroundTask: self.flic2InitTask];
}


#pragma mark - FLICButtonDelegate

- (void)button:(FLICButton *)button didReceiveButtonClick:(BOOL)queued age:(NSInteger)age {
    if (!queued || age == 0) {

    }
}

- (void)button:(FLICButton *)button didReceiveButtonDown:(BOOL)queued age:(NSInteger)age {
    [self.flicTimer invalidate];
    self.flicTimer = nil;
    if (!queued || age < 2) {
        self.flicTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(flicAlertStarted) userInfo:nil repeats:NO];
    }
}

- (void)button:(FLICButton *)button didReceiveButtonUp:(BOOL)queued age:(NSInteger)age {
    [self.flicTimer invalidate];
    if (self.flicTimer) {
        [self handleFlicButtonClick];
    }
    self.flicTimer = nil;
}

- (void) handleFlicButtonClick {
    NSString* message = NSLocalizedString(@"Find my lost phone", @"");
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        if (self.flicAlert) return;
        self.flicAlert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Alerty", @"Target", @"") message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.flicAlert = nil;
        }];
        [self.flicAlert addAction:action];
        UIViewController* vc = self.mainController.presentedViewController ? self.mainController.presentedViewController : self.mainController;
        [vc presentViewController:self.flicAlert animated:YES completion:nil];
    } else {
        if (self.flicNotification)  {
            [UIApplication.sharedApplication cancelLocalNotification:self.flicNotification];
        }
        self.flicNotification = [[UILocalNotification alloc] init];
        if (self.flicNotification) {
            self.flicNotification.fireDate = [NSDate now];
            self.flicNotification.timeZone = [NSTimeZone defaultTimeZone];
            self.flicNotification.alertBody = message;
            self.flicNotification.alertAction = nil;
            //self.flicNotification.soundName = @"beeping.aif";
            self.flicNotification.applicationIconBadgeNumber = 0;
            self.flicNotification.userInfo = [NSDictionary dictionary];
            [[UIApplication sharedApplication] scheduleLocalNotification:self.flicNotification];
        }
    }
    [self performSelector:@selector(startVibration:) withObject:[NSNumber numberWithInt:14] afterDelay:0.1];
    
    NSDictionary* body = @{ @"userid" : [NSNumber numberWithInteger:[AlertySettingsMgr userID]] };
    [MobileInterface post:ADDFLICTEST_URL body:body completion:^(NSDictionary *result, NSString *errorMessage) {
    }];
}

@end




#import <Foundation/Foundation.h>

typedef void (^DarwinNotificationBlock)(NSString *identifier);

@interface Darwin : NSObject

+ (Darwin *)sharedInstance;
- (void)startListening:(DarwinNotificationBlock)block;
- (void)test;

@end
