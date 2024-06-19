#import "AlertyViewController.h"
#import "AlertyAppDelegate.h"
#import "DataManager.h"
#import "config.h"
#import "URLFetcher.h"
#import "NSExtensions.h"
#import "AlertView.h"
#import "WifiApMgr.h"
#import "TargetConditionals.h"
#import "AlertyDBMgr.h"
#import "AlertySettingsMgr.h"
#import "SettingsViewController.h"
#import "ReachabilityManager.h"
#import "StartViewController.h"
#import "TutorialViewController.h"
#import "IndoorLocationingViewController.h"
#import "MobileInterface.h"
#import <Alerty-Swift.h>
@import UserNotifications;

@interface AlertyViewController() <BannerTableViewDelegate, LockViewClosingViewDelegate, URLShortenerDelegate, UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate, LockViewDelegate, MFMessageComposeViewControllerDelegate, AlertManagerPresenter>

@property (nonatomic, strong) MFMessageComposeViewController *messageComposeViewController;
@property (nonatomic, strong) MFMessageComposeViewController *sosComposeViewController;

@property (nonatomic, strong) NSDate *lastTimePressed;
@property (nonatomic, strong) UIView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextView *alertyWarningTextView;
@property (strong, nonatomic) IBOutlet UIView *extraFeaturesView;
@property (strong, nonatomic) LockViewClosingView* lockViewClosingView;
@property (strong, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (strong, nonatomic) IBOutlet UIView *networkErrorView;

@property (nonatomic, strong) IsGdURLShortener *urlShortener;
@property (nonatomic, strong) IBOutlet UIImageView *soundIcon;

- (void) sendFollowMeInvitationMessage:(NSString *)inviteURL;
- (void) cancelAlertMode;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pressedViewHeight;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (assign, nonatomic) BOOL redButtonPressed;
@property (weak, nonatomic) IBOutlet BannerTableView *bannerTableView;

@property (strong, nonatomic) NSMutableArray* banners;
@property (strong, nonatomic) NSString* alarmBannerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *figureTextDistanceConstraint;
@property (weak, nonatomic) IBOutlet UIView *redLayer;

@property (assign, nonatomic) NSInteger repeatNr;
@property (assign, nonatomic) BOOL isPinDefinition;
@property (assign, nonatomic) BOOL followMeAccepted;
@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, strong) NSString* followingId;
@property (nonatomic, strong) NSString* followingName;
@property (nonatomic, strong) NSTimer* followMeTimer;

@end

@implementation AlertyViewController

#pragma mark - Overrides

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.bannerTableView.bannerDelegate = self;
	
    self.isPinDefinition = NO;
	
	self.navigationController.delegate = self;
    
#if defined(ALERTY)
    //self.buttonView.backgroundColor = REDESIGN_COLOR_BLACK;
    self.redLayer.backgroundColor = REDESIGN_COLOR_RED;

#elif defined(OPUS)
    self.buttonView.backgroundColor = COLOR_ACCENT;
#elif  defined(SAKERHETSAPPEN)
    self.buttonView.backgroundColor = COLOR_GREEN;
    self.redLayer.backgroundColor = COLOR_ACCENT;
