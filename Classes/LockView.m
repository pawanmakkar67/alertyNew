//
//  LockView.m
//  Alerty
//
//  Created by Mac on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LockView.h"
#import "NSBundleAdditions.h"
#import "NSHelpers.h"
#import "DataManager.h"
#import "AlertySettingsMgr.h"
#import "UIViewAdditions.h"
#import "UIScreenAdditions.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"
#import "ConverstationController.h"
#import "Utils.h"
#import "MobileInterface.h"
#import "Alerty-Swift.h"

@import TwilioVoice;
@import TwilioVideo;

@import Photos;

@interface LockView () <TVIRoomDelegate, TVICameraSourceDelegate, TVIRemoteParticipantDelegate, TVOCallDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unlockButtonLeftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *cameraLabel;

@property (nonatomic, strong) TVICameraSource *camera;
@property (nonatomic, strong) TVILocalVideoTrack *localVideoTrack;
@property (nonatomic, strong) TVILocalAudioTrack *localAudioTrack;
@property (nonatomic, strong) TVILocalDataTrack *localDataTrack;
@property (nonatomic, strong) NSMutableArray<TVIRemoteParticipant*>* remoteParticipants;
@property (nonatomic, strong) NSMutableArray<TVIVideoView*>* remoteViews;
@property (nonatomic, strong) TVIRoom *room;

@property (weak, nonatomic) IBOutlet TVIVideoView *previewView;
@property (strong, nonatomic) ConverstationController* converstationController;

@property (nonatomic, strong) UIAlertView* alertView;

@property (nonatomic, strong) TVOCall *call;

@end

@implementation LockView

static NSString *const kAccessTokenEndpoint = HOME_URL @"/ws/startvoice.php";
static NSString *const kTwimlParamTo = @"to";
static NSString *const kTwimlParamFrom = @"from";

#pragma mark - Overrides

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImage *) viewImage:(UIView*)view {
	UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen scale]);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return retval;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.window endEditing:YES];
}


- (void)awakeFromNib {
    [super awakeFromNib];
	
    self.remoteParticipants = [NSMutableArray array];
    self.remoteViews = [NSMutableArray array];

	if(_imageName) [self.unlockButtonView setImage:[UIImage imageNamed:self.imageName]];
    
	[[DataManager sharedDataManager] getUserSettings];
	
	self.videoScrollView.delegate = self;
	
	_callHasStarted = NO;
	_videoUrlSet = NO;
	
	self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
	self.swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	self.swipeRecognizer.delegate = self;
	[self addGestureRecognizer:self.swipeRecognizer];
	
	self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressLockView:)];
	self.longPressRecognizer.delegate = self;
	self.longPressRecognizer.minimumPressDuration = 3.0;
	[self addGestureRecognizer:self.longPressRecognizer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertCreated:) name:kAlertCreatedNotification object:nil];

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        self.callButton.selected = YES;
        self.cameraLabel.text = @"Installningar";
    }
}

- (void)alertCreated:(NSNotification *)notification {

    dispatch_async(dispatch_get_main_queue(), ^{

	NSDictionary* userInfo = [notification object];
	NSString* roomName = [userInfo objectForKey:@"room"];
	NSString* token = [userInfo objectForKey:@"token"];
    NSString* voice = [userInfo objectForKey:@"voice"];
    NSString* voicePhone = [userInfo objectForKey:@"voicePhone"];
	if (!self.room && roomName && token) {
        [self setupSession:roomName token:token voice:voice phone:voicePhone];
	}
    if ([AlertySettingsMgr screenshotEnabled]) {
        [self uploadScreenshot];
    }
    });
}

- (void)logMessage:(NSString *)msg {
    NSLog(@"%@", msg);
}

#pragma mark - Private

