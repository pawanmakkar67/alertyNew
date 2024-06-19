//
//  SynchronizeService.h
//  ShareRoutes
//
//  Created by alfa on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SynchronizeService : NSObject {
	id __weak _delegate;
	
	NSMutableData	*_responseData;

	BOOL _underRequest;
	BOOL _responseHandled;
	BOOL needProcessResponse;
	NSURLConnection *_syncRequest;
	
	NSTimer *_timeout;
}

#pragma mark Public Methods

- (void) startSynchronization:(BOOL)empty;
- (void) registerNewBizUser:(NSString *)userId pincode:(NSString *)pincode;
- (void) changePassword:(NSString *)newPassword;
- (void) storeUserSettings:(NSString *)fname pin:(NSString*)pin;
- (void) stopSOSMode;
- (void) sendPhoneNumbers:(NSMutableArray *)friendsToNotify withSource:(int)source;
- (void) sendSosInvitationTo:(NSString *)phone Name:(NSString *)name Position:(long)pos;
- (void) setIndoorLocation;

#pragma mark Private Methods

- (NSString*) getDeviceID;
- (void) raiseCommunicationErrorEvent;
- (void) startRequest:(NSString*)postParameters requestUrl:(NSString*)url ProcessResponse:(BOOL)processResponse;
- (void) processResponse;
- (NSMutableData *) getResponseDataBytes:(unsigned long)length;
- (NSString *) charToNSString:(const char *)sourceString length:(int)n;
- (NSString *) getNotificationMessage:(NSString *)friendName;
- (NSString *)parseString:(const char *)data offset:(int)offset length:(int)length;

#pragma mark Properties

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableData *responseData;


@end

#pragma mark Synch Delegates

//@protocol SKSynchronizeDelegate <NSObject>
@interface NSObject (SKSynchronizeDelegate) 
//@optional
- (void) synchDataFinishedEvent:(SynchronizeService *)sender;
- (void) synchUserNotRegisteredEvent;
- (void) synchUserRegisteredEvent:(bool)settingsChanged;
- (void) synchErrorEvent;
- (void) synchReloadFriendPhones;
- (void) synchRegistrationErrorWithCodeEvent:(int)errorCode;
- (void) synchReloadCredits;
- (void) synchReloadWifiAps;

@end