#endif
    
	self.lastTimePressed = [NSDate date];
	_repeatNr = 0;
	[DataManager sharedDataManager].underSosMode = NO;
    
    if ([UIScreen mainScreen].bounds.size.height == 480.0) {
        self.figureTextDistanceConstraint.constant = 30;
    }

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(followMeFollowing:)
                                               name:kFollowMeFollowingNotification object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(followMeAccepted:)
												 name:kFollowMeAcceptedNotification object:nil];
    
    self.banners = [NSMutableArray array];
    [self.bannerTableView registerNib:[UINib nibWithNibName:@"BannerCell" bundle:nil] forCellReuseIdentifier:@"BannerCell"];
    
    if ([AlertySettingsMgr isBusinessVersion] && [AlertySettingsMgr userName].length) {
        [AlertySettingsMgr setLastUserID:[AlertySettingsMgr userName]];
    }
    if ([AlertySettingsMgr isBusinessVersion] && AlertySettingsMgr.userPIN.length) {
        [AlertySettingsMgr setLastAuthCode:AlertySettingsMgr.userPIN];
    }
    
	/*UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
	[swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self.view addGestureRecognizer:swipeLeft];*/
	
	if ([AlertySettingsMgr sosMode] > 0) {
        [self startSosMode:nil lock:nil];
	}
    
    /*self.soundIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sound_off_icon"]];
    self.soundIcon.frame = CGRectMake(5, [[UIScreen mainScreen] bounds].size.height - 120, 35, 35);
    [self.view addSubview:self.soundIcon];*/
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[[DataManager sharedDataManager] getUserSettings];
	
	//[[AlertyAppDelegate sharedAppDelegate] startSignificantLocationService];
    
    self.extraFeaturesView.hidden = ![AlertySettingsMgr isBusinessVersion];
	
	BOOL canSendAlert = [AlertyViewController canSendAlert];
	self.redButton.userInteractionEnabled = canSendAlert;
    
    [self updateManDown];
    [self updateTimer];
    [self updateHomeTimer];

    /*if ([AlertySettingsMgr userID] != 0) {
        if (![AlertySettingsMgr tutorialShown]) {
            [AlertySettingsMgr setTutorialShown:YES];
            self.mainView.alpha = 0.10;
            
            TutorialViewController* tvc = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
            tvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            __weak TutorialViewController* weakTvc = tvc;
            tvc.completion = ^{
                [weakTvc dismissControllerAnimated:YES completion:nil];
                self.mainView.alpha = 1.0;

            };
            [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:tvc animated:YES completion:nil];
        }else{
            self.mainView.alpha = 1.0;
        }
    }*/

    [AlertySettingsMgr discreteModeEnabled] ? (self.soundIcon.alpha = 1.0) : (self.soundIcon.alpha = 0.0);

}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	//[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	//[self resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (![DataManager sharedDataManager].underSosMode) {
        //[self performSelector:@selector(enableHeadsetForEmergency) withObject:nil afterDelay:1.0];
		[self enableHeadsetForEmergency];
    }

}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
	cmdlogtext(@"receivedEvent.type : %d", receivedEvent.type);
	cmdlogtext(@"receivedEvent.subtype : %d", receivedEvent.subtype);
    if (receivedEvent.type == UIEventTypeRemoteControl && ![DataManager sharedDataManager].underSosMode) {
		NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:self.lastTimePressed];
		self.lastTimePressed = [NSDate date];
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
			case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlBeginSeekingForward:
				if (diff < 2.1) {
					_repeatNr = _repeatNr + 1;
				}
				else
				{
					_repeatNr = 0;
				}
				if (_repeatNr > 0 )
				{
                    if (self.redButton.userInteractionEnabled) {
						cmdlogtext(@"starting sos mode");
                        [self startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_EXTERNAL_BUTTON] lock:nil];
                    }
				}
                break;
            default:
                break;
        }
    }
}

#pragma mark - Private methods

- (void) removeAlertView
{
	for (UIView *v in self.view.subviews) {
		if ([v isKindOfClass:[AlertView class]]) {
			[v removeFromSuperview];
		}
	}
}

- (void) enableHeadsetForEmergency
{
	/*if ([[DataManager sharedDataManager] enableHeadset]) {
		NSError *setCategoryErr = nil;
		NSError *activationErr  = nil;
		
		[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
		[[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
		[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
		[self becomeFirstResponder];
	}
	else {
		NSError *activationErr  = nil;
		[[AVAudioSession sharedInstance] setActive:NO error: &activationErr];
		[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
		[self resignFirstResponder];
	}*/
}

- (void) sendFollowMeInvitationMessage:(NSString *)inviteURL {
	if ([MFMessageComposeViewController canSendText]) {
		// Show the composer
		NSString *message = NSLocalizedString(@"FOLLOW_ME_MESSAGE", @"FOLLOW_ME_MESSAGE");
		NSString *mailBody = [NSString stringWithFormat:@"%@ %@", message, inviteURL];
		
		if( !self.messageComposeViewController ) {
			self.messageComposeViewController = [[MFMessageComposeViewController alloc] init];
		}
		
		self.messageComposeViewController.messageComposeDelegate = self;
		[self.messageComposeViewController setBody:mailBody];
		
		if( self.messageComposeViewController ) {
			[self presentViewController:self.messageComposeViewController animated:YES completion:nil];
		}
	} else {
        [self startFollowMeMode:nil recipient:nil];
	}
}

- (void) displayRegistrationView {
    if (self.isPinDefinition) return;
    self.isPinDefinition = YES;
	StartViewController *svc = [[StartViewController alloc] initWithNibName:@"StartViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:svc];
    navController.navigationBarHidden = YES;
    navController.navigationBar.opaque = YES;
    navController.navigationBar.translucent = NO;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentViewController:navController animated:YES completion:nil];
}