- (void)startPreview {
    self.previewView.hidden = NO;

    // TVICameraCapturer is not supported with the Simulator.
    if ([PlatformUtils isSimulator]) {
        [self.previewView removeFromSuperview];
        return;
    }
    
    self.camera = [[TVICameraSource alloc] init];
    self.localVideoTrack = [TVILocalVideoTrack trackWithSource:self.camera
                                                       enabled:YES
                                                          name:@"Camera"];
    if (!self.localVideoTrack) {
        [self logMessage:@"Failed to add video track"];
        [self updateCameraPosition: AVCaptureDevicePositionUnspecified];
    } else {
        // Add renderer to video track for local preview
        [self.localVideoTrack addRenderer:self.previewView];
        [self logMessage:@"Video track created"];
        AVCaptureDevicePosition position = AlertySettingsMgr.frontCameraEnabled ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
        [self.camera startCaptureWithDevice:[TVICameraSource captureDeviceForPosition:position]];
        [self updateCameraPosition: position];
    }
}

- (void)prepareLocalMedia {
    
    // We will share local audio and video when we connect to room.
    
    if (!self.localDataTrack) {
        self.localDataTrack = [TVILocalDataTrack trackWithOptions:nil];
    }
    
    // Create an audio track.
    if (!self.localAudioTrack) {
        self.localAudioTrack = [TVILocalAudioTrack trackWithOptions:nil
                                                            enabled:YES
                                                               name:@"Microphone"];
        
        if (!self.localAudioTrack) {
            [self logMessage:@"Failed to add audio track"];
        }
    }
    
    // Create a video track which captures from the camera.
    if (!self.localVideoTrack) {
        [self startPreview];
    }
}

- (void)setupSession:(NSString*)roomName token:(NSString*)token voice:(NSString*)voice phone:(NSString*)phone{

    TVIDefaultAudioDevice* audioDevice = TVIDefaultAudioDevice.audioDevice;
    
    // Prepare local media which we will share with Room Participants.
    [self prepareLocalMedia];
    
    TVIConnectOptions *connectOptions = [TVIConnectOptions optionsWithToken:token
                                                                      block:^(TVIConnectOptionsBuilder * _Nonnull builder) {
                                                                          
                                                                          // Use the local media that we prepared earlier.
                                                                          builder.audioTracks = self.localAudioTrack ? @[ self.localAudioTrack ] : @[ ];
                                                                          builder.videoTracks = self.localVideoTrack ? @[ self.localVideoTrack ] : @[ ];
                                                                          builder.dataTracks = self.localDataTrack ? @[ self.localDataTrack ] : @[ ];
                                                                          
                                                                          // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
                                                                          // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
                                                                          builder.roomName = roomName;
                                                                      }];
    
    // Connect to the Room using the options we provided.
    self.room = [TwilioVideoSDK connectWithOptions:connectOptions delegate:self];
 
    audioDevice.block =  ^ {
        // We will execute `kDefaultAVAudioSessionConfigurationBlock` first.
        kTVODefaultAVAudioSessionConfigurationBlock();
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error = nil;
        if (![session setMode:AVAudioSessionModeVideoChat error:&error]) {
            NSLog(@"AVAudiosession setMode %@", error);
        }
        
        // Overwrite the audio route
        if (![session overrideOutputAudioPort:([AlertySettingsMgr speakerEnabled] ?   AVAudioSessionPortOverrideSpeaker : AVAudioSessionPortOverrideNone) error:&error]) {
            NSLog(@"AVAudiosession overrideOutputAudioPort %@", error);
        }
    };
    audioDevice.block();
    
    if (voice.length && phone.length && !self.call) {
        NSDictionary* params = @{ kTwimlParamTo: phone, kTwimlParamFrom: AlertySettingsMgr.UserPhoneNr};
        TVOConnectOptions *connectOptions = [TVOConnectOptions optionsWithAccessToken:voice
                                                                                block:^(TVOConnectOptionsBuilder *builder) {
                                                                                    builder.params = params;
                                                                                }];
        self.call = [TwilioVoiceSDK connectWithOptions:connectOptions delegate:self];
        
        [CallKitHelper.instance startOutgoingAlert];
    }
}

