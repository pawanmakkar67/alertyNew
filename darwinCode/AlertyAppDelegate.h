//
//  AlertyAppDelegate.h
//  Alerty
//
//  Created by moni on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertyViewController.h"
#import "MainController.h"
#import "ManDownMgr.h"
#import <PushKit/PushKit.h>
#import <fliclib/fliclib.h>
#import <flic2lib/flic2lib.h>
@class ContextManager;
//#define SCL_APP_ID @"cfe4b5bb-ba39-4e51-808a-f9dcaad86341"
//#define SCL_APP_SECRET @"bf6b88da-3c46-46be-bfdb-b3135819183a"

// with Flic app
//#define SCL_APP_ID @"6fbc34e5-88d5-40af-9cd4-626725a89027"
//#define SCL_APP_SECRET @"baf8fead-7c23-4eed-ae1e-a419c6a39b31"

// custom buttons
#define SCL_APP_ID @"95ce93e3-553b-4d83-985a-d09d61e35b02"
#define SCL_APP_SECRET @"f65cb225-59a4-4791-b376-fe7b462960b4"

#define PROXIMIIO_TOKEN @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImlzcyI6ImM4OTA0YzkyLTlmN2MtNGE3Yy1iZDZjLTZiMjBiMTczZDEwZSIsInR5cGUiOiJhcHBsaWNhdGlvbiIsImFwcGxpY2F0aW9uX2lkIjoiNDg2MWJlOTAtMzc4NS00YWRmLWFiNGQtMWYxYmI1MTMzNTRjIn0.4HfcMEOfVHRK41kj4j0tomnQIAwICIKeS2Sz8J4gWV8"

#import <CocoaLumberjack/CocoaLumberjack.h>

#ifdef ALERTY
#define REDESIGN_COLOR_BUTTON [UIColor colorWithRed:40.0/255.0 green:81.0/255.0 blue:250.0/255.0 alpha:1.0]

#define REDESIGN_COLOR_NAVIGATIONBAR [UIColor colorWithRed:44.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0]

#define REDESIGN_COLOR_BLACK [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:12.0/255.0 alpha:1.0]

#define REDESIGN_COLOR_RED [UIColor colorWithRed:200.0/255.0 green:89.0/255.0 blue:79.0/255.0 alpha:1.0]

#define REDESIGN_COLOR_CANCEL [UIColor colorWithRed:44.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0]
#define REDESIGN_COLOR_GREEN [UIColor colorWithRed:58.0/255.0 green:200.0/255.0 blue:127.0/255.0 alpha:1.0]





  #define COLOR_ACCENT [UIColor colorWithRed:33.0/255.0 green:150.0/255.0 blue:243.0/255.0 alpha:1.0]
  #define COLOR_INACTIVE_BORDER [UIColor colorWithRed:0.7255 green:0.7569 blue:0.7922 alpha:1.0]
  #define COLOR_GRAY_CURSOR  [UIColor colorWithRed:0.349 green:0.3725 blue:0.4314 alpha:1.0]
  #define COLOR_TEXT [UIColor colorWithRed:0.2785 green:0.2982 blue:0.3559 alpha:1.0]
  #define COLOR_NAVIGATIONBAR [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]
  #define SHOW_SEND_EMAIL
#elif defined OPUS

  #define REDESIGN_COLOR_BUTTON [UIColor colorWithRed:40.0/255.0 green:81.0/255.0 blue:250.0/255.0 alpha:1.0]
  #define REDESIGN_COLOR_NAVIGATIONBAR [UIColor colorWithRed:0.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]
  #define REDESIGN_COLOR_BLACK [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:12.0/255.0 alpha:1.0]
  #define REDESIGN_COLOR_RED [UIColor colorWithRed:200.0/255.0 green:89.0/255.0 blue:79.0/255.0 alpha:1.0]
  #define REDESIGN_COLOR_CANCEL [UIColor colorWithRed:0.7255 green:0.7569 blue:0.7922 alpha:1.0]
  #define REDESIGN_COLOR_GREEN [UIColor colorWithRed:0.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]

  #define COLOR_ACCENT [UIColor colorWithRed:0.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]
  #define COLOR_INACTIVE_BORDER [UIColor colorWithRed:0.7255 green:0.7569 blue:0.7922 alpha:1.0]
  #define COLOR_GRAY_CURSOR  [UIColor colorWithRed:0.349 green:0.3725 blue:0.4314 alpha:1.0]
  #define COLOR_TEXT [UIColor colorWithRed:0.2785 green:0.2982 blue:0.3559 alpha:1.0]
  #define COLOR_NAVIGATIONBAR [UIColor colorWithRed:0.0/255.0 green:90.0/255.0 blue:160.0/255.0 alpha:1.0]
