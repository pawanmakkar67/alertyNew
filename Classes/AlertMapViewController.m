//
//  AlertMapViewController.m
//  Alerty
//
//  Created by Mekom Ltd. on 04/04/14.
//
//

#import "AlertMapViewController.h"
#import "NSExtensions.h"
#import "FriendCell.h"
#import "AlertySettingsMgr.h"
#import "AlertyDBMgr.h"
#import "AudioPlayback2.h"
#import "AlertyAppDelegate.h"

#import "ConverstationController.h"
#import "MobileInterface.h"

#import <TwilioVideo/TwilioVideo.h>

@import Proximiio;
@import ProximiioMapbox;
@import Mapbox;

@interface AlertMapViewController () <UIScrollViewDelegate, TVIRemoteParticipantDelegate, TVIRoomDelegate, TVIVideoViewDelegate, TVICameraSourceDelegate, MGLMapViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *incomingAlertView;
@property (strong, nonatomic) IBOutlet UIScrollView *videoScrollView;
@property (nonatomic, assign) long selectedRowId;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *alarmType;
@property (strong, nonatomic) IBOutlet UIView *help24view;
@property (strong, nonatomic) IBOutlet UITextView *help24text;
@property (weak, nonatomic) IBOutlet UILabel *mapButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *appName;

@property (nonatomic, assign) NSInteger mapId;
@property (nonatomic, assign) BOOL endCall;

#pragma mark Video SDK components

@property (nonatomic, strong) TVICameraSource *camera;
@property (nonatomic, strong) TVILocalVideoTrack *localVideoTrack;
@property (nonatomic, strong) TVILocalAudioTrack *localAudioTrack;
@property (nonatomic, strong) TVILocalDataTrack *localDataTrack;
@property (nonatomic, strong) TVIRemoteParticipant* remoteParticipant;
@property (nonatomic, strong) TVIVideoView *remoteView;
@property (nonatomic, strong) TVIRoom *room;
@property (nonatomic, strong) ConverstationController *converstationController;

#pragma mark UI Element Outlets and handles

@property (weak, nonatomic) IBOutlet TVIVideoView *previewView;

#pragma mark MapBox

@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (nonatomic, strong) MGLMapView* mapView;
@property (nonatomic, strong) ProximiioMapbox* mapBoxHelper;
@property (nonatomic, strong) NSTimer* mapBoxTimer;

@property (nonatomic, strong) MGLPointAnnotation* annotation;
@property (nonatomic, strong) MGLShapeSource* mapSource;
@property (nonatomic, strong) MGLSymbolStyleLayer* mapLayer;
@property (nonatomic, strong) MGLCircleStyleLayer* circleLayer;

#pragma mark Old stuff

@property (nonatomic, strong) NSDictionary* alertData;

@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *alertDescription;
@property (strong, nonatomic) IBOutlet UILabel *accuracy;
@property (strong, nonatomic) IBOutlet UILabel *activated;

@property (strong, nonatomic) IBOutlet UIButton *btnAccept;
@property (strong, nonatomic) IBOutlet UIView *cameraView;

@property (strong, nonatomic) IBOutlet UIButton *btnMap;
@property (strong, nonatomic) IBOutlet UIButton *btnVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo;

@property (strong, nonatomic) NSTimer* timer;

@property (strong, nonatomic) NSString* sound;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *closingIndicator;

@property (strong, nonatomic) IBOutlet UILabel *groupLabel;

@end

@implementation AlertMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef SAKERHETSAPPEN
    self.incomingAlertView.backgroundColor = COLOR_ACCENT;