/*- (NSString *)fetchAccessToken {
    NSString *accessTokenEndpointWithIdentity = [NSString stringWithFormat:@"%@?identity=%@", kAccessTokenEndpoint, @"caller"];
    NSString *accessToken = [NSString stringWithContentsOfURL:[NSURL URLWithString:accessTokenEndpointWithIdentity]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    return accessToken;
}*/

- (void) updateCameraPosition:(AVCaptureDevicePosition)position {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied) {
            self.callButton.selected = YES;
            self.cameraLabel.text = @"Installningar";
        } else {
            self.cameraLabel.text = position == AVCaptureDevicePositionFront ? NSLocalizedString(@"Front camera", @"Front camera") : NSLocalizedString(@"Rear camera", @"Rear camera");
        }
    }];
}

- (void)hideToast {
	[UIView animateWithDuration:0.5
						  delay:0.0
						options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
					 animations:^(void) {
                         self.viewToast.alpha = 0.0;
					 }
					 completion:nil
	 ];
	[self.alertView dismissWithClickedButtonIndex:0 animated:YES];
	self.alertView = nil;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self];
	
	if (CGRectContainsPoint(self.unlockButtonView.frame, location))
	{
		_quitTouched = TRUE;
		[self.slideToLabel.layer.mask removeAnimationForKey:@"slideAnim"];
		self.slideToLabel.layer.mask = nil;
	}
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	if (_quitTouched) {
        
        CGFloat left = [[touches anyObject] locationInView:self].x;
        
        if ( (left - 46) >= _loop * 12) {
			self.slideToLabel.alpha = self.slideToLabel.alpha - 0.1;
			_loop++;
		}
				
        if (left < _startLocation.x) {
			//self.unlockButtonView.center = _startLocation;
            left = _startLocation.x;
        }
		
        if (left >= self.frame.size.width) {
            left = self.frame.size.width;
        }
        self.unlockButtonLeftConstraint.constant = left - 72;
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	if (_quitTouched) {
		_quitTouched = FALSE;
		if(_showPinEntryViewOnUnlock) {
            
            if (AlertySettingsMgr.usePIN) {
                self.viewToast.alpha = 0.0;
                if (self.unlockButtonLeftConstraint.constant >= self.frame.size.width - 150) {
                    [self.delegate lockDidRequestPin:self];
                
                    if(!_lockViewClosingView) {
                        self.lockViewClosingView = [LockViewClosingView lockViewClosingView];
                        self.lockViewClosingView.frame = self.frame;
                        _lockViewClosingView.delegate = self;
                    }
                
                    // hides info if called by the TabBar
                    _lockViewClosingView.pincodeTitleLabel.hidden = self.bgView.hidden;
                
                    [_lockViewClosingView resetState];
                    [self addSubview:_lockViewClosingView];
                
                    self.previewView.hidden = YES;
                    //self.currentSubscriber.view.hidden = YES;
                }
                self.unlockButtonLeftConstraint.constant = _startLocation.x - 72.0;
                self.slideToLabel.layer.mask = self.maskLayer;
                [self.slideToLabel.layer.mask addAnimation:self.maskAnim forKey:@"slideAnim"];
                self.slideToLabel.alpha = 1.0;
                _loop = 1;
            } else {
                [self.delegate lockDidUnlock:self];
            }
		}
		else {
			[self.delegate lockDidUnlock:self];
		}
		
		return;
	}
}

#pragma mark - IBActions

- (IBAction)switchMic:(id)sender {
    if (self.localAudioTrack) {
        self.localAudioTrack.enabled = !self.localAudioTrack.isEnabled;
        self.micButton.selected = !self.localAudioTrack.enabled;
    }
}

