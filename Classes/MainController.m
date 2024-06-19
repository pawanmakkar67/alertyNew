//
//  MainController.m
//  Alerty
//
//  Created by moni on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "AlertyAppDelegate.h"
#import "AlertySettingsMgr.h"
#import "DataManager.h"
#import "NSBundleAdditions.h"
#import "NSHelpers.h"
#import "config.h"
#import "UIDeviceAdditions.h"
#import "SettingsViewController.h"
#import "GroupsViewController.h"
#import "IndoorLocationingViewController.h"
#import "MobileInterface.h"
#import "addAlarmVC.h"
@import UserNotifications;


@interface MainController() {
	BOOL _successfulConnection;
	int connectionProblemCounter;
}
@property (nonatomic, strong) LockView *lockView;
@property (nonatomic, strong) ManDownView *manDownView;
@property (nonatomic, strong) LockViewClosingView* lockViewClosingView;
@property (nonatomic, strong) UILocalNotification* networkNotification;
@property (nonatomic, assign) BOOL networkErrorShown;

@property (strong, nonatomic) NSString *detectedText;
@property (strong, nonatomic) NSTimer *restartSpeechTimer;
@property (strong, nonatomic) NSTimer *checkTimer;

@property (nonatomic, strong) IBOutlet FunctionsViewController *functionsViewController;
@property (nonatomic, strong) IBOutlet GroupsViewController *contactsViewController;
@property (nonatomic, strong) IBOutlet SettingsViewController *settingsViewController;

- (void) setupFakeyTabBarButtons;
@end

@implementation MainController

// private
@synthesize lockView = _lockView;
@synthesize manDownView = _manDownView;
// public
@synthesize networkNotification = _networkNotification;
@synthesize networkErrorShown;



#pragma mark - Overrides

- (void)viewDidLoad {
	[super viewDidLoad];
    	
	self.delegate = self;
	_successfulConnection = NO;
	connectionProblemCounter = 0;
	networkErrorShown = NO;
	
	[DataManager sharedDataManager].sos = NO;
	[DataManager sharedDataManager].alertId = -1;
	[DataManager sharedDataManager].newRoute = NO;
	[DataManager sharedDataManager].delegate = self;
	//[DataManager sharedDataManager].roomName = nil;
	//[DataManager sharedDataManager].token = nil;
	[DataManager sharedDataManager].voice = nil;
    [DataManager sharedDataManager].voicePhone = nil;
    
	[self setupFakeyTabBarButtons];
		
	//self.contactsViewController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	//self.contactsViewController.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[DataManager sharedDataManager] getUserSettings];
}

- (void) showSetPhoneNrAlert {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														 message:NSLocalizedString(@"You can now make and receive video calls. Your number is used to easier connect you and your contacts.",@"")
														delegate:self
											   cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
											   otherButtonTitles:NSLocalizedString(@"Ok",@""), nil
							   ];
	alertView.tag = 99;
	[alertView show];
}

- (void) clearNetworkNotification {
	if (self.networkNotification) {
		[[UIApplication sharedApplication] cancelLocalNotification:self.networkNotification];
		self.networkNotification = nil;
	}
	self.networkErrorShown = NO;
}


#pragma mark - Private methods

