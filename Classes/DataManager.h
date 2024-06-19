//
//  DataManager.h (SINGLETON)
//  ShareRoutes
//
//  Created by alfa on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SynthesizeSingleton.h"
#import "SynchronizeService.h"
#import "MyLocation.h"
#import "config.h"

@class Contact;

@interface DataManager : NSObject {
	id __weak _delegate;
	
	MyLocation *_lastLocation;
	CLLocationCoordinate2D _currentLocation;
	CLLocationCoordinate2D _chosenLocation;
	
	SynchronizeService *_synchService;
	NSTimer *_syncTimer;
	NSMutableArray *_friendsToNotify;
	BOOL _successfulFirstSync;
	
	//user settings
	NSString *_userName;
	//NSString *_pincode;
    NSString *_alertMessage;
	
	NSMutableData			*_responseData;
	NSString				*_tmpUserName;
	NSString				*_tmpUserPIN;
	
	NSMutableArray* _locations;
}

@property (nonatomic, weak) id delegate;

@property (nonatomic) BOOL newRoute;
@property (nonatomic) BOOL sos;
@property (nonatomic) BOOL enableHeadset;
@property (nonatomic) BOOL followMe;

@property (nonatomic, assign) BOOL subscribing;
@property (nonatomic, assign) BOOL successfulFirstSync;

@property (nonatomic, strong) MyLocation *lastLocation;
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, retain) NSString *pincode;
@property (nonatomic, strong) NSString *alertMessage;
@property (nonatomic, strong) NSMutableArray *friendsToNotify;
@property (nonatomic, assign) CLLocationCoordinate2D chosenLocation;
@property (nonatomic, strong) NSString	*tmpUserName;
@property (nonatomic, strong) NSString	*tmpUserPIN;
@property (nonatomic, strong) NSMutableArray *locations;

@property (nonatomic, assign) BOOL underSosMode;
@property (nonatomic, assign) int alertId;
@property (nonatomic, strong) NSString* voice;
@property (nonatomic, strong) NSString* voicePhone;

- (void) startSynchronization;
- (void) reloadFriends:(BOOL)fromWeb;
- (void) restartSynchtimer;
- (void) registerNewBizUser:(NSString *)userId pincode:(NSString *)pincode;
- (void) changePassword:(NSString *)newPassword;
- (void) storeUserSettings:(NSString *)fname pin:(NSString*)pin;
- (void) getUserSettings;

- (void) registerMyLocation:(MyLocation *) location;
- (void) registerCurrentLocation:(CLLocationCoordinate2D) locationCoordinate;
- (NSString *) lookupFriendNameByPhone:(NSString *)phone;
+ (UIImage*) lookupFriendNameByPhone:(Contact*) contact orPhone:(NSString*)phoneNr;
- (void) sendPhoneNumbers:(int)source;
- (void) stopSOSMode;
- (void) sendSosInvitationTo:(NSString *)phone Name:(NSString *)name Position:(long)pos;

+ (DataManager *)sharedDataManager;

- (NSURLSessionTask *) getMaps;

@end

@interface NSObject ()

- (void) updateDataFinishedEvent;
- (void) userNotRegisteredEvent;
- (void) connectionErrorEvent;
- (void) reloadFriendPhones;
- (void) reloadCredits;
- (void) registrationSuccededEvent:(bool)settingsChanged;
- (void) registrationErrorWithCodeEvent:(int)errorCode;

@end