- (IBAction)switchCall:(id)sender {
    if (self.callButton.isSelected) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        return;
    }
    
    if (self.camera.device.position == AVCaptureDevicePositionFront) {
        [self.camera selectCaptureDevice:[TVICameraSource captureDeviceForPosition:AVCaptureDevicePositionBack]];
        [self updateCameraPosition: AVCaptureDevicePositionBack];
    } else {
        [self.camera selectCaptureDevice:[TVICameraSource captureDeviceForPosition:AVCaptureDevicePositionFront]];
        [self updateCameraPosition: AVCaptureDevicePositionFront];
    }
}

- (IBAction)didLongPressLockView:(UIGestureRecognizer *)sender {
	switch(sender.state) {
		case UIGestureRecognizerStateBegan:
			if( [self.delegate respondsToSelector:@selector(lockDidLongPressLock:)] ) {
				[self.delegate lockDidLongPressLock:self];
			}
			break;
		default:
			break;
	}
}

- (void)swipeLeft:(UISwipeGestureRecognizer*) sender {
	self.viewToast.alpha = 0.0;
	[self.delegate lockDidRequestPin:self];
	
	if(!_lockViewClosingView) {
		self.lockViewClosingView = [LockViewClosingView lockViewClosingView];
		self.lockViewClosingView.frame = self.frame;
		_lockViewClosingView.delegate = self;
	}
	
	// hides info if called by the TabBar
	_lockViewClosingView.pincodeTitleLabel.hidden = self.bgView.hidden;
	
	[_lockViewClosingView resetState];
	[self addSubview:_lockViewClosingView];
	
	self.previewView.hidden = YES;
	//self.currentSubscriber.view.hidden = YES;

	self.unlockButtonLeftConstraint.constant = _startLocation.x - 72;
	self.slideToLabel.layer.mask = self.maskLayer;
	[self.slideToLabel.layer.mask addAnimation:self.maskAnim forKey:@"slideAnim"];
	self.slideToLabel.alpha = 1.0;
	_loop = 1;
}

#pragma mark - Public methods

- (void) startAnimation {
	if (self.viewToast.alpha != 0.0) {
		self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Screen lock", @"") message:NSLocalizedString(@"Tap and hold the screen", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[self.alertView show];
	}
	
	//[self performSelector:@selector(hideToast) withObject:nil afterDelay:10.0];
	
	_quitTouched = FALSE;
	_startLocation = self.unlockButtonView.center;
    _loop = 1;
    
    [self.maskLayer addAnimation:self.maskAnim forKey:@"slideAnim"];
	
    [UIView setAnimationsEnabled:YES];
	
    [self.layer removeAllAnimations];
    self.layer.transform = CATransform3DIdentity;
    
    /*[UIView animateWithDuration:1.0
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat
                     animations:^{
                         self.activeText.alpha = 0.0;
                     }
                     completion:nil];*/
	
	self.unlockButtonView.hidden = self.activeView.hidden;
	self.slideToLabel.hidden = self.activeView.hidden;
	self.swipeRecognizer.enabled = self.activeView.hidden;
    
	if (self.activeView.hidden) return;

#if !(TARGET_IPHONE_SIMULATOR)
	_endCall = NO;
	if (!self.room && AlertySettingsMgr.roomName && AlertySettingsMgr.roomToken) {
        [self setupSession:AlertySettingsMgr.roomName token:AlertySettingsMgr.roomToken voice:[DataManager sharedDataManager].voice phone:[DataManager sharedDataManager].voicePhone];
	}
    
    //if ([UIApplication state] == UIApplicationStateActive && _publisher) {
    //    _publisher.publishVideo = YES;
    //}
#endif
}

+ (LockView *) lockView {
	LockView *lockView = [NSBundle loadFirstFromNib:@"LockView"];
	lockView.showPinEntryViewOnUnlock = YES;
	return lockView;
}