- (void) displayLoginOrSubscribe
{
//	_subscribeOrLoginAlert = [[UIAlertView alloc] initWithTitle:@""
//														message:NSLocalizedString(@"Login or buy a subscription?", @"Login or buy a subscription?")
//													   delegate:self
//											  cancelButtonTitle:NSLocalizedString(@"Login", @"Login")
//											  otherButtonTitles:NSLocalizedString(@"Subscribe", @"Subscribe"), nil];
//	[_subscribeOrLoginAlert show];
	
	[self displayRegistrationView];
}

#pragma mark - SOS / FollowMe

- (void) startFollowMeMode:(NSString*) phoneNumber recipient:(NSString*)recipient {

	// + TODO open message with link to follow-map. when mail editor returns DO :
	[DataManager sharedDataManager].followMe = YES;
	
	// show cancellation button
    [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMe visible:YES title:recipient];
    
	// start locationing
	[[AlertyAppDelegate sharedAppDelegate] startUpdatingLocation];
	
	// prevent from old, unclosed follow me events
	_followMeAccepted = YES;
	
	// setup datamanager
	[DataManager sharedDataManager].sos = NO;
	[DataManager sharedDataManager].newRoute = YES;
	NSLog(@"START SOS --------------------");
	[[DataManager sharedDataManager] startSynchronization];
	
    if (phoneNumber) {
        NSDictionary* params = @{ @"userid": [NSNumber numberWithInteger:[AlertySettingsMgr userID]], @"lang": [AlertyAppDelegate language], @"p": phoneNumber};
        [MobileInterface post:START_FOLLOW_ME_URL body:params completion:^(NSDictionary *result, NSString *errorMessage) {
            NSLog(@"follow me: %@", result);
            self.followMeAccepted = NO;
        }];
    } else {
        NSDictionary* params = @{ @"userid": [NSNumber numberWithInteger:[AlertySettingsMgr userID]], @"lang": [AlertyAppDelegate language]};
        [MobileInterface post:START_FOLLOW_ME_URL_ORIG body:params completion:^(NSDictionary *result, NSString *errorMessage) {
            NSLog(@"follow me: %@", result);
            self.followMeAccepted = NO;
        }];
    }
}

