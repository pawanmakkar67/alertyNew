//
//  DataManager.m
//  ShareRoutes
//
//  Created by alfa on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "AlertyAppDelegate.h"
#import "MainController.h"
#import "AlertyDBMgr.h"
#import "AlertySettingsMgr.h"
#import "IndoorMap.h"
#import "IndoorLocationingViewController.h"
@import Contacts;

@implementation DataManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DataManager);

@synthesize newRoute = _newRoute, sos = _sos, followMe = _followMe;
@synthesize lastLocation = _lastLocation;
@synthesize currentLocation = _currentLocation;
@synthesize userName = _userName;
@synthesize enableHeadset = _enableHeadset;
@synthesize friendsToNotify = _friendsToNotify;
@synthesize alertMessage = _alertMessage;
@synthesize chosenLocation = _chosenLocation;
@synthesize subscribing = _subscribing;
@synthesize tmpUserName = _tmpUserName;
@synthesize tmpUserPIN = _tmpUserPIN;
@synthesize delegate = _delegate;
@synthesize underSosMode = _underSosMode;
@synthesize successfulFirstSync = _successfulFirstSync;
@synthesize locations = _locations;

- (id) init 
{
	if ((self = [super init])) {

		self.newRoute = FALSE;
		self.sos = FALSE;
		self.lastLocation = nil;
		self.subscribing = NO;
		self.successfulFirstSync = NO;
		self.locations = [NSMutableArray array];
		
		_synchService = [[SynchronizeService alloc] init];
		[_synchService setDelegate:self];
		_friendsToNotify = [[NSMutableArray alloc] initWithCapacity:3];
	}
	return self;
}

#pragma mark Synchronization Events

/*   SYNCHRONIZATION EVENTS (CallBacks)   */

- (void) synchErrorEvent
{
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(connectionErrorEvent)]) {
		[self.delegate connectionErrorEvent];
	}
}

-(void) synchDataFinishedEvent:(SynchronizeService*) sender
{	
	self.successfulFirstSync = YES;
	[self getUserSettings];
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(updateDataFinishedEvent)]) {
		[self.delegate updateDataFinishedEvent];
	}
	
	if ( self.sos || self.followMe)
	{
		_syncTimer = [NSTimer scheduledTimerWithTimeInterval:SOS_SYNC_INTERVAL target:self selector:@selector(startSynchronization) userInfo:nil repeats:NO];
	}
}

-(void) synchReloadFriendPhones
{
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(reloadFriendPhones)]) {
		[self.delegate reloadFriendPhones];
	}
}

-(void) synchReloadCredits
{
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(reloadCredits)]) {
		[self.delegate reloadCredits];
	}
}

-(void) synchReloadWifiAps
{
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(reloadWifiAps)]) {
		[self.delegate reloadWifiAps];
	}
}

- (void) synchRegistrationErrorWithCodeEvent:(int)errorCode;
{
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(registrationErrorWithCodeEvent:)]) {
		[self.delegate registrationErrorWithCodeEvent:errorCode];
	}
}

- (void) synchUserNotRegisteredEvent
{
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(userNotRegisteredEvent)]) {
		[self.delegate userNotRegisteredEvent];
	}
}

- (void) synchUserRegisteredEvent:(bool)settingsChanged;
{
	[self getUserSettings];
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(registrationSuccededEvent:)]) {
		[self.delegate registrationSuccededEvent:settingsChanged];
	}
}

/*  END OF SYNCHRONIZATION EVENTS (CallBacks)   */

#pragma mark - Public Methods

-(void) startSynchronization
{
	[_syncTimer invalidate];
	_syncTimer = nil;

	[_synchService startSynchronization:FALSE];
}

