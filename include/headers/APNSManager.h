//
//  APNSManager.h
//
//  Created by Bence Balint on 10/06/10.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AbstractSingleton.h"
#import "GWCall.h"


@interface APNSManager : AbstractSingleton <GWCallDelegate,
											UIAlertViewDelegate>
{
	NSData *_token;
	GWCall *_subscribeCall;
	GWCall *_unsubscribeCall;
	NSDictionary *_lastPN;
	BOOL _startingPN;
	
	UIAlertView *_alertView;
}

@property (readwrite,retain) NSDictionary *lastPN;
@property (readwrite,assign,getter=isStartingPN) BOOL startingPN;

+ (APNSManager*) instance;

// override to deal with the APNS message
+ (void) openItem:(NSDictionary*)notification;

+ (BOOL) setDeviceToken:(NSData*)token;
+ (NSData*) deviceToken;
+ (BOOL) tryRegisterFor:(UIRemoteNotificationType)types;
+ (BOOL) tryUnregister;
+ (BOOL) trySubscribeToAPNS:(NSString*)baseURL;
+ (BOOL) tryUnsubscribeFromAPNS:(NSString*)baseURL;
+ (void) processStarterPN:(NSDictionary*)notification;
+ (void) processPN:(NSDictionary*)notification;

+ (void) saveState;
+ (void) loadState;
+ (void) clearState;
+ (void) reset;

// methods to override
- (NSString*) registerTokenURL;
- (NSString*) unregisterTokenURL;

@end


//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//	// process starter PN
//	if (launchOptions.count) {
//		[AppsAPNS processStarterPN:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
//	}
//	// register for APNS
//	[AppsAPNS tryRegisterFor:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//}
//
//#pragma mark -
//#pragma mark APNS callbacks
//
//- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
//	cmdlogtext(@"%@", [devToken hex]);
//	[APNSManager setDeviceToken:devToken];
//	[APNSManager trySubscribeToAPNS];
//}
//
//- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
//	// erro.code == 3010		- not supported in Simulator
//	cmdlogerr(app, err);
//	[APNSManager setDeviceToken:nil];
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//	cmdlogtext(@"%@", [userInfo description]);
//	if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
//		[APNSManager processPN:userInfo];
//	}
//	else {
//		[APNSManager processStarterPN:userInfo];
//	}
//}
//
