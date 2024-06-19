//
//  GWManager.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AbstractSingleton.h"
#import "GWCall.h"
#if HAVE_CUSTOM_ALERT
#import "AlertView.h"
#endif


@interface GWManager : AbstractSingleton <GWCallDelegate>
{
	NSMutableArray *_calls;
#if HAVE_CUSTOM_ALERT
	AlertView *_lastAlert;
#else
	UIAlertView *_lastAlert;
#endif
	NSMutableArray *_loadingIndicators;
	
	NSData *_clientCertificate;
	NSMutableArray *_serverCertificateHashes;
}

+ (GWManager*) instance;

// management methods
+ (void) registerCall:(GWCall*)gwCall;
+ (void) startLoadingIndicatorForNonRetainedObject:(id)object;
+ (void) stopLoadingIndicatorForNonRetainedObject:(id)object;
+ (void) startLoadingIndicatorWithIdentifier:(id)identifier;
+ (void) stopLoadingIndicatorWithIdentifier:(id)identifier;

// connection security
+ (BOOL) hasClientCertificate;
+ (NSData*) clientCertificate;
+ (void) setClientCertificate:(NSData*)clientCertificate;
+ (BOOL) hasServerCertificateHash;
+ (NSArray*) serverCertificateHashes;
+ (void) addServerCertificateHash:(NSData*)serverCertificateHash;
+ (void) removeServerCertificateHash:(NSData*)serverCertificateHash;

@end