- (void) setupFakeyTabBarButtons
{
    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
    CGFloat topPadding = window.safeAreaInsets.top;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;

	self.fakeTabBar = [AlertyTabBar alertyTabBar];
    [self.fakeTabBar selectTab:0];
	[self.fakeTabBar setDelegate:self];
	[self.fakeTabBar setFrame:CGRectMake(0, self.view.frame.size.height-self.fakeTabBar.frame.size.height, self.view.frame.size.width, 70 + bottomPadding)];

//    self.fakeTabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    if (UIScreen.mainScreen.bounds.size.height == 812 || UIScreen.mainScreen.bounds.size.height == 896) {
//        CGRect frame = self.fakeTabBar.frame;
////        frame.origin.y -= 34;
//        
//        self.fakeTabBar.frame = frame;
//    }
    [self.view addSubview:self.fakeTabBar];
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

#pragma mark - Public methods

- (BOOL) isManDownViewShowing
{
	return _manDownView != nil;
}

- (void) showManDownView:(BOOL)isTimer {
	if (![self isManDownViewShowing]) {
        self.manDownView = [ManDownView manDownView:isTimer];
		_manDownView.delegate = self;
		if ([self isLockViewShowing]) { // bring lockview into foreground
			BOOL isScrollHidden = self.lockView.activeView.hidden;
			[self showLockView:NO activeText:nil];
			[_manDownView showInView:self.view];
			[self showLockView:YES activeText:isScrollHidden ? @"" : nil];
		} else {
			[_manDownView showInView:self.view];
		}
    } else {
        //NSString *soundFilePath = [[[NSBundle mainBundle] pathForResource: @"beeping30" ofType: @"aif"] retain];
        //[AudioPlayback start:soundFilePath loop:YES];
    }
}

- (void) showManDownViewHome:(BOOL)isAlarm {
    if (![self isManDownViewShowing]) {
        self.manDownView = [ManDownView manDownViewHome:isAlarm];
        _manDownView.delegate = self;
        if ([self isLockViewShowing]) { // bring lockview into foreground
            BOOL isScrollHidden = self.lockView.activeView.hidden;
            [self showLockView:NO activeText:nil];
            [_manDownView showInView:self.view];
            [self showLockView:YES activeText:isScrollHidden ? @"" : nil];
        } else {
            [_manDownView showInView:self.view];
        }
    } else {
        //NSString *soundFilePath = [[[NSBundle mainBundle] pathForResource: @"beeping30" ofType: @"aif"] retain];
        //[AudioPlayback start:soundFilePath loop:YES];
    }
}



- (BOOL) isLockViewShowing {
	return _lockView != nil;
}

- (void) showLockView:(BOOL)show activeText:(NSString *)activeText {
	if(show == [self isLockViewShowing]) return;
	if(show) {
		// show lock view
		self.lockView = [LockView lockView];
		_lockView.delegate = self;
		_lockView.frame = self.view.frame;
		_lockView.showPinEntryViewOnUnlock = YES;
		
		// set text if applicable
		if (activeText) {
			if (activeText.length) {
				_lockView.viewToast.alpha = 0.0;
			}
		}
		
		// hides info if called by the TabBar	
		_lockView.activeView.hidden = [activeText isEqualToString:@""];
		_lockView.bgView.hidden = [activeText isEqualToString:@""];
        _lockView.slideToLabel.hidden = [activeText isEqualToString:@""];
		[self.view addSubview:_lockView];
        
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
		
		[_lockView startAnimation];
        
        
        
        
        // SpeechRecognition:
        // Initialize the Speech Recognizer with the locale
        speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"sv_SE"]];  //en_US
        // Set speech recognizer delegate
        speechRecognizer.delegate = self;
        
        // Appels limit is 60s
        self.restartSpeechTimer = [NSTimer scheduledTimerWithTimeInterval: 58.0
                                                              target: self
                                                            selector:@selector(restartListening)
                                                            userInfo: nil repeats:YES];
        self.checkTimer = [NSTimer scheduledTimerWithTimeInterval: 0.7
                                                      target: self
                                                    selector:@selector(checkText)
                                                    userInfo: nil repeats:YES];
        [self restartListening];
	}
	else {
		// remove lockview
		if(_lockView) [_lockView removeFromSuperview];
		self.lockView = nil;
	}
}

- (void) checkText {
    [_detectedText lowercaseString];
    if ([_detectedText containsString:@"hjälp"] || [_detectedText containsString:@"help"]) {
        [self stopListening];
        [self performSelector:@selector(activateTheAlarm)
                   withObject:self
                   afterDelay:0.5];
    }
}
- (void) activateTheAlarm {
    _detectedText = @"";
    // remove locker
    [self showLockView:NO activeText:nil];
    // start sos mode
    [self.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_BUTTON] lock:YES];
}
- (void)stopListening {
    [self.restartSpeechTimer invalidate];
    [self.checkTimer invalidate];
    [audioEngine stop];
    [inputNode removeTapOnBus:0];
    [recognitionRequest endAudio];
}
- (void)startListening {
    // Initialize the AVAudioEngine
    audioEngine = [[AVAudioEngine alloc] init];
    // Make sure there's not a recognition task already running
    if (recognitionTask) {
        [recognitionTask cancel];
        recognitionTask = nil;
    }
    // Starts an AVAudio Session
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    // Starts a recognition process, in the block it logs the input or stops the audio
    // process if there's an error.
    recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    inputNode = audioEngine.inputNode;
    recognitionRequest.shouldReportPartialResults = YES;
    recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        if (result) {
            // Whatever you say in the microphone after pressing the button should be being logged
            // in the console.
            NSLog(@"RESULT:%@",result.bestTranscription.formattedString);
            self.detectedText = result.bestTranscription.formattedString;
            isFinal = !result.isFinal;
        }
        if (error) {
            [audioEngine stop];
            [inputNode removeTapOnBus:0];
            recognitionRequest = nil;
            recognitionTask = nil;
        }
    }];
    // Sets the recording format
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    // Starts the audio engine, i.e. it starts listening.
    [audioEngine prepare];
    [audioEngine startAndReturnError:&error];
    NSLog(@"Say Something, I'm listening");
}
- (void)restartListening {
    if (audioEngine.isRunning) {
        [audioEngine stop];
        [inputNode removeTapOnBus:0];
        [recognitionRequest endAudio];
        
        [self performSelector:@selector(startListening)
                   withObject:(self)
                   afterDelay:(0.4)];
    } else {
        [self startListening];
    }
}
#pragma mark - SFSpeechRecognizerDelegate Delegate Methods
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"Availability:%d",available);
}