#endif
    
	self.navigationItem.title = NSLocalizedString(@"Map", @"");
    self.sound = [[NSBundle mainBundle] pathForResource:@"beeping" ofType:@"aif"];
	self.endCall = NO;
	
	UIBarButtonItem *doneButton = nil;
	doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close",@"") style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
	self.navigationItem.rightBarButtonItem = doneButton;
	
	// configure video container view
	self.videoScrollView.scrollEnabled = YES;
	self.videoScrollView.pagingEnabled = YES;
	self.videoScrollView.delegate = self;
	self.videoScrollView.showsHorizontalScrollIndicator = NO;
	self.videoScrollView.showsVerticalScrollIndicator = YES;
	self.videoScrollView.bounces = NO;
	self.videoScrollView.alwaysBounceHorizontal = NO;
	
	[self mapSelected:nil];
    
    if (self.openAlert) {
        self.incomingAlertView.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
    } else {
        self.status.text = self.statusText;
        self.navigationController.navigationBarHidden = YES;
    }
    
    self.mapView = [[MGLMapView alloc] initWithFrame:self.mapContainer.bounds];
    self.mapView.delegate = self;
    [self.mapContainer insertSubview:self.mapView atIndex:0];
    
    if (self.mapView) {
        ProximiioMapboxConfiguration* configuration = [[ProximiioMapboxConfiguration alloc] initWithToken:Proximiio.sharedInstance.token];
        configuration.showUserLocation = NO;
        self.mapBoxHelper = [[ProximiioMapbox alloc] init];
        [self.mapBoxHelper setupWithMapView:self.mapView configuration:configuration];
        self.mapBoxHelper.followingUser = NO;
        [self.mapBoxHelper initialize:^(enum ProximiioMapboxAuthorizationResult result) {
        }];
    }
    
    self.appName.text = NSLocalizedStringFromTable(@"Alerty", @"Target", @"");
}

- (void) addMap:(NSInteger)mapId {
    
    if (self.mapId == mapId) return;
    
    self.mapId = mapId;
    if (mapId) {

        for (ProximiioFloor* floor in Proximiio.sharedInstance.floors) {
            NSInteger mapId = [floor.floorId integerValue];
            if (self.mapId == mapId) {
                [self.mapBoxHelper floorAt:[floor.level integerValue]];
                
                NSArray<ProximiioLocation*>* anchors = floor.anchors;
                CLLocationCoordinate2D c1 = anchors[0].coordinate;
                CLLocationCoordinate2D c2 = anchors[1].coordinate;
                CLLocationCoordinate2D c3 = anchors[2].coordinate;
                CLLocationCoordinate2D c4 = anchors[3].coordinate;
                double left = MIN(c1.longitude, MIN(c2.longitude, MIN(c3.longitude, c4.longitude)));
                double bottom = MIN(c1.latitude, MIN(c2.latitude, MIN(c3.latitude, c4.latitude)));
                double right = MAX(c1.longitude, MAX(c2.longitude, MAX(c3.longitude, c4.longitude)));
                double top = MAX(c1.latitude, MAX(c2.latitude, MAX(c3.latitude, c4.latitude)));
            
                MGLCoordinateBounds bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(bottom, left), CLLocationCoordinate2DMake(top, right));
                [self.mapView setVisibleCoordinateBounds:bounds animated:NO];
                if (self.mapView.zoomLevel > 14.0) {
                    self.mapView.zoomLevel = 14.0;
                }
                break;
            }
        }
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.mapContainer.bounds;
}

- (void) resetAVSession {
    NSError *error = nil;
    
    NSArray* availableInputs = [[AVAudioSession sharedInstance] availableInputs];
    AVAudioSessionPortDescription* port = [availableInputs objectAtIndex:0];
    [[AVAudioSession sharedInstance] setPreferredInput:port error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker
                                                       error:&error];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
    
    if (self.openAlert) {
        [self showAlert];
    } else {
        if(![AlertySettingsMgr discreteModeEnabled]){
            [AudioPlayback2 start:self.sound loop:YES];
        }
    }
}

- (void) showAlert {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    
    [self refresh];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
}