- (void) startSosMode:(NSNumber*)source lock:(BOOL)lock
{
	if (![AlertyViewController canSendAlert]) return;
	
    [self updateTimer];
    
    if (![AlertySettingsMgr discreteModeEnabled]) AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	self.redButton.userInteractionEnabled = NO;
	
	if ([DataManager sharedDataManager].followMe) {
		[self cancelAlertMode];
		[DataManager sharedDataManager].followMe = NO;
        NSDictionary* params = @{ @"userid": [NSNumber numberWithInteger:AlertySettingsMgr.userID], @"lang": NSLocalizedString(@"LANGUAGE", @"")};
        [MobileInterface postForString:STOP_FOLLOW_ME_URL body:params completion:^(NSString *result, NSString *errorMessage) {
        }];
	}
	
	if (![AlertySettingsMgr isBusinessVersion]) {
		NSArray *friends = [[AlertyDBMgr sharedAlertyDBMgr] getAllContacts];
		
		if ([friends count] == 0) {
			[AlertyAppDelegate showLocalNotification:NSLocalizedString(@"There was no friend to send alert to, the alert was stopped.", @"") action:NSLocalizedString(@"OK", @"OK") userInfo:nil];
			self.redButton.userInteractionEnabled = YES;
			return;
		}
	}
	
	[DataManager sharedDataManager].underSosMode = YES;

	// hide lockview on main controller if one showing
	[[AlertyAppDelegate sharedAppDelegate].mainController showLockView:NO activeText:nil];
	
	[DataManager sharedDataManager].sos = YES;
    [DataManager sharedDataManager].voice = nil;
    [DataManager sharedDataManager].voicePhone = nil;

	self.lockView = [LockView lockView];
    self.lockView.accessibilityViewIsModal = YES;
	_lockView.delegate = self;
	_lockView.frame = [AlertyAppDelegate sharedAppDelegate].mainController.view.frame;
	_lockView.viewToast.alpha = 0.0;
    _lockView.backgroundColor = [UIColor blackColor];
	if (lock || [AlertySettingsMgr discreteModeEnabled]) {
        //Add red point
        UIView *redDot = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 5, 5)];
        redDot.backgroundColor = [UIColor redColor];
        [_lockView addSubview: redDot];
		_lockView.activeView.hidden = YES;
        _lockView.bgView.hidden = YES;
	}
	[[AlertyAppDelegate sharedAppDelegate].mainController.view addSubview:self.lockView];

    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
    
	[self.lockView startAnimation];
	
	[[AlertyAppDelegate sharedAppDelegate] startUpdatingLocation];
	
	[DataManager sharedDataManager].alertId = [AlertySettingsMgr sosMode];
	[DataManager sharedDataManager].newRoute = YES;
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	NSLog(@"START SOS --------------------");
	[[DataManager sharedDataManager] startSynchronization];
	if ([DataManager sharedDataManager].alertId <= 0) {
        [[DataManager sharedDataManager] sendPhoneNumbers:[source intValue]];
	}
	
	/*if([AlertySettingsMgr hasFacebook])
	{
		CLLocationCoordinate2D _coord = [[DataManager sharedDataManager] currentLocation];
		NSString *lat = [[NSString stringWithFormat:@"%f", _coord.latitude] stringByReplacingOccurrencesOfString:@"," withString:@"."];
		NSString *lng = [[NSString stringWithFormat:@"%f", _coord.longitude] stringByReplacingOccurrencesOfString:@"," withString:@"."];
		NSString *lang = [AlertyAppDelegate language];
		NSString *homeUrl = [lang isEqualToString:@"sv"] ? HOME_URL_SE : HOME_URL;
		NSString *imageUrl = [NSString stringWithFormat:STAT_MAP_URL, lat, lng];
		NSString *linkUrl = [NSString stringWithFormat:@"%@/map.php?id=%i", homeUrl, [AlertySettingsMgr userID]];
		NSString *message = NSLocalizedString(@"<name> is in an emergency situation. Click on the link to see where I am.", @"");
		message = [message stringByReplacingOccurrencesOfString:@"<name>" withString:[[DataManager sharedDataManager] userName]];
		[[FacebookMgr sharedFacebookMgr] sendStatusUpdate:message imageUrl:imageUrl linkUrl:linkUrl];
	}*/
    
    //NSString *phone = @"tel://0036703890849";
    //BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
	
	BOOL network = [ReachabilityManager checkNetwork];
	if (!network && ![DataManager sharedDataManager].followMe) {
		if ([MFMessageComposeViewController canSendText]) {

			NSString *userName = nil;
			if ([AlertySettingsMgr isBusinessVersion]) {
				userName = [AlertySettingsMgr userNameServer];
			}
			else {
				userName = [AlertySettingsMgr userFullName];
			}
			
			CLLocationCoordinate2D lastLoc = [[DataManager sharedDataManager] currentLocation];
			/*NSString *lat = [[NSString stringWithFormat:@"%f", _coord.latitude] stringByReplacingOccurrencesOfString:@"," withString:@"."];
			NSString *lng = [[NSString stringWithFormat:@"%f", _coord.longitude] stringByReplacingOccurrencesOfString:@"," withString:@"."];
			NSString *lang = [AlertyAppDelegate language];
			NSString *homeUrl = [lang isEqualToString:@"sv"] ? HOME_URL_SE : HOME_URL;
			NSString *imageUrl = [NSString stringWithFormat:STAT_MAP_URL, lat, lng];
			NSString *linkUrl = [NSString stringWithFormat:@"%@/map.php?id=%i", homeUrl, [AlertySettingsMgr userID]];*/
			NSString *message = NSLocalizedString(@"<name> is in an emergency situation. Click on the link to see where I am. <URL>", @"");
			
			NSString* latitude = [NSString stringWithFormat:@"%.6f", lastLoc.latitude];
			latitude = [latitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
			NSString* longitude = [NSString stringWithFormat:@"%.6f", lastLoc.longitude];
			longitude = [longitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
			NSString* url = [NSString stringWithFormat:@"getalerty.com/map.php?lat=%@&lng=%@&l=%@", latitude, longitude, [AlertyAppDelegate language]];
			message = [message stringByReplacingOccurrencesOfString:@"<URL>" withString:url];
			message = [message stringByReplacingOccurrencesOfString:@"<name>" withString:userName];
			message = [message stringByReplacingOccurrencesOfString:@"<latitude>" withString:latitude];
			message = [message stringByReplacingOccurrencesOfString:@"<longitude>" withString:longitude];

			if( !self.sosComposeViewController ) {
				self.sosComposeViewController = [[MFMessageComposeViewController alloc] init];
			}
			
			self.sosComposeViewController.messageComposeDelegate = self;
			[self.sosComposeViewController setBody:message];
			
			NSMutableArray* recipients = [NSMutableArray arrayWithCapacity:2];
			NSArray* friends = [DataManager sharedDataManager].friendsToNotify;
			for (int i=0; i<friends.count; i++) {
				Contact* c = [friends objectAtIndex:i];
				[recipients addObject:c.phone];
			}
			if ([AlertySettingsMgr isBusinessVersion]) {
				[recipients addObject:@"+46769438688"];
			}
			[self.sosComposeViewController setRecipients:recipients];
			
			if( self.sosComposeViewController ) {
				[self presentController:self.sosComposeViewController animated:YES completion:nil];
			}
		} else {
            [self startFollowMeMode:nil recipient:nil];
		}
	}
}

#pragma mark - Public methods

- (void) getInviteURLShortened {
	NSString *inviteURL = [NSString stringWithFormat:FOLLOW_ME_INVITE_URL, (long)[AlertySettingsMgr userID], [AlertyAppDelegate language]];
	[self.activityIndicator startAnimating];
	self.urlShortener = [[IsGdURLShortener alloc] initWithDelegate:self];
	[self.urlShortener createURL:inviteURL];
}

+ (BOOL) canSendAlert {
	AlertyAlertState state = [AlertyViewController alertyAlertState];
	if ([AlertySettingsMgr isBusinessVersion]) {
		// can send always, except if no pincode
		return state == AlertyAlertStateNoPincode ? NO : YES;
	}
	else {
		switch (state) {
			case AlertyAlertStateNoContacts:
			case AlertyAlertStateNoPincode:
			case AlertyAlertStateCannotSendAlert:
				return NO;
			case AlertyAlertStateCanSendAlert:
				return YES;
			default:
				return NO;
		}
	}
}

+ (AlertyAlertState) alertyAlertState
{
	/*NSString *pincode = [[DataManager sharedDataManager] pincode];
	BOOL hasPincode = pincode != nil && [pincode length] > 0;
	BOOL hasContacts = [[AlertyDBMgr sharedAlertyDBMgr] countAllContacts] > 0;
	
	if (hasPincode) {*/
		return AlertyAlertStateCanSendAlert;
	/*}
	else if (!hasPincode) {
		return AlertyAlertStateNoPincode;
	}
	else if (!hasContacts) {
		return AlertyAlertStateNoContacts;
	}
	else {
		return AlertyAlertStateCannotSendAlert;
	}*/
}

#pragma mark - IBActions

- (IBAction) wifiBtnPressed:(id)sender {
    IndoorLocationingViewController* ilvc = [[IndoorLocationingViewController alloc] init];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:ilvc];
    nvc.navigationBarHidden = NO;
    nvc.navigationBar.translucent = NO;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
}