- (void) showIndoorLocation {
    if (self.settingsViewController) {
        [self.settingsViewController showIndoorLocation];
    } else {
        IndoorLocationingViewController* ilvc = [[IndoorLocationingViewController alloc] init];
        UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:ilvc];
        nvc.navigationBarHidden = NO;
        nvc.navigationBar.translucent = NO;
        [self presentViewController:nvc animated:YES completion:nil];
    }
}

#pragma mark - DataManager Delegates

- (void) userNotRegisteredEvent
{
	if( [self.navigationController visibleViewController] == [self.navigationController.viewControllers objectAtIndex:0])
	{
		[[DataManager sharedDataManager] reloadFriends:NO];
		[self.navigationController pushViewController:self.alertyViewController animated:NO];
	}
	// if subscription user, check for valid subscription
    if( ![DataManager sharedDataManager].subscribing ) {
        [DataManager sharedDataManager].subscribing = TRUE;
        [self.alertyViewController displayLoginOrSubscribe];
    }
}

-(void) updateDataFinishedEvent
{
	connectionProblemCounter = 0;
	if( [self.navigationController visibleViewController] == [self.navigationController.viewControllers objectAtIndex:0])
	{
		[[DataManager sharedDataManager] reloadFriends:NO];
	}
	[self reloadFriendPhones];
	
	/*if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WizardFinished"]) {
		[self.alertyViewController displayLoginOrSubscribe];
	}*/
	[self.alertyViewController showNetworkError:NO];
	if (self.networkNotification) {
		[[UIApplication sharedApplication] cancelLocalNotification:self.networkNotification];
		self.networkNotification = nil;
	}
}

-(void) reloadFriendPhones
{
	[self.alertyViewController reloadFriends];
}

-(void) reloadCredits
{
	[self.alertyViewController viewWillAppear:NO];
	cmdlog
}

- (void) registrationErrorWithCodeEvent:(int)errorCode
{
	switch (errorCode) {
        case 0:
			[self showAlert:NSLocalizedString(@"Registration/Log in", @"") :NSLocalizedString(@"Please select another email address.", @"") :@"OK"];
			break;
		case 1:
			[self showAlert:NSLocalizedString(@"Registration/Log in", @"") :NSLocalizedString(@"Incorrect password.", @"") :@"OK"];
			break;
		case 2:
			[self showAlert:NSLocalizedString(@"Registration/Log in", @"") :NSLocalizedString(@"That email is not registered in our database. Please check your spelling or register a new account.", @"") :@"OK"];
			break;
		case 3:
			[self showAlert:NSLocalizedString(@"Registration/Log in", @"") :NSLocalizedString(@"Please select another user name.", @"") :@"OK"];
			break;
        case 4:
            [self showAlert:NSLocalizedString(@"Registration/Log in", @"") :NSLocalizedString(@"That ID is not registered in our database. Please check your spelling or ask the administrator for help.", @"") :@"OK"];
		default:
			break;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotifRegistrationFailed object:self userInfo:nil];
}

- (void) registrationSuccededEvent:(bool)settingsChanged {
	//[[AlertyAppDelegate sharedAppDelegate] registerNotifications];
	
	if ([AlertySettingsMgr isBusinessVersion]) {
		[self.alertyViewController removeAlertView];
	}
	
	[[DataManager sharedDataManager] reloadFriends:YES];

	[[NSNotificationCenter defaultCenter] postNotificationName:kNotifRegistrationSuccessful object:self userInfo:nil];
}