-(void) connectCall  {
    if (self.token.length == 0) {
        NSDictionary* parameters = @{ @"alertId" : [NSNumber numberWithInteger:self.alertID], @"userId" : [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]], @"userid" : [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]] };
        [MobileInterface post:ALERTTOKENCALL_URL body:parameters completion:^(NSDictionary *result, NSString *errorMessage) {
            self.token = result[@"token"];
            if (self.token.length) {
                [self doConnect];
            }
        }];
    } else {
        [self doConnect];
    }

}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	if (self.room) {
        NSLog(@"SESSION DISCONNECT");
		[self.room disconnect];
	}
	self.endCall = YES;
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void) refresh {
	if (self.endCall) {
		[self.timer invalidate];
	} else {
        NSDictionary* parameters = @{ @"id" : [NSNumber numberWithInteger:self.alertID], @"userid" : [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]] };
        [MobileInterface post:ALERTINFOCALL_URL body:parameters completion:^(NSDictionary *result, NSString *errorMessage) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {

                NSDictionary* alertInfo = result[@"alertinfo"];
                NSLog(@"alert INFO ==> %@",alertInfo);
                NSLog(@"alert INFO Api response ==> %@",result);

                NSString* addr = nil;
                id address = [alertInfo objectForKey:@"address"];
                if (address && [address isKindOfClass:[NSString class]]) addr = address;
                self.address.text = addr.length ? addr : NSLocalizedString(@"Waiting for address", @"");
                self.alertDescription.text = [self safeString:[alertInfo objectForKey:@"wifi"]];
                self.accuracy.text = [self safeString:[alertInfo objectForKey:@"accuracy"]];
                self.activated.text = [self safeString:[alertInfo objectForKey:@"alertsent"]];
                [self.alertDescription sizeToFit];
                
                NSString* source = nil;
                switch ([[alertInfo objectForKey:@"source"] intValue]) {
                    case ALERT_SOURCE_BUTTON: source = NSLocalizedString(@"ALERT_SOURCE_BUTTON", @""); break;
                    case ALERT_SOURCE_MANDOWN: source = NSLocalizedString(@"ALERT_SOURCE_MANDOWN", @""); break;
                    case ALERT_SOURCE_TIMER: source = NSLocalizedString(@"ALERT_SOURCE_TIMER", @""); break;
                    case ALERT_SOURCE_PEBBLE: source = NSLocalizedString(@"ALERT_SOURCE_PEBBLE", @""); break;
                    case ALERT_SOURCE_EXTERNAL_BUTTON: source = NSLocalizedString(@"ALERT_SOURCE_EXTERNAL_BUTTON", @""); break;
                    case ALERT_SOURCE_WEB: source = NSLocalizedString(@"ALERT_SOURCE_WEB", @""); break;
                    case ALERT_SOURCE_TWILIO: source = NSLocalizedString(@"ALERT_SOURCE_TWILIO", @""); break;
                    //case ALERT_SOURCE_WATCH_BUTTON: source = NSLocalizedString(@"ALERT_SOURCE_WATCH_BUTTON", @""); break;
                    //case ALERT_SOURCE_REGION: source = NSLocalizedString(@"ALERT_SOURCE_REGION", @""); break;
                    default: break;
                }
           
                
                if (([alertInfo valueForKey:@"extra"] == nil) || [[alertInfo valueForKey:@"extra"]  isEqual: @"<null>"] || [alertInfo valueForKey:@"extra"] == (id)[NSNull null] ) {
                   
                }
                else {
                    if ([[alertInfo valueForKey:@"extra"] length] > 0) {
                        source = [NSString stringWithFormat:@"%@ - %@", source, [alertInfo valueForKey:@"extra"]];
                    }
                }
                self.alarmType.text = source;
                NSInteger mapId = [alertInfo[@"map"] integerValue];
                [self addMap:mapId];
                
                NSString* acceptedBy = alertInfo[@"acceptedby"];
                //self.acceptedBy.text = acceptedBy;
                //NSString* accepted = alertInfo[@"accepted"];
                //self.accepted.text = [accepted isKindOfClass:NSString.class] ? accepted : @"";
                
                BOOL acceptable = [result[@"acceptable"] boolValue];
                NSString *userName = [AlertySettingsMgr userFullName];
                if ([AlertySettingsMgr isBusinessVersion]) {
                    userName = [AlertySettingsMgr userNameServer];
                }
                if (acceptable && acceptedBy && ![acceptedBy isKindOfClass:[NSNull class]]) {
                    NSRange range = [acceptedBy rangeOfString:userName];
                    if (range.location != NSNotFound) acceptable = NO;
                }
                self.btnAccept.enabled = acceptable;
                self.btnAccept.backgroundColor = acceptable ? COLOR_ACCENT : COLOR_GRAY_CURSOR;
                
                NSString* closed = [self safeString:[alertInfo objectForKey:@"closed"]];
                if (closed.length > 0) {
                    [self.btnAccept setTitle:NSLocalizedString(@"Alarm closed", @"") forState:UIControlStateDisabled];
                    [self.mapView.style setImage:[UIImage imageNamed:@"follow_me_icon_canceled"] forName:@"home-symbol"];
                } else {
                    UIImage* image = [UIImage imageNamed:@"follow_me_icon_active"];
                    [self.mapView.style setImage:image forName:@"home-symbol"];
                }
                
                self.alertData = result;
                
                id latitude = result[@"latitude"];
                id longitude = result[@"longitude"];
                if (![latitude isKindOfClass:[NSNull class]] && ![longitude isKindOfClass:[NSNull class]] ) {
                
                    double lat = [latitude doubleValue];
                    double lng = [longitude doubleValue];
                    
                    BOOL first = (self.annotation == nil);
                    
                    if (self.circleLayer) {
                        [self.mapView.style removeLayer:self.circleLayer];
                        self.circleLayer = nil;
                    }
                    if (self.mapLayer) {
                        [self.mapView.style removeLayer:self.mapLayer];
                        self.mapLayer = nil;
                    }
                    if (self.mapSource) {
                        [self.mapView.style removeSource:self.mapSource];
                        self.mapSource = nil;
                    }
                    
                    self.annotation = [[MGLPointAnnotation alloc] init];
                    self.annotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
                                            
                    // Create a data source to hold the point data
                    self.mapSource = [[MGLShapeSource alloc] initWithIdentifier:@"marker-source" shape:self.annotation options:nil];
                     
                    // Create a style layer for the symbol
                    self.mapLayer = [[MGLSymbolStyleLayer alloc] initWithIdentifier:@"marker-style" source:self.mapSource];
                     
                    // Tell the layer to use the image in the sprite
                    self.mapLayer.iconImageName = [NSExpression expressionForConstantValue:@"home-symbol"];
                     
                    // Add the source and style layer to the map
                    [self.mapView.style addSource:self.mapSource];
                    [self.mapView.style addLayer:self.mapLayer];
                    
                    id accuracy = result[@"accuracy"];
                    if (accuracy && ![accuracy isKindOfClass:[NSNull class]]) {
                        double acc = [accuracy doubleValue];
                        
                        double pixelRadius = (acc + 10) / 0.072 / cos(lat * 3.1415 / 180);
                        self.circleLayer = [[MGLCircleStyleLayer alloc] initWithIdentifier:@"circles" source:self.mapSource];
                        UIColor* fillColor = [[UIColor alloc] initWithRed:0.0 green:131.0/255.0 blue:255.0/255.0 alpha:0.2];
                        self.circleLayer.circleColor = [NSExpression expressionForConstantValue:fillColor];
                        self.circleLayer.circleRadius = [NSExpression expressionWithFormat:@"mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 2.0, %@)",
                                                         @{@12: @2,
                                                           @22: [NSNumber numberWithDouble:pixelRadius]}];
                        UIColor* strokeColor = [[UIColor alloc] initWithRed:0.0 green:131.0/255.0 blue:255.0/255.0 alpha:0.5];
                        self.circleLayer.circleStrokeColor = [NSExpression expressionForConstantValue:strokeColor];
                        self.circleLayer.circleStrokeWidth = [NSExpression expressionForConstantValue:@1.0];
                        [self.mapView.style addLayer:self.circleLayer];
                    }
                    
                    if (first) {
                        [self.mapView setCenterCoordinate:self.annotation.coordinate zoomLevel:14.0 animated:YES];
                    }
                }
            }];
        }];
	}
}