- (void) cancelAlertMode {
	if ([DataManager sharedDataManager].sos) {
		[[DataManager sharedDataManager] stopSOSMode];
		
		BOOL network = [ReachabilityManager checkNetwork];
		if (!network) {
			if ([MFMessageComposeViewController canSendText]) {
				NSString *userName = nil;
				if ([AlertySettingsMgr isBusinessVersion]) {
					userName = [AlertySettingsMgr userNameServer];
				}
				else {
					userName = [AlertySettingsMgr userFullName];
				}
				
				CLLocationCoordinate2D lastLoc = [[DataManager sharedDataManager] currentLocation];
				NSString *message = NSLocalizedString(@"<name> has canceled the alert. Find the location here", @"");
				
				NSString* latitude = [NSString stringWithFormat:@"%.6f", lastLoc.latitude];
				latitude = [latitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
				NSString* longitude = [NSString stringWithFormat:@"%.6f", lastLoc.longitude];
				longitude = [longitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
				NSString* url = [NSString stringWithFormat:@"getalerty.com/map.php?lat=%@&lng=%@&l=%@", latitude, longitude, [AlertyAppDelegate language]];
				message = [message stringByReplacingOccurrencesOfString:@"<URL>" withString:url];
				message = [message stringByReplacingOccurrencesOfString:@"<name>" withString:userName];
				message = [message stringByReplacingOccurrencesOfString:@"<latitude>" withString:latitude];
				message = [message stringByReplacingOccurrencesOfString:@"<longitude>" withString:longitude];
				
				if( !self.sosComposeViewController ) {
					self.sosComposeViewController = [[MFMessageComposeViewController alloc] init];
				}
				
				self.sosComposeViewController.messageComposeDelegate = self;
				[self.sosComposeViewController setBody:message];
				
				NSMutableArray* recipients = [NSMutableArray arrayWithCapacity:2];
				NSArray* friends = [DataManager sharedDataManager].friendsToNotify;
				for (int i=0; i<friends.count; i++) {
					Contact* c = [friends objectAtIndex:i];
					[recipients addObject:c.phone];
				}
				if ([AlertySettingsMgr isBusinessVersion]) {
					[recipients addObject:@"+46769438688"];
				}
				[self.sosComposeViewController setRecipients:recipients];
				[self presentController:self.sosComposeViewController animated:YES completion:nil];
			}
		}
	}
	[DataManager sharedDataManager].sos = NO;
	[DataManager sharedDataManager].underSosMode = NO;
	[AlertySettingsMgr setSosMode:-1];
    
    AlertySettingsMgr.timerAddress = nil;
    AlertySettingsMgr.timerMessage = nil;
    AlertySettingsMgr.timerLatitude = nil;
    AlertySettingsMgr.timerLongitude = nil;
    [self.bannerTableView closeTimer];
    
	[UIApplication sharedApplication].idleTimerDisabled = NO;
	
	self.redButton.userInteractionEnabled = YES;
	
	[self.lockView removeFromSuperview];
	
	[[AlertyAppDelegate sharedAppDelegate] startSignificantLocationService];
	
	NSLog(@"STOP SOS --------------------");
	[[DataManager sharedDataManager] startSynchronization];
	
	if (![AlertySettingsMgr isBusinessVersion]) {
        [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMe visible:NO title:nil];
        [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeAccepted visible:NO title: nil];
	}
}

- (void) cancelHomeAlertMode {
    if ([DataManager sharedDataManager].sos) {
        [[DataManager sharedDataManager] stopSOSMode];
        
        BOOL network = [ReachabilityManager checkNetwork];
        if (!network) {
            if ([MFMessageComposeViewController canSendText]) {
                NSString *userName = nil;
                if ([AlertySettingsMgr isBusinessVersion]) {
                    userName = [AlertySettingsMgr userNameServer];
                }
                else {
                    userName = [AlertySettingsMgr userFullName];
                }
                
                CLLocationCoordinate2D lastLoc = [[DataManager sharedDataManager] currentLocation];
                NSString *message = NSLocalizedString(@"<name> has canceled the alert. Find the location here", @"");
                
                NSString* latitude = [NSString stringWithFormat:@"%.6f", lastLoc.latitude];
                latitude = [latitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
                NSString* longitude = [NSString stringWithFormat:@"%.6f", lastLoc.longitude];
                longitude = [longitude stringByReplacingOccurrencesOfString:@"," withString:@"."];
                NSString* url = [NSString stringWithFormat:@"getalerty.com/map.php?lat=%@&lng=%@&l=%@", latitude, longitude, [AlertyAppDelegate language]];
                message = [message stringByReplacingOccurrencesOfString:@"<URL>" withString:url];
                message = [message stringByReplacingOccurrencesOfString:@"<name>" withString:userName];
                message = [message stringByReplacingOccurrencesOfString:@"<latitude>" withString:latitude];
                message = [message stringByReplacingOccurrencesOfString:@"<longitude>" withString:longitude];
                
                if( !self.sosComposeViewController ) {
                    self.sosComposeViewController = [[MFMessageComposeViewController alloc] init];
                }
                
                self.sosComposeViewController.messageComposeDelegate = self;
                [self.sosComposeViewController setBody:message];
                
                NSMutableArray* recipients = [NSMutableArray arrayWithCapacity:2];
                NSArray* friends = [DataManager sharedDataManager].friendsToNotify;
                for (int i=0; i<friends.count; i++) {
                    Contact* c = [friends objectAtIndex:i];
                    [recipients addObject:c.phone];
                }
                if ([AlertySettingsMgr isBusinessVersion]) {
                    [recipients addObject:@"+46769438688"];
                }
                [self.sosComposeViewController setRecipients:recipients];
                [self presentController:self.sosComposeViewController animated:YES completion:nil];
            }
        }
    }
    [DataManager sharedDataManager].sos = NO;
    [DataManager sharedDataManager].underSosMode = NO;
    [AlertySettingsMgr setSosMode:-1];
    
    [AlertySettingsMgr sethomeTimerMessage: nil];
    [self.bannerTableView closeHomeTimer];
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    self.redButton.userInteractionEnabled = YES;
    
    [self.lockView removeFromSuperview];
    
    [[AlertyAppDelegate sharedAppDelegate] startSignificantLocationService];
    
    NSLog(@"STOP SOS --------------------");
    [[DataManager sharedDataManager] startSynchronization];
    
    if (![AlertySettingsMgr isBusinessVersion]) {
        [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMe visible:NO title:nil];
        [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeAccepted visible:NO title: nil];
    }
}

- (void) reloadFriends {
	if ([AlertySettingsMgr isBusinessVersion]) {
		NSString *pincode = [AlertySettingsMgr userPIN];
        // if user is identified as regular business user, we check if they have a pincode set
        if (pincode == nil) {
            if( ![DataManager sharedDataManager].subscribing ) {
                [DataManager sharedDataManager].subscribing = TRUE;
                [self displayLoginOrSubscribe];
            }
        }
    }
	else {
		BOOL canSendAlert = [AlertyViewController canSendAlert];
		self.redButton.userInteractionEnabled = canSendAlert;
	}
    if (self.followingId.length) {
        [self startFollowMeReceivedCheck:NO];
    }
}

#pragma mark - NSNotification handlers

- (void) followMeAccepted:(NSNotification*)notification {
	cmdlog
	if (!_followMeAccepted) {
		_followMeAccepted = YES;
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMe visible:NO title:nil];
        [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeAccepted visible:YES title:notification.userInfo[@"follower"]];
    }
}

- (void) followMeFollowing:(NSNotification*)notification {
    self.followingName = notification.userInfo[@"following"];
    self.followingId = notification.userInfo[@"user"];
    [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeReceived visible:YES title:self.followingName];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	if( result == MFMailComposeResultSent ) {
		cmdlogtext(@"It's away!");
	}
	[self dismissControllerAnimated:YES];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	if( controller == self.messageComposeViewController ) {
		if (controller && result == MessageComposeResultSent) {
            [self startFollowMeMode:nil recipient:nil];
		}
		[self dismissControllerAnimated:YES];
		self.messageComposeViewController = nil;
	}
	if( controller == self.sosComposeViewController ) {
		[self dismissControllerAnimated:YES];
		self.sosComposeViewController = nil;
	}
}

#pragma mark - URLShortenerDelegate

- (void) didReceiveShortURL:(NSString *)shortURL
{
	cmdlog
	[self.activityIndicator stopAnimating];
	self.urlShortener = nil;
	[self sendFollowMeInvitationMessage:shortURL];
}

- (void) didFailToReceiveURL
{
	cmdlog
	[self.activityIndicator stopAnimating];
	self.urlShortener = nil;
}

#pragma mark - LockViewDelegate

- (void) lockDidRequestPin:(LockView *)lockView {
	self.redButton.userInteractionEnabled = YES;
}

- (void) lockDidUnlock:(LockView *)lockView {
	[self cancelAlertMode];
}

#pragma mark - UnlockViewDelegate

- (void) didUnlockLocker {
    [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMe visible:NO title:nil];
    [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeAccepted visible:NO title:nil];

    [DataManager sharedDataManager].followMe = NO;
    [self cancelAlertMode];
    [self.lockViewClosingView removeFromSuperview];
    self.lockViewClosingView = nil;
    
    NSDictionary* params = @{ @"userid": [NSNumber numberWithInteger:AlertySettingsMgr.userID], @"lang": NSLocalizedString(@"LANGUAGE", @"")};
    [MobileInterface postForString:STOP_FOLLOW_ME_URL body:params completion:^(NSString *result, NSString *errorMessage) {
    }];
}

- (void) didCancelLockView {
}

- (void) startRecording {
	[self enableHeadsetForEmergency];
}

- (void) showNetworkError:(BOOL)show {
	if (self.networkErrorView.hidden == !show) return;
	self.networkErrorView.hidden = !show;
	if (show) {
		[[AlertyAppDelegate sharedAppDelegate].window addSubview:self.networkErrorView];
		CGRect frame = self.networkErrorView.frame;
		frame.origin.y = 20;
		self.networkErrorView.frame = frame;
		BOOL network = [ReachabilityManager checkNetwork];
		NSString* message = network ? NSLocalizedString(@"Cannot connect to server.\nRetrying" , @"") : NSLocalizedString(@"No data connection enabled.\nCheck the settings." , @"");
		[self.networkErrorLabel setText:message];
		[self performSelector:@selector(animate) withObject:nil afterDelay:4.0];
	}
}

- (void) animate {
	if (self.networkErrorView.hidden) return;
	CGRect frame = self.networkErrorLabel.frame;
	if (frame.origin.y == 0) {
		frame.origin.y = -40;
	} else if (frame.origin.y == -40) {
		frame.origin.y = -80;
	} else {
		frame.origin.y = 0;
	}
	[UIView animateWithDuration:0.4
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.networkErrorLabel.frame = frame;
					 }
					 completion:^(BOOL finished){
						 [self performSelector:@selector(animate) withObject:nil afterDelay:4.0];
					 }];
}

- (IBAction)redButtonTouched:(id)sender {
    if (self.redButtonPressed) return;
    
    if (![AlertyViewController canSendAlert]) {
        [self displayRegistrationView];
        return;
    }
    
    self.pressedViewHeight.constant = self.view.frame.size.height;
    self.redButtonPressed = YES;
    [UIView animateWithDuration:3.0
                     animations:^{
                                    [self.view layoutIfNeeded];
                                }
                     completion:^(BOOL finished) {
                                self.redButtonPressed = NO;
                                CGFloat y = ((UIView*)self.pressedViewHeight.firstItem).frame.origin.y;
                                if (y == 0 && finished) {
                                    [self startSosMode:[NSNumber numberWithInt:ALERT_SOURCE_BUTTON] lock:nil];
                                    [self redButtonReleased:sender];
                                }
    }];
}

- (IBAction)redButtonReleased:(id)sender {
    //[((UIView*)self.pressedViewHeight.firstItem).layer removeAllAnimations];
    //self.redButtonPressed = NO;
    self.pressedViewHeight.constant = 0.0;
    [UIView animateWithDuration:3.0
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
/*    [UIView animateWithDuration:3.0
        delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
        
    }];*/
}

- (void) updateManDown {
    [self.bannerTableView setBannerVisibleWithType:BannerTypeMandown visible:AlertySettingsMgr.hasManDownMgr title:nil];
}

- (void) updateTimer {
    [self.bannerTableView updateTimer];
}
- (void) updateHomeTimer {
    [self.bannerTableView updateHomeTimer];
}



#pragma mark BannerTableViewDelegate

- (void) showFollowing {
    FollowMeViewController* followMeViewController = [[FollowMeViewController alloc] initWithNibName:@"FollowMeViewController" bundle:nil];
    followMeViewController.userId = self.followingId;
    followMeViewController.title = [NSLocalizedString(@"FOLLOW_ME_FOLLOWER", @"") stringByAppendingString:(self.followingName ? self.followingName : @"")];;
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:followMeViewController];
    nc.navigationBarHidden = NO;
    [self presentViewControllerOnTop:nc];
}

- (void) presentViewControllerOnTop:(UIViewController*)viewController {
    if (AlertyAppDelegate.sharedAppDelegate.mainController.presentedViewController) {
        [AlertyAppDelegate.sharedAppDelegate.mainController.presentedViewController presentViewController:viewController animated:YES completion:nil];
    } else {
        [self presentController:viewController animated:YES completion:nil];
    }
}

- (void)cancelFollowMe {
    if (AlertySettingsMgr.usePIN) {
        self.lockViewClosingView = [LockViewClosingView lockViewClosingView];
        self.lockViewClosingView.delegate = self;
        self.lockViewClosingView.frame = self.view.frame;
        [self.lockViewClosingView.pincodeTitleLabel setText:NSLocalizedString(@"Please enter PIN-code to cancel Follow me!", @"")];
        [self.lockViewClosingView resetState];
        [self.view addSubview:self.lockViewClosingView];
    } else {
        [self didUnlockLocker];
    }
}

- (void) followMeReceived:(NSString*)followMe userId:(NSString*)userId showFollowing:(BOOL)showFollowing {
    self.followingName = followMe;
    self.followingId = userId;
    [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeReceived visible:YES title:followMe];
    [self startFollowMeReceivedCheck:showFollowing];
}

- (void) startFollowMeReceivedCheck:(BOOL)showFollowing {
    [self.followMeTimer invalidate];
    self.followMeTimer = nil;
    [self checkFollowing: showFollowing];
    self.followMeTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self checkFollowing: NO];
    }];
}

- (void) checkFollowing:(BOOL)showFollowing {
    NSString* url = [HOME_URL stringByAppendingFormat:@"/getposition.php?id=%@", self.followingId];
    [MobileInterface getJsonObject:url completion:^(NSDictionary *result, NSString *errorMessage) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (!result || ![result isKindOfClass:NSDictionary.class]) {
                [self.followMeTimer invalidate];
                self.followMeTimer = nil;
                [self.bannerTableView setBannerVisibleWithType:BannerTypeFollowMeReceived visible:NO title:nil];
                self.followingName = nil;
                self.followingId = nil;
            } else if (showFollowing) {
                [self showFollowing];
            }
        }];
    }];
}

#pragma mark - AlertManagerPresenter

- (void) addAlarmBannerWithAlertInfo:(AlertInfo *)alertInfo {
    [self.bannerTableView addAlarmBannerWithAlertInfo:alertInfo title:alertInfo.message];
}

- (void)removeAlarmBannerWithAlertInfo:(AlertInfo *)alertInfo {
    [self.bannerTableView removeAlarmBannerWithAlertId:alertInfo.alertId];
}

@end