-(void) connectionErrorEvent {
	/*[AlertyAppDelegate showAlert:NSLocalizedString(@"Communication", @"")
								:NSLocalizedString(@"The application can not connect to server, please try again later.", @"") 
								:NSLocalizedString(@"OK", @"")
								:nil];*/
	if ([DataManager sharedDataManager].sos || [DataManager sharedDataManager].followMe) {
		connectionProblemCounter++;
		if (connectionProblemCounter > 10) {
			[self.alertyViewController showNetworkError:YES];
		}
		[self performSelector:@selector(startSync) withObject:nil afterDelay:5.0];
	} else {
		[self performSelector:@selector(startSync) withObject:nil afterDelay:60.0];
		[self.alertyViewController showNetworkError:YES];
		
		
	}
}

- (void) hideFunctions {
    [self.functionsViewController.view removeFromSuperview];
    self.functionsViewController = nil;
    [self.fakeTabBar selectTab:self.selectedIndex];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void) startSync {
	[[DataManager sharedDataManager] startSynchronization];
}

#pragma mark - ManDownViewDelegate

- (void) didFinishTimer {
	cmdlog
	
	[self.lockViewClosingView removeFromSuperview];
	self.lockViewClosingView = nil;
	
	
	// remove locker
	[self showLockView:NO activeText:nil];
	
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 10) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllDeliveredNotifications];
//        [center removeAllPendingNotificationRequests];
    }
    
	// start SOS mode
    [self.alertyViewController startSosMode:[NSNumber numberWithInt:self.manDownView.isTimer ? ALERT_SOURCE_TIMER : ALERT_SOURCE_MANDOWN] lock:nil];

    // remove man down timer
    [_manDownView removeFromSuperview];
    self.manDownView = nil;
    
    [self addTimer:nil];
}

- (void) didCancelTimer:(NSNumber*)isTimer {
    [self addTimer:nil];
    if (AlertySettingsMgr.usePIN) {
        self.lockViewClosingView = [LockViewClosingView lockViewClosingView];
        self.lockViewClosingView.delegate = self;
        self.lockViewClosingView.frame = self.view.frame;
        NSString* message = [isTimer boolValue] ? NSLocalizedString(@"Please enter PIN-code to cancel Timer alarm!", @"") :
            NSLocalizedString(@"Please enter PIN-code to cancel Man down!", @"");
        [self.lockViewClosingView.pincodeTitleLabel setText:message];
        [self.lockViewClosingView resetState];
        [self.view addSubview:self.lockViewClosingView];
    } else {
        [self didUnlockLocker];
    }
}

- (void) didCancelAlarm:(NSNumber*)isTimer {
    addAlarmVC* tvc = [[addAlarmVC alloc] initWithNibName:@"addAlarmVC" bundle:nil];

//    [tvc removeAlarm];
    if (AlertySettingsMgr.usePIN) {
        self.lockViewClosingView = [LockViewClosingView lockViewClosingView];
        self.lockViewClosingView.delegate = self;
        self.lockViewClosingView.frame = self.view.frame;
        NSString* message = [isTimer boolValue] ? NSLocalizedString(@"Please enter PIN-code to cancel Home alarm!", @"") :
            NSLocalizedString(@"Please enter PIN-code to cancel Alarm!", @"");
        [self.lockViewClosingView.pincodeTitleLabel setText:message];
        [self.lockViewClosingView resetState];
        [self.view addSubview:self.lockViewClosingView];
    } else {
        [self didUnlockLocker];
    }
}

#pragma mark - LockViewControllerDelegate

- (void) lockDidRequestPin:(LockView *)lockView {
}

- (void) lockDidUnlock:(LockView *)lockView {
    [self stopListening];
	// remove locker
	[self showLockView:NO activeText:nil];
}

- (void) lockDidLongPressLock:(LockView *)lockView {
    [self stopListening];
	// remove locker
	[self showLockView:NO activeText:nil];
	
	// start sos mode
    [self.alertyViewController startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_BUTTON]lock:YES];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return( [viewController isKindOfClass:[UINavigationController class]] );
}

#pragma mark - AlertyTabBarDelegate

- (void) didPressHomeButton:(AlertyTabBar*)tabBar {
    [self.functionsViewController.view removeFromSuperview];
    self.functionsViewController = nil;
    [self.settingsViewController.view removeFromSuperview];
    self.settingsViewController = nil;
    self.selectedIndex = 0;
}