#pragma mark - Private

- (void)startPreview {
    // TVICameraCapturer is not supported with the Simulator.
    /*if ([PlatformUtils isSimulator]) {
        [self.previewView removeFromSuperview];
        return;
    }*/
    
    self.camera = [[TVICameraSource alloc] initWithDelegate:self];
    self.localVideoTrack = [TVILocalVideoTrack trackWithSource:self.camera
                                                       enabled:YES
                                                          name:@"Camera"];
    
    if (!self.localVideoTrack) {
        [self logMessage:@"Failed to add video track"];
    } else {
        // Add renderer to video track for local preview
        [self.localVideoTrack addRenderer:self.previewView];
        [self logMessage:@"Video track created"];
        [self.camera startCaptureWithDevice:[TVICameraSource captureDeviceForPosition:AVCaptureDevicePositionFront]];
    }
}

- (void)prepareLocalMedia {
    
    if (!self.localDataTrack) {
        self.localDataTrack = [TVILocalDataTrack trackWithOptions:nil];
    }
    
    // We will share local audio and video when we connect to room.
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

- (void)doConnect {
    // Prepare local media which we will share with Room Participants.
    [self prepareLocalMedia];
    
    TVIConnectOptions *connectOptions = [TVIConnectOptions optionsWithToken:self.token
                                                                      block:^(TVIConnectOptionsBuilder * _Nonnull builder) {
                                                                          
                                                                          // Use the local media that we prepared earlier.
                                                                          builder.audioTracks = self.localAudioTrack ? @[ self.localAudioTrack ] : @[ ];
                                                                          builder.videoTracks = self.localVideoTrack ? @[ self.localVideoTrack ] : @[ ];
                                                                          builder.dataTracks = self.localDataTrack ? @[ self.localDataTrack ] : @[ ];
                                                                          
                                                                          // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
                                                                          // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
                                                                          builder.roomName = self.roomName;
                                                                      }];
    
    // Connect to the Room using the options we provided.
    self.room = [TwilioVideoSDK connectWithOptions:connectOptions delegate:self];
    
    //[self logMessage:[NSString stringWithFormat:@"Attempting to connect to room %@", self.roomName]];
}

- (void)setupRemoteView {
    // Creating `TVIVideoView` programmatically
    self.remoteView = [[TVIVideoView alloc] init];
    
    // `TVIVideoView` supports UIViewContentModeScaleToFill, UIViewContentModeScaleAspectFill and UIViewContentModeScaleAspectFit
    // UIViewContentModeScaleAspectFit is the default mode when you create `TVIVideoView` programmatically.
    self.remoteView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat containerWidth = CGRectGetWidth(self.videoScrollView.bounds);
    CGFloat containerHeight = CGRectGetHeight(self.videoScrollView.bounds);
    self.remoteView.frame = CGRectMake(0 * CGRectGetWidth(self.videoScrollView.bounds),
                0,
                containerWidth,
                containerHeight);
    self.remoteView.tag = 1;
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, containerWidth-10, 21)];
    [nameLabel setText:self.remoteParticipant.identity];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setTextAlignment:NSTextAlignmentRight];
    [self.remoteView addSubview:nameLabel];
    
    // add to video container view
    [self.videoScrollView addSubview:self.remoteView];
    
    // set scrollview content width based on number of subscribers connected.
    [self.videoScrollView setContentSize: CGSizeMake(self.videoScrollView.frame.size.width * (1),
                                                     self.videoScrollView.frame.size.height - 18)];
    
    /*[self.cameraView insertSubview:remoteView atIndex:0];
    self.remoteView = remoteView;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.remoteView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.cameraView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0];
    [self.cameraView addConstraint:centerX];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.remoteView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.cameraView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0];
    [self.cameraView addConstraint:centerY];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.remoteView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.cameraView
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1
                                                              constant:0];
    [self.cameraView addConstraint:width];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.remoteView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.cameraView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:0];
    [self.cameraView addConstraint:height];*/
}

