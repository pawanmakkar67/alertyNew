//
//  ReachabilityManager.h
//
//  Created by Bence Balint on 11/09/10.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_REACHABILITY
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractSingleton.h"
#if HAVE_CUSTOM_ALERT
#import "AlertView.h"
#endif
#import "Reachability30.h"


@interface ReachabilityManager : AbstractSingleton
{
	Reachability *_reachability;
	BOOL _networkErrorReported;
#if HAVE_CUSTOM_ALERT
	AlertView *_networkAlert;
#else
	UIAlertView *_networkAlert;
#endif
	NSString *_networkAlertTitle;
	NSString *_networkAlertMessage;
}

@property (nonatomic,retain) Reachability *reachability;
@property (nonatomic,assign,getter=wasNetworkErrorReported) BOOL networkErrorReported;
@property (nonatomic,retain) NSString *networkAlertTitle;
@property (nonatomic,retain) NSString *networkAlertMessage;

+ (ReachabilityManager*) instance;

+ (NetworkStatus) currentReachabilityStatus;
+ (BOOL) checkNetwork;
+ (BOOL) checkNetworkAndShowErrorIfNeeded;
+ (BOOL) checkNetworkAndShowErrorIfNotReported;
+ (BOOL) reportNetworkErrorIfNotReported;
+ (void) reportNetworkError;

@end
#endif