- (void)reloadFriends:(BOOL)fromWeb
{
	if( fromWeb == TRUE )
	{
		[_synchService startSynchronization:TRUE];
	}
	else 
	{
		if ([_friendsToNotify count] > 0) {
			[_friendsToNotify removeAllObjects];
		}
		
		NSArray *contacts = [[AlertyDBMgr sharedAlertyDBMgr] getAllContactsInActiveGroup];
		for( Contact *contact in contacts ) {
			[_friendsToNotify addObject:contact];
		}
		if ([AlertySettingsMgr isBusinessVersion]) {
			NSArray *bizContacts = [[[AlertyDBMgr sharedAlertyDBMgr] getEnterpriseGroup].contacts allObjects];
			for( Contact *contact in bizContacts ) {
				[_friendsToNotify addObject:contact];
			}
		}
	}
}

-(void) restartSynchtimer
{
	_syncTimer = [NSTimer scheduledTimerWithTimeInterval:SOS_SYNC_INTERVAL target:self selector:@selector(startSynchronization) userInfo:nil repeats:NO];
}

- (void) registerNewBizUser:(NSString *)userId pincode:(NSString *)pincode
{
	[_synchService registerNewBizUser:userId pincode:pincode];
}

- (void) changePassword:(NSString *)newPassword
{
	[_synchService changePassword:newPassword];
}

- (void) sendPhoneNumbers:(int)source
{
	[self reloadFriends:FALSE];
	[_synchService sendPhoneNumbers:_friendsToNotify withSource:source];
}

- (void) stopSOSMode
{
	[_synchService stopSOSMode];
}

- (void) sendSosInvitationTo:(NSString *)phone Name:(NSString *)name Position:(long)pos
{
	[_synchService sendSosInvitationTo:phone Name:name Position:pos];
}

- (void) registerCurrentLocation:(CLLocationCoordinate2D) locationCoordinate
{
	self.currentLocation = locationCoordinate;
}

- (void) storeUserSettings:(NSString *)fname pin:(NSString*)pin {
	SynchronizeService* service = [[SynchronizeService alloc] init];
    [service storeUserSettings:fname pin:pin];
}

- (void) registerMyLocation:(MyLocation *) location
{
	if (self.lastLocation == nil) {
		MyLocation *loc = [[MyLocation alloc] init];
		self.lastLocation = loc;
	}
	
	self.lastLocation.latitude = location.latitude;
	self.lastLocation.longitude = location.longitude;
	self.lastLocation.accuracy = location.accuracy;
	self.lastLocation.altitude = location.altitude;
	self.lastLocation.heading = location.heading;
	self.lastLocation.speed = location.speed;
	self.lastLocation.timestamp = location.timestamp;
	self.lastLocation.sos = location.sos;
	self.lastLocation.wifiapname = location.wifiapname;
	self.lastLocation.wifiapbssid = location.wifiapbssid;
	self.lastLocation.distance = location.distance;
	self.lastLocation.duration = location.duration;
    self.lastLocation.mapId = location.mapId;
	
	[self.locations addObject:location];
	
	if (self.locations.count > 20) {
		[self.locations removeObjectAtIndex:0];
	}
}

-(NSString *) lookupFriendNameByPhone:(NSString *)phone {
    CNContactStore *store = [[CNContactStore alloc] init];
    
    __block BOOL accessGranted = NO;
    
    // we're on iOS 6
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        accessGranted = granted;
        dispatch_semaphore_signal(sema);
    }];
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //dispatch_release(sema);
    
    NSMutableArray *contacts = [NSMutableArray array];

    NSError *fetchError;
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey]];

    BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
       [contacts addObject:contact];
    }];
    
    NSString *name = nil;
    if (!success || contacts.count == 0)
    {
        return nil;
    }
    
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    
    for (CNContact *contact in contacts) {
        
        BOOL hasFirstName = FALSE;
        for (CNLabeledValue* labeledValue in contact.phoneNumbers) {
            
            if ([labeledValue.value isKindOfClass:CNPhoneNumber.class]) {
                NSString *phoneNumberValue = ((CNPhoneNumber *)labeledValue.value).stringValue;
                NSString* number = [phoneNumberValue stringByReplacingOccurrencesOfString:@" " withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"+" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@"(" withString:@""];
                number = [number stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                if( [phone isEqualToString:number])
                {
                    if (contact.familyName == nil && contact.givenName == nil) {
                        name = nil;
                    }
                    else {
                        if (contact.givenName != nil) {
                            name = contact.givenName;
                            hasFirstName = YES;
                        }
                    
                        if (contact.familyName != nil) {
                            if (hasFirstName == YES) {
                                name = [[name stringByAppendingString:@" "] stringByAppendingString: contact.familyName];
                            }
                            else {
                                name = contact.familyName;
                            }
                        }
                    }
                    return name;
                }
            }
        }
    }
    return nil;
}