- (void)cleanupRemoteParticipant {
    if (self.remoteParticipant) {
        if ([self.remoteParticipant.videoTracks count] > 0) {
            TVIRemoteVideoTrack *videoTrack = self.remoteParticipant.remoteVideoTracks[0].remoteTrack;
            [videoTrack removeRenderer:self.remoteView];
            [self.remoteView removeFromSuperview];
        }
        self.remoteParticipant = nil;
    }
}

- (void)logMessage:(NSString *)msg {
    NSLog(@"%@", msg);
}

- (IBAction)mapSelected:(id)sender {
	[self.btnMap setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:0.0/255.0 blue:13.0/255.0 alpha:1.0]];
    [self.btnInfo setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]];
	[self.btnVideo setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]];
	self.cameraView.hidden = YES;
    self.help24view.hidden = YES;
	self.navigationItem.title = NSLocalizedString(@"Map", @"");;
}

- (IBAction)videoSelected:(id)sender {
	[self.btnVideo setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:0.0/255.0 blue:13.0/255.0 alpha:1.0]];
    [self.btnInfo setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]];
	[self.btnMap setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]];
	self.cameraView.hidden = NO;
    self.help24view.hidden = YES;
	self.navigationItem.title = NSLocalizedString(@"Video call", @"");
}