#elif defined SAKERHETSAPPEN
  #define COLOR_ACCENT [UIColor colorWithRed:232.0/255.0 green:119.0/255.0 blue:34.0/255.0 alpha:1.0]
  #define COLOR_INACTIVE_BORDER [UIColor colorWithRed:0.7255 green:0.7569 blue:0.7922 alpha:1.0]
  #define COLOR_GRAY_CURSOR  [UIColor colorWithRed:0.349 green:0.3725 blue:0.4314 alpha:1.0]
  #define COLOR_TEXT [UIColor colorWithRed:0.2785 green:0.2982 blue:0.3559 alpha:1.0]
  #define COLOR_NAVIGATIONBAR [UIColor colorWithRed:136.0/255.0 green:139.0/255.0 blue:141.0/255.0 alpha:1.0]
#else
  #define COLOR_ACCENT [UIColor colorWithRed:105.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]
  #define COLOR_INACTIVE_BORDER [UIColor colorWithRed:0.7255 green:0.7569 blue:0.7922 alpha:1.0]
  #define COLOR_GRAY_CURSOR  [UIColor colorWithRed:0.349 green:0.3725 blue:0.4314 alpha:1.0]
  #define COLOR_TEXT [UIColor colorWithRed:0.2785 green:0.2982 blue:0.3559 alpha:1.0]
  #define COLOR_NAVIGATIONBAR [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]
#endif
#define COLOR_GREEN [UIColor colorWithRed:76.0/255.0 green:218.0/255.0 blue:100.0/255.0 alpha:1.0]

#define COLOR_RED [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:17.0/255.0 alpha:1.0]

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@class AlertInfo;
@interface AlertyAppDelegate : NSObject <UIApplicationDelegate,
						ManDownMgrDelegate,
						CLLocationManagerDelegate,
						UIAlertViewDelegate,
                        SCLFlicManagerDelegate,
                        SCLFlicButtonDelegate,
                        FLICButtonDelegate>

@property (nonatomic, strong) IBOutlet UIWindow					*window;
@property (nonatomic, strong) IBOutlet MainController			*mainController;
@property (nonatomic, assign) BOOL								inbackground;
@property (nonatomic, assign) int								daysLeft;
@property (nonatomic, assign) BOOL								showUserSettings;
@property (nonatomic, assign) BOOL								showIndoorPositioning;
@property (nonatomic, strong) GWCall*							alertInfoCall;
@property (nonatomic, strong) id<SCLFlicButtonDelegate>         buttonDelegate;
@property (nonatomic, assign) UIBackgroundTaskIdentifier        pingTaskIdentifier;
@property (nonatomic, strong) ContextManager*                            contextM;

////extern ContextManager* contextM;
//
//;
//+ (ContextManager*)contextM;

+ (AlertyAppDelegate*)sharedAppDelegate;
+ (NSString*) country;
+ (NSString*) language;
+ (NSString*) locale;
+ (NSURL *) applicationDocumentsDirectory;

+ (UILocalNotification*) showLocalNotification:(NSString *)body action:(NSString *)action userInfo:(NSDictionary*)userInfo;

- (void) sendTokenToServer:(NSString *)tokenString;
- (void) showRemoteNotification:(NSDictionary *)userInfo;
- (void) registerNotifications;

- (void) startManDown;
- (void) stopManDown;
- (void) stopManDownForTest;

- (void) startUpdatingLocation;
- (void) startSignificantLocationService;
- (void) stopAllLocation;
- (void) networkChanged:(NSNotification *)notification;

//- (double) metersBetweenCoordinates:(CLLocationCoordinate2D)c1 :(CLLocationCoordinate2D)c2;

- (void) showIncomingCall:(NSDictionary*)userInfo;
- (void) answerIncomingCall:(NSDictionary*)userInfo;
- (void) rejectCall:(NSDictionary*)userInfo;
- (void) showAlert:(AlertInfo*)alert openAlert:(BOOL)openAlert;
- (void) showAlertWithId: (int)alertId message:(NSString*) message user:(int)alertUserId roomName:(NSString*)roomName token:(NSString*)token userName:(NSString*)userName;

- (void) composeEmailWithDebugAttachment;

@end