- (void) didPressContactsButton:(AlertyTabBar*)tabBar {
    self.contactsViewController.navigationController.navigationBarHidden = NO;
    [self.functionsViewController.view removeFromSuperview];
    self.functionsViewController = nil;
    [self.settingsViewController.view removeFromSuperview];
    self.settingsViewController = nil;
    self.selectedIndex = 1;
}

- (void)didPressFunctionsButton:(AlertyTabBar *)tabBar {
    [self.functionsViewController.view removeFromSuperview];
    self.functionsViewController = nil;
    [self.settingsViewController.view removeFromSuperview];
    self.settingsViewController = nil;
    FunctionsViewController* fvc = [[FunctionsViewController alloc] initWithNibName:@"FunctionsViewController" bundle:nil];
    self.selectedIndex = 0;
    fvc.view.frame = self.alertyViewController.view.frame;
    [self.alertyViewController.view addSubview:fvc.view];
    self.functionsViewController = fvc;
}

- (void) didPressSettingsButton:(AlertyTabBar*)tabBar {
    [self.functionsViewController.view removeFromSuperview];
    self.functionsViewController = nil;
    [self.settingsViewController.view removeFromSuperview];
    self.settingsViewController = nil;
    SettingsViewController* svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    if (self.selectedIndex == 0) {
        svc.view.frame = self.alertyViewController.view.frame;
        [self.alertyViewController.view addSubview:svc.view];
    } else {
        self.contactsViewController.navigationController.navigationBarHidden = YES;
        CGSize size = self.contactsViewController.view.frame.size;
        svc.view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
        [self.contactsViewController.view addSubview:svc.view];
    }
    self.settingsViewController = svc;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    
    /*UINavigationBar.appearance.barTintColor = COLOR_NAVIGATIONBAR;
    UINavigationBar.appearance.titleTextAttributes = @{ NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0]};
     UINavigationBar.appearance.tintColor = UIColor.whiteColor;
     UITextField.appearance.defaultTextAttributes = @{ NSForegroundColorAttributeName: UIColor.whiteColor};
     
     [UITextField appearanceWhenContainedInInstancesOfClasses:@[UISearchBar.class]].defaultTextAttributes = @{ NSForegroundColorAttributeName: UIColor.whiteColor};*/
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 99) {
		if (buttonIndex == 1) {
			[AlertyAppDelegate sharedAppDelegate].showUserSettings = YES;
			[self didPressSettingsButton:nil];
		}
		return;
	}
	
	switch( buttonIndex )
	{
		case 0: // enable auto-lock
			[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
			
			// we must disable man down and preactivation as well
			[[AlertyAppDelegate sharedAppDelegate] stopManDown];
			
			[AlertySettingsMgr setManDownManager:NO];
			[AlertySettingsMgr setPreactivation:NO];
			break;
		case 1: // disable auto-lock
			[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
			break;
	}
}

#pragma mark - LockViewControllerDelegate

- (void) didUnlockLocker {
	[self.lockViewClosingView removeFromSuperview];
	self.lockViewClosingView = nil;
    
    /*if (self.manDownView.isTimer) {
        [AlertySettingsMgr setTimer:nil];
        [self.alertyViewController updateTimer];
    }*/

    // stop remove man down timer
    [_manDownView stopCountDown];
    [_manDownView removeFromSuperview];
    self.manDownView = nil;
}

- (void) didCancelLockView {
	[self.lockViewClosingView removeFromSuperview];
	self.lockViewClosingView = nil;
}

- (void) closeManDown {
    [self.manDownView stopCountDown];
    [self.manDownView removeFromSuperview];
    self.manDownView = nil;
}

- (void) showAlert:(NSString*)caption :(NSString*)message :(NSString *)cancelButton {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:caption message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButton) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleCancel handler:nil]];
    }
   
    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;

    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}
//
//- (UIViewController *)topViewController{
//  return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//}
//
//- (UIViewController *)topViewController:(UIViewController *)rootViewController
//{
//  if (rootViewController.presentedViewController == nil) {
//    UINavigationController *navigationController =
//    (UINavigationController *)rootViewController;
//    return [[navigationController viewControllers] lastObject];
//  }
//
//  if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
//    UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
//    UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
//    return [self topViewController:lastViewController];
//  }
//
//  UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
//  return [self topViewController:presentedViewController];
//}

@end