- (IBAction)infoSelected:(id)sender {
    [self.btnInfo setBackgroundColor:[UIColor colorWithRed:199.0/255.0 green:0.0/255.0 blue:13.0/255.0 alpha:1.0]];
    [self.btnMap setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]];
    [self.btnVideo setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]];
	self.cameraView.hidden = YES;
    self.help24view.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"Action plan", @"");
}

- (IBAction)accept:(id)sender {
	NSString *userName = [AlertySettingsMgr userFullName];
	if ([AlertySettingsMgr isBusinessVersion]) {
		userName = [AlertySettingsMgr userNameServer];
	}
    NSDictionary* parameters = @{ @"id": [NSNumber numberWithInteger:self.alertID], @"name": userName, @"userid" : [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]] };
    [MobileInterface post:ACCEPTCALL_URL body: parameters completion:^(NSDictionary *result, NSString *errorMessage) {
        [self refresh];
        [self connectCall];
    }];
}

- (void) close:(id)sender {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (NSString*) safeString:(id)value {
	if (value == nil) return @"";
	if ([value isKindOfClass:[NSNull class]] ) return @"";
	return [value stringValue];
}

#pragma mark Events

- (IBAction)callHelp24:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Call HELP24", @"")
                                 message:NSLocalizedString(@"Please select a number", @"")
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"HELP24 Sweden", @"")
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                             NSURL *phoneUrl = [NSURL URLWithString:@"tel:020931931"];
                             if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                                 [[UIApplication sharedApplication] openURL:phoneUrl];
                             }
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"+46 771-41 55 55"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 NSURL *phoneUrl = [NSURL URLWithString:@"tel:0046771415555"];
                                 if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                                     [[UIApplication sharedApplication] openURL:phoneUrl];
                                 }
                             }];
    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (IBAction)callSOS24:(id)sender {
    NSString *phNo = @"112";
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel:%@",phNo]];
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
}

- (IBAction)centerPosition:(id)sender {
	if (self.annotation) {
        [self.mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
	}
}

#pragma mark - Incoming alert

- (IBAction)openAlert:(id)sender {
    [AudioPlayback2 stop];
    [self resetAVSession];
    self.incomingAlertView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self showAlert];
}