-(void) saveRecordedFile {
#if !(TARGET_IPHONE_SIMULATOR)
/*	NSString* recordUrl = [self.ovxView getRecordedFile];
	NSLog(@"recorded url: %@", recordUrl);
	if (!self.videoUrlSet && recordUrl && recordUrl.length) {
		NSNumber* alertId = [NSNumber numberWithInt:[DataManager sharedDataManager].alertId];
		NSDictionary *get = _nsdictionary(_nsdictionary(alertId, @"id", recordUrl, @"url"), GWMethodGETKey);
		self.setVideoUrlCall = [GWCall dataCall:self
										baseURL:SETVIDEOURL_URL
									 parameters:get
									   userInfo:nil];
	} else {
		[self performSelector:@selector(saveRecordedFile) withObject:nil afterDelay:1.0];
	}*/
#endif
}

#pragma mark - LockViewClosingViewDelegate

- (void) didCancelLockView {
    [self.lockViewClosingView removeFromSuperview];
    self.lockViewClosingView = nil;
	self.previewView.hidden = NO;
	//self.currentSubscriber.view.hidden = NO;
    [self.window endEditing:YES];
}

- (void) didUnlockLocker {
	if (self.room) {
        [self.room disconnect];
        self.room = nil;
		[AlertySettingsMgr setRoomName:nil];
		[AlertySettingsMgr setRoomToken:nil];
        [DataManager sharedDataManager].voice = nil;
        [DataManager sharedDataManager].voicePhone = nil;
	}
	_endCall = YES;
	
    [self.call disconnect];
    self.call = nil;
    [CallKitHelper.instance reportOutgoingCallEnded];
    
	[self.delegate lockDidUnlock:self];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch; {
	return YES;
}

#pragma mark GWCallDelegate

- (void) gwCallDidSucceed:(GWCall*)gwCall {
	if (gwCall == self.setVideoUrlCall) {
		self.setVideoUrlCall = nil;
		self.videoUrlSet = YES;
		return;
	}
}

- (void) gwCallDidFail:(GWCall*)gwCall {
	if (gwCall == self.setVideoUrlCall) {
		self.setVideoUrlCall = nil;
		self.videoUrlSet = YES;
	}
}

#pragma mark - Helper Methods

- (IBAction)endCallAction:(UIButton *)button
{
	if (self.room /*&& _session.sessionConnectionStatus == OTSessionConnectionStatusConnected*/) {
		// disconnect session
		NSLog(@"disconnecting....");
        [self.room disconnect];
		//[_session release];
		//_session = nil;
        [AlertySettingsMgr setRoomName:nil];
        [AlertySettingsMgr setRoomToken:nil];
        [DataManager sharedDataManager].voice = nil;
        [DataManager sharedDataManager].voicePhone = nil;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// current subscriber
	int currentPage = (int)(self.videoScrollView.contentOffset.x /
							self.videoScrollView.frame.size.width);
	
	if (currentPage < self.remoteViews.count) {
		// show current scrolled subscriber
        self.pageControl.currentPage = currentPage;
		//[self showAsCurrentSubscriber:[_allSubscribers objectForKey:connectionId]];
	}
	//[self resetArrowsStates];
}

#pragma mark - TVIRoomDelegate

- (void)didConnectToRoom:(TVIRoom *)room {
    // At the moment, this example only supports rendering one Participant at a time.
    
    [self logMessage:[NSString stringWithFormat:@"Connected to room %@ as %@", room.name, room.localParticipant.identity]];
    
    self.previewView.hidden = NO;
    
    for (TVIRemoteParticipant* participant in room.remoteParticipants) {
        participant.delegate = self;
        
        [self logMessage:[NSString stringWithFormat:@"Participant %@ connected with %lu audio and %lu video tracks",
                          participant.identity,
                          (unsigned long)[participant.audioTracks count],
                          (unsigned long)[participant.videoTracks count]]];
    }
    
    /*if (room.remoteParticipants.count > 0) {
        self.remoteParticipant = room.remoteParticipants[0];
        self.remoteParticipant.delegate = self;
        self.previewView.hidden = NO;
        self.incomingCallView.hidden = YES;
        self.statusSubtitle.text = @"";
        self.statusTitle.text = @"";
    }*/
    
    //[self.converstationController removeFromParentViewController];
    [self.converstationController.view removeFromSuperview];
    
    self.converstationController = [[ConverstationController alloc] initWithNibName:@"ConverstationController" bundle:nil];
    //self.vi
    self.converstationController.localDataTrack = self.localDataTrack;
    [self.videoView insertSubview:self.converstationController.view belowSubview:self.callButton];
    
    CGRect frame = self.videoView.bounds;
    //frame.origin.y += 200;
    //frame.size.height -= 200;
    self.converstationController.view.frame = frame;
    
    [room.localParticipant publishDataTrack:self.localDataTrack];
}

- (void)room:(TVIRoom *)room didDisconnectWithError:(nullable NSError *)error {
    [self logMessage:[NSString stringWithFormat:@"Disconncted from room %@, error = %@", room.name, error]];
    
    //[self cleanupRemoteParticipant];
    self.room = nil;
}

- (void)room:(TVIRoom *)room didFailToConnectWithError:(nonnull NSError *)error{
    [self logMessage:[NSString stringWithFormat:@"Failed to connect to room, error = %@", error]];
    self.room = nil;
}

- (void)room:(TVIRoom *)room participantDidConnect:(TVIRemoteParticipant *)participant {
    participant.delegate = self;
    /*if (!self.remoteParticipant) {
        self.remoteParticipant = participant;
        self.remoteParticipant.delegate = self;
        self.previewView.hidden = NO;
        self.incomingCallView.hidden = YES;
        self.statusSubtitle.text = @"";
        self.statusTitle.text = @"";
    }*/
    [self logMessage:[NSString stringWithFormat:@"Participant %@ connected with %lu audio and %lu video tracks",
                      participant.identity,
                      (unsigned long)[participant.audioTracks count],
                      (unsigned long)[participant.videoTracks count]]];
    //self.room = room;
}

- (void)room:(TVIRoom *)room participantDidDisconnect:(TVIRemoteParticipant *)participant {
    /*if (self.remoteParticipant == participant) {
        [self cleanupRemoteParticipant];
        self.previewView.hidden = YES;
        self.statusTitle.text = self.recipient;
        self.statusSubtitle.text = NSLocalizedString(@"ended the call", @"");
        [self performSelector:@selector(endCall:) withObject:nil afterDelay:5.0];
    }*/
    [self logMessage:[NSString stringWithFormat:@"Room %@ participant %@ disconnected", room.name, participant.identity]];
}

#pragma mark - TVIRemoteParticipantDelegate

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didPublishVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    // Remote Participant has offered to share the video Track.
    [self logMessage:[NSString stringWithFormat:@"Participant %@ published %@ video track .",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didUnpublishVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    // Remote Participant has stopped sharing the video Track.
    [self logMessage:[NSString stringWithFormat:@"Participant %@ unpublished %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didPublishAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    // Remote Participant has offered to share the audio Track.
    [self logMessage:[NSString stringWithFormat:@"Participant %@ published %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didUnpublishAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    // Remote Participant has stopped sharing the audio Track.
    [self logMessage:[NSString stringWithFormat:@"Participant %@ unpublished %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)didSubscribeToVideoTrack:(TVIRemoteVideoTrack *)videoTrack publication:(TVIRemoteVideoTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are subscribed to the remote Participant's audio Track. We will start receiving the
    // remote Participant's video frames now.
    
    [self logMessage:[NSString stringWithFormat:@"Subscribed to %@ video track for Participant %@",
                      publication.trackName, participant.identity]];
    
    /*if (self.remoteParticipant == participant) {
        [self setupRemoteView];
        [videoTrack addRenderer:self.remoteView];
    }*/
    
    TVIVideoView *remoteView = [[TVIVideoView alloc] init];
    remoteView.contentMode = UIViewContentModeScaleAspectFill;
    
    // set subscriber position and size
    CGFloat containerWidth = CGRectGetWidth(self.videoScrollView.bounds);
    CGFloat containerHeight = CGRectGetHeight(self.videoScrollView.bounds);
    NSInteger count = self.remoteViews.count;
    remoteView.frame = CGRectMake(count * CGRectGetWidth(self.videoScrollView.bounds),
                0,
                containerWidth,
                containerHeight);
    remoteView.tag = count;
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, containerWidth-10, 21)];
    [nameLabel setText:participant.identity];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setTextAlignment:NSTextAlignmentRight];
    [remoteView addSubview:nameLabel];
    
    self.pageControl.numberOfPages = count + 1;
    self.pageControl.hidden = (count == 0);

    CGRect frame = self.videoView.bounds;
    if (count) {
        frame.size.height -= 36;
    }
    self.converstationController.view.frame = frame;
    
    // add to video container view
    [self.videoScrollView addSubview:remoteView];
    [self.remoteViews addObject:remoteView];
    [self.remoteParticipants addObject:participant];
    
    [videoTrack addRenderer:remoteView];
    
    // default subscribe video to the first subscriber only
    //if (!self.currentSubscriber) {
    //    [self showAsCurrentSubscriber:(OTSubscriber *)subscriber];
    //} else {
    //    subscriber.subscribeToVideo = NO;
    //}
    
    // set scrollview content width based on number of subscribers connected.
    [self.videoScrollView setContentSize: CGSizeMake(self.videoScrollView.frame.size.width * (count+1),
                                                     self.videoScrollView.frame.size.height - 18)];
}

- (void)didUnsubscribeFromVideoTrack:(TVIRemoteVideoTrack *)videoTrack publication:(TVIRemoteVideoTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
    // remote Participant's video.
    
    [self logMessage:[NSString stringWithFormat:@"Unsubscribed from %@ video track for Participant %@",
                      publication.trackName, participant.identity]];
    
    /*if (self.remoteParticipant == participant) {
        [videoTrack removeRenderer:self.remoteView];
        [self.remoteView removeFromSuperview];
    }*/
    
    for (NSUInteger i=0; i<self.remoteParticipants.count; i++) {
        if (self.remoteParticipants[i] == participant) {
            [videoTrack removeRenderer:self.remoteViews[i]];
            [self.remoteViews[i] removeFromSuperview];
            [self.remoteViews removeObjectAtIndex:i];
            [self.remoteParticipants removeObjectAtIndex:i];
            break;
        }
    }
    
    NSInteger count = self.remoteViews.count;
    CGFloat containerWidth = CGRectGetWidth(self.videoScrollView.bounds);
    CGFloat containerHeight = CGRectGetHeight(self.videoScrollView.bounds);
    for (NSUInteger i=0; i<count; i++) {
        self.remoteViews[i].frame = CGRectMake(i * CGRectGetWidth(self.videoScrollView.bounds),
                                               0,
                                               containerWidth,
                                               containerHeight);
    }
    
    self.pageControl.numberOfPages = count;
    self.pageControl.hidden = (count <= 1);
    [self.videoScrollView setContentSize: CGSizeMake(self.videoScrollView.frame.size.width * count,
                                                     self.videoScrollView.frame.size.height - 18)];
}

- (void)didSubscribeToAudioTrack:(TVIRemoteAudioTrack *)audioTrack publication:(TVIRemoteAudioTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are subscribed to the remote Participant's audio Track. We will start receiving the
    // remote Participant's audio now.
    
    [self logMessage:[NSString stringWithFormat:@"Subscribed to %@ audio track for Participant %@",
                      publication.trackName, participant.identity]];
}

- (void)didUnsubscribeFromAudioTrack:(TVIRemoteAudioTrack *)audioTrack publication:(TVIRemoteAudioTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
    // remote Participant's audio.
    
    [self logMessage:[NSString stringWithFormat:@"Unsubscribed from %@ audio track for Participant %@",
                      publication.trackName, participant.identity]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didEnableVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    [self logMessage:[NSString stringWithFormat:@"Participant %@ enabled %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didDisableVideoTrack:(TVIRemoteVideoTrackPublication *)publication {
    [self logMessage:[NSString stringWithFormat:@"Participant %@ disabled %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didEnableAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    [self logMessage:[NSString stringWithFormat:@"Participant %@ enabled %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)remoteParticipant:(TVIRemoteParticipant *)participant didDisableAudioTrack:(TVIRemoteAudioTrackPublication *)publication {
    [self logMessage:[NSString stringWithFormat:@"Participant %@ disabled %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)didFailToSubscribeToAudioTrack:(TVIRemoteAudioTrackPublication *)publication error:(NSError *)error forParticipant:(TVIRemoteParticipant *)participant {
    [self logMessage:[NSString stringWithFormat:@"Participant %@ failed to subscribe to %@ audio track.",
                      participant.identity, publication.trackName]];
}

- (void)didFailToSubscribeToVideoTrack:(TVIRemoteVideoTrackPublication *)publication error:(NSError *)error forParticipant:(TVIRemoteParticipant *)participant {
    [self logMessage:[NSString stringWithFormat:@"Participant %@ failed to subscribe to %@ video track.",
                      participant.identity, publication.trackName]];
}

- (void)didSubscribeToDataTrack:(TVIRemoteDataTrack *)dataTrack publication:(TVIRemoteDataTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {
    dataTrack.delegate = self.converstationController;
    [self.converstationController.participants setObject:participant forKey:dataTrack.sid];
}


#pragma mark - TVIVideoViewDelegate

- (void)videoView:(TVIVideoView *)view videoDimensionsDidChange:(CMVideoDimensions)dimensions {
    NSLog(@"Dimensions changed to: %d x %d", dimensions.width, dimensions.height);
    [self setNeedsLayout];
}

#pragma mark - TVICameraSourceDelegate

/*- (void)cameraCapturer:(TVICameraCapturer *)capturer didStartWithSource:(TVICameraCaptureSource)source {
    self.previewView.mirror = (source == TVICameraCaptureSourceFrontCamera);
}*/

#pragma mark - TVOCallDelegate

- (void)callDidConnect:(nonnull TVOCall *)call {
    [CallKitHelper.instance reportOutgoingCallConnected];
}

- (void)call:(nonnull TVOCall *)call didFailToConnectWithError:(nonnull NSError *)error {
    self.call = nil;
    [CallKitHelper.instance reportOutgoingCallEnded];
}

- (void)call:(nonnull TVOCall *)call didDisconnectWithError:(nullable NSError *)error {
    self.call = nil;
    [CallKitHelper.instance reportOutgoingCallEnded];
}

#pragma mark Screenshot upload

- (void)uploadScreenshot {
    PHFetchResult<PHAssetCollection *> *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil];
    [albums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull album, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.wantsIncrementalChangeDetails = YES;
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",PHAssetMediaTypeImage];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:options];
        [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDate* now = [NSDate date];
            now = [now addHours:-1];
            if ([asset.creationDate timeIntervalSinceDate:now] > 0) {
                [self loadAsset:asset];
            }
            *stop = YES;
        }];
    }];
}

- (void) loadAsset:(PHAsset*)asset {
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.version = PHImageRequestOptionsVersionCurrent;
    [PHImageManager.defaultManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        NSLog(@"asset: %@", asset.creationDate);
        UIImage* image = [UIImage imageWithData:imageData];
        [MobileInterface submitScreenshot:image alertID:[DataManager sharedDataManager].alertId completion:^(BOOL success, NSString *errorMessage) {
        }];
    }];
}

@end