+ (UIImage*) lookupFriendNameByPhone:(Contact*) contact orPhone:(NSString*)phoneNr {
    
    if (contact == nil && phoneNr.length == 0) {
        return nil;
    }

    UIImage* image = nil;
    
    CNContactStore *store = [[CNContactStore alloc] init];
    NSPredicate *predicate = [CNContact predicateForContactsMatchingPhoneNumber:[CNPhoneNumber phoneNumberWithStringValue:contact ? contact.phone : phoneNr]];
    
    NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactRelationsKey, CNContactThumbnailImageDataKey];
    NSError *error;
    NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
    if (error) {
        NSLog(@"error fetching contacts %@", error);
    } else {
        for (CNContact *c in cnContacts) {
            if (!image) {
                NSString* initials = @"";
                if (c.givenName.length) {
                    initials = [c.givenName substringToIndex:1];
                }
                if (c.familyName.length) {
                    initials = [initials stringByAppendingString:[c.familyName substringToIndex:1]];
                }
                if (initials.length) {
                    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                    style.alignment = NSTextAlignmentCenter;
                    NSDictionary<NSAttributedStringKey, id> * attributes = @{ NSForegroundColorAttributeName: [UIColor colorNamed:@"color_background"], NSFontAttributeName: [UIFont boldSystemFontOfSize:28.0], NSParagraphStyleAttributeName: style};
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(60.0, 60.0), NO, 0);
                    [initials drawInRect:CGRectMake(0, 12, 60.0, 36.0) withAttributes:attributes];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                }
            }
            UIImage* thumbnail = [UIImage imageWithData:c.thumbnailImageData];
            if (thumbnail) {
                image = thumbnail;
            }
            if (contact && !contact.name.length) {
                contact.name = c.givenName;
                if (contact.name.length && c.familyName.length) {
                    contact.name = [contact.name stringByAppendingFormat:@" %@", c.familyName];
                }
            }
        }
    }
    return image;
}

- (void) getUserSettings
{
	self.userName = [AlertySettingsMgr userName];
	self.enableHeadset = [AlertySettingsMgr headsetEnabled];
    self.alertMessage = [AlertySettingsMgr alertMessage];
}

- (NSURLSessionTask *) getMaps {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:MAPS_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSString *parameters = [NSString stringWithFormat:@"id=%ld&pin=%@&userid=%ld", (long)AlertySettingsMgr.userID, AlertySettingsMgr.userPIN, (long)[AlertySettingsMgr userID]];

    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            return;
        }
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                return;
            }
        }
        NSError *jsonError = nil;
        NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        if (jsonError != nil) {
            return;
        }
        
        //NSMutableArray* maps = [NSMutableArray array];
        [AlertyDBMgr.sharedAlertyDBMgr deleteAllMaps];
        for (NSInteger i=0; i<jsonArray.count; i++) {
            IndoorMap* map = [[IndoorMap alloc] initWithDictionary:jsonArray[i]];
            if (map) [AlertyDBMgr.sharedAlertyDBMgr addMap:map];
        }
    }];
    [dataTask resume];
    return dataTask;
}


@end