- (IBAction)declineAlert:(id)sender {
    [AudioPlayback2 stop];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TVIRoomDelegate

- (void)didConnectToRoom:(TVIRoom *)room {
    // At the moment, this example only supports rendering one Participant at a time.
    
    [self logMessage:[NSString stringWithFormat:@"Connected to room %@ as %@", room.name, room.localParticipant.identity]];
    
    for (TVIRemoteParticipant* participant in room.remoteParticipants) {
        if ([participant.identity isEqualToString:self.alertUserName]) {
            self.remoteParticipant = participant;
            self.remoteParticipant.delegate = self;
            break;
        }
    }
    
    [self.converstationController.view removeFromSuperview];
    self.converstationController = [[ConverstationController alloc] initWithNibName:@"ConverstationController" bundle:nil];
    self.converstationController.localDataTrack = self.localDataTrack;
    [self.cameraView addSubview:self.converstationController.view];
    CGRect frame = self.cameraView.bounds;
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
    if (!self.remoteParticipant) {
        if ([participant.identity isEqualToString:self.alertUserName]) {
            self.remoteParticipant = participant;
            self.remoteParticipant.delegate = self;
        }
    }
    [self logMessage:[NSString stringWithFormat:@"Participant %@ connected with %lu audio and %lu video tracks",
                      participant.identity,
                      (unsigned long)[participant.audioTracks count],
                      (unsigned long)[participant.videoTracks count]]];
}

- (void)room:(TVIRoom *)room participantDidDisconnect:(TVIRemoteParticipant *)participant {
    if (self.remoteParticipant == participant) {
        [self cleanupRemoteParticipant];
        //self.previewView.hidden = YES;
        //self.statusTitle.text = self.recipient;
        //self.statusSubtitle.text = NSLocalizedString(@"ended the call", @"");
        //[self performSelector:@selector(endCall:) withObject:nil afterDelay:5.0];
    }
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
    
    if (self.remoteParticipant == participant) {
        [self setupRemoteView];
        [videoTrack addRenderer:self.remoteView];
    }
}

- (void)didUnsubscribeFromVideoTrack:(TVIRemoteVideoTrack *)videoTrack publication:(TVIRemoteVideoTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {
    
    // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
    // remote Participant's video.
    
    [self logMessage:[NSString stringWithFormat:@"Unsubscribed from %@ video track for Participant %@",
                      publication.trackName, participant.identity]];
    
    if (self.remoteParticipant == participant) {
        [videoTrack removeRenderer:self.remoteView];
        [self.remoteView removeFromSuperview];
    }
    
    //self.converstationController.darkMode = self.room.remoteParticipants.count == 0;
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

- (void)didSubscribeToDataTrack:(TVIRemoteDataTrack *)dataTrack publication:(TVIRemoteDataTrackPublication *)publication forParticipant:(TVIRemoteParticipant *)participant {

    dataTrack.delegate = self.converstationController;
    
    [self.converstationController.participants setObject:participant forKey:dataTrack.sid];
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

#pragma mark - TVIVideoViewDelegate

- (void)videoView:(TVIVideoView *)view videoDimensionsDidChange:(CMVideoDimensions)dimensions {
    NSLog(@"Dimensions changed to: %d x %d", dimensions.width, dimensions.height);
    [self.cameraView setNeedsLayout];
}

#pragma mark - TVICameraSourceDelegate

/*- (void)cameraCapturer:(TVICameraCapturer *)capturer didStartWithSource:(TVICameraCaptureSource)source {
    self.previewView.mirror = (source == TVICameraCaptureSourceFrontCamera);
}*/

#pragma mark - MGLMapViewDelegate

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    self.mapView.showsUserLocation = NO;
    
    [self refresh];
        
    self.mapBoxTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            NSArray<MGLStyleLayer*>* layers = self.mapView.style.layers;
            for (MGLStyleLayer* layer in layers) {
                layer.visible = YES;
            }
        }];
    }];
}

@end
