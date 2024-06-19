//
//  SynchronizeService.m
//  ShareRoutes
//
//  Created by alfa on 12/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SynchronizeService.h"
#import "DataManager.h"
#import "NSExtensions.h"
#import "config.h"
#import "WifiApMgr.h"
#import "AlertyDBMgr.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"
#import "MobileInterface.h"


@interface SynchronizeService ()
- (int) getIntFromData:(const unsigned char *)data offset:(int *)offset;
- (NSString *)getStringFromData:(const unsigned char *)data offset:(int *)offset;

@property (nonatomic) UIBackgroundTaskIdentifier smsTask;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

@end

@implementation SynchronizeService

@synthesize responseData = _responseData;
@synthesize delegate = _delegate;

- (id)init {
	_underRequest = FALSE;
	
	if ((self = [super init])) {
	}
	return self;
}

- (void)dealloc {
	
	[_timeout invalidate];
	_timeout = nil;
    
}

-(NSString*) getDeviceID
{
	return DEVICE_ID;
}

#pragma mark Public Methods

- (void)startSynchronization:(BOOL)empty
{
	if (_underRequest) return;
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground && ![AlertySettingsMgr userPIN].length) {
        DDLogInfo(@"startSynchronization PIN NULL");
        return;
    }
	
	NSString *post;

	int sosIndicator = [DataManager sharedDataManager].sos == TRUE ? 1 : 0;
	
	// override location if one available through indoor-locationing
	[self setIndoorLocation];
	
	if ([DataManager sharedDataManager].lastLocation == nil || empty == TRUE) {
		post = [NSString stringWithFormat:@"&imei=%@&distance=0&duration=0&sos=%d&battery=%.0f", [self getDeviceID], sosIndicator, [self batteryLevel]];
		if ([AlertySettingsMgr isBusinessVersion]) {
			//if( [AlertySettingsMgr businessType] == kBusinessTypeSubscription ) {
			//	post = [post stringByAppendingString:@"&type=business&getwifiaps=1&subtype=subs"];
			//}
			//else {
				post = [post stringByAppendingString:@"&type=business&getwifiaps=1&subtype=norm"];
			//}
		}
		else {
			post = [post stringByAppendingString:@"&type=personal"];
		}
	}
	else {
		MyLocation *lastLoc = [DataManager sharedDataManager].lastLocation;
		long duration = lastLoc.duration;
		int newRoute = [DataManager sharedDataManager].newRoute == TRUE ? 1 : 0;
		if (newRoute == TRUE) {
			[DataManager sharedDataManager].newRoute = FALSE;
		}
		int distance = round(lastLoc.distance);
		NSString *parts = [NSString stringWithFormat:@"&newRoute=%i&duration=%ld&sos=%d&battery=%.0f", newRoute, duration, sosIndicator, [self batteryLevel]];
		post = [NSString stringWithFormat:@"&imei=%@&distance=%d", [self getDeviceID], distance];
		
		NSString* data = @"";
		for (int i=0; i<[DataManager sharedDataManager].locations.count; i++) {
			MyLocation* location = [[DataManager sharedDataManager].locations objectAtIndex:i];
            if (location.latitude != 0.0 && location.longitude != 0.0) {
                NSString* pos = [NSString stringWithFormat:@"%0.14f,%0.14f,%ld,%ld,%ld,%ld,%0.0f",
                                 location.latitude, location.longitude, (long)location.speed, (long)location.altitude,
                                 (long)location.heading, (long)location.accuracy, round(location.timestamp)];
                if (data.length>0) data = [data stringByAppendingString:@"|"];
                data = [data stringByAppendingString:pos];
            }
		}
		NSLog(@"sync: %@", data);
		[[DataManager sharedDataManager].locations removeAllObjects];
		post = [post stringByAppendingFormat:@"&data=%@", data];
		post = [post stringByAppendingString:parts];
		post = [post stringByAppendingString:([AlertySettingsMgr isBusinessVersion] ? @"&type=business" : @"&type=personal")];
	
        NSString* country = [[DataManager sharedDataManager].lastLocation.userCountry stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		if (country.length) {
			post = [NSString stringWithFormat:@"%@&co=%@", post, [country urlEncodedString]];
		}
        NSString* city = [[DataManager sharedDataManager].lastLocation.userCity stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (city.length) {
            post = [NSString stringWithFormat:@"%@&c=%@", post, [city urlEncodedString]];
        }
        NSString* address = [[DataManager sharedDataManager].lastLocation.userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (address.length) {
            post = [NSString stringWithFormat:@"%@&a=%@", post, [address urlEncodedString]];
        }
		
		if( lastLoc.wifiapname != nil ) {
			post = [NSString stringWithFormat:@"%@&wifi=%@&bssid=%@&map=%@", post, [lastLoc.wifiapname urlEncodedString], lastLoc.wifiapbssid, lastLoc.mapId];
		}
	}
	post = [NSString stringWithFormat:@"%@&tracking=%d", post, [AlertySettingsMgr trackingEnabled] ? 1 : 0];
	NSString *lang = NSLocalizedString(@"LANGUAGE", @"LANGUAGE");
//	if ([lang isEqualToString:@"sv"]) {
		post = [post stringByAppendingString:@"&lang=sv"];
//	} else {
//		post = [post stringByAppendingString:@"&lang=en"];
//	}
	if (![AlertySettingsMgr firstRun]) {
		//[AlertySettingsMgr setUserID:2442];
		if ([AlertySettingsMgr userID] != 0) {
			post = [post stringByAppendingFormat:@"&swupdate=%ld&userid=%ld", (long)[AlertySettingsMgr userID], (long)[AlertySettingsMgr userID]];
		}
	}
	post = [post stringByAppendingFormat:@"&version=%@", [UIApplication bundleVersionString]];
    post = [post stringByAppendingFormat:@"&pin=%@", [AlertySettingsMgr userPIN]];
    post = [post stringByAppendingFormat:@"&lp=%d", AlertySettingsMgr.lastPositionEnabled ? 1 : 0];
	[self startRequest:post requestUrl:DATA_URL ProcessResponse:TRUE];
}

-(void) setIndoorLocation {
    
    if (AlertySettingsMgr.timer) {
        if (AlertySettingsMgr.timerLongitude && AlertySettingsMgr.timerLatitude) {
            CLLocationCoordinate2D wificoords = CLLocationCoordinate2DMake(AlertySettingsMgr.timerLatitude.doubleValue, AlertySettingsMgr.timerLongitude.doubleValue);
            MyLocation *myLoc = [[MyLocation alloc] initWithCoordinate:wificoords
                                                                 Speed:0
                                                              Altitude:0
                                                               Heading:0
                                                              Accuracy:0
                                                      VerticalAccuracy:0
                                                              Distance:0
                                                              Duration:SOS_SYNC_INTERVAL
                                                             Timestamp:[[NSDate date] timeIntervalSince1970]
                                                                   SOS:FALSE];
            myLoc.wifiapname = AlertySettingsMgr.timerMessage;
            [DataManager sharedDataManager].lastLocation.userAddress = AlertySettingsMgr.timerAddress;
            [[DataManager sharedDataManager].locations removeAllObjects];
            [[DataManager sharedDataManager] registerMyLocation:myLoc];
            return;
        }
    }
    
    /*WifiAP* wifiap = [AlertyAppDelegate sharedAppDelegate].closestAP;
    if (wifiap) NSLog(@"beacon: %@", wifiap.name);
    if (!wifiap) {
        wifiap = [WifiApMgr currentWifiAp];
        if (wifiap) NSLog(@"wifi: %@", wifiap.name);
    }
	if (wifiap && wifiap.locationLat && wifiap.locationLon) {
		CLLocationCoordinate2D wificoords = CLLocationCoordinate2DMake([wifiap.locationLat doubleValue], [wifiap.locationLon doubleValue]);
		MyLocation *myLoc = [[MyLocation alloc] initWithCoordinate:wificoords 
															 Speed:0
														  Altitude:0
														   Heading:0
														  Accuracy:0
												  VerticalAccuracy:0
														  Distance:0
														  Duration:SOS_SYNC_INTERVAL 
														 Timestamp:[[NSDate date] timeIntervalSince1970] 
															   SOS:FALSE];
		myLoc.wifiapname = wifiap.name;
		myLoc.wifiapbssid = wifiap.bssid;
        [DataManager sharedDataManager].lastLocation.userAddress = wifiap.info;
        myLoc.mapId = wifiap.map;
		[[DataManager sharedDataManager].locations removeAllObjects];
		[[DataManager sharedDataManager] registerMyLocation:myLoc];
    } else {
        NSLog(@"gps");
    }*/
    
    if (AlertySettingsMgr.timer && AlertySettingsMgr.timerAddress.length) {
        [DataManager sharedDataManager].lastLocation.userAddress = AlertySettingsMgr.timerAddress;
    }
    if (AlertySettingsMgr.timer && AlertySettingsMgr.timerMessage.length) {
        [DataManager sharedDataManager].lastLocation.wifiapname = AlertySettingsMgr.timerMessage;
    }
}

-(void) registerNewBizUser:(NSString *)userId pincode:(NSString *)pincode
{
	NSString *post = [NSString stringWithFormat:@"&imei=%@&id=%@&pin=%@", [self getDeviceID],
					  [userId urlEncodedString], pincode];
    post = [post stringByAppendingString:@"&lang=sv"];

//	NSString *lang = [AlertyAppDelegate language];
//	if ([lang isEqualToString:@"sv"]) {
//		post = [post stringByAppendingString:@"&lang=sv"];
//	} else {
//		post = [post stringByAppendingString:@"&lang=en"];
//	}
	[AlertySettingsMgr setUserPIN:pincode];
	[self startRequest:post requestUrl:REGISTRATION_URL ProcessResponse:TRUE];
}

-(void) changePassword:(NSString *)newPassword
{
	NSString *userName = [AlertySettingsMgr userName];
	NSString *post = [NSString stringWithFormat:@"&imei=%@&tel=%@&passw=%@", [self getDeviceID], [userName urlEncodedString], [newPassword urlEncodedString]];
	[self startRequest:post requestUrl:CHANGEPASSWORD_URL ProcessResponse:FALSE];
}

- (void) storeUserSettings:(NSString *)fname pin:(NSString*)pin {
    NSInteger userId = [AlertySettingsMgr userID];
    NSMutableDictionary* body = @{ @"userid": [NSNumber numberWithInteger:userId]}.mutableCopy;
    if (fname) [body setObject:fname forKey:@"full_name"];
    if (pin) [body setObject:pin forKey:@"pin"];
    [MobileInterface post:UPDATE_USER_URL body:body completion:^(NSDictionary *result, NSString *errorMessage) {
    }];
}

- (void) sendPhoneNumbers:(NSMutableArray *)friendsToNotify withSource:(int)source {

	long uid = [AlertySettingsMgr userID];
    NSString *lang = [AlertyAppDelegate language];
	
	NSString *userName = nil;
	if ([AlertySettingsMgr isBusinessVersion]) {
		userName = [AlertySettingsMgr userNameServer];
	}
	else {
		userName = [AlertySettingsMgr userFullName];
	}
    
	MyLocation *lastLocation = [DataManager sharedDataManager].lastLocation;
	NSString *message = [NSLocalizedString(@"<name> is in an emergency situation. Click on the link to see where I am. <URL>", @"") stringByReplacingOccurrencesOfString:@"<name>" withString:userName == nil ? @"" : userName];
	message = [message stringByReplacingOccurrencesOfString:@"<latitude>" withString:[NSString stringWithFormat:@"%.6f", lastLocation.latitude]];
	message = [message stringByReplacingOccurrencesOfString:@"<longitude>" withString:[NSString stringWithFormat:@"%.6f", lastLocation.longitude]];
    NSString *messageDotEnc = [message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	
	int isPlus = [AlertySettingsMgr hasPlus] ? 1 : 0;
	
	NSString *alertMsg = @"";
	
	if([[lastLocation.userAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0) {
		NSString *address = lastLocation.userAddress;
		NSString *city = lastLocation.userCity;
		NSString *country = lastLocation.userCountry;
        
        alertMsg = address;
        if (city.length || country.length) alertMsg = [alertMsg stringByAppendingString:@", "];
        if (city.length) alertMsg = [alertMsg stringByAppendingString:city];
        if (city.length && country.length) alertMsg = [alertMsg stringByAppendingString:@" "];
        if (country.length) alertMsg = [alertMsg stringByAppendingString:country];
        alertMsg = [alertMsg stringByAppendingFormat:@" +/- %dm", (int)lastLocation.accuracy];
	}
	
	if (lastLocation.wifiapname) {
		alertMsg = [alertMsg stringByAppendingString:[NSString stringWithFormat:@"[ %@ ]", lastLocation.wifiapname]];
	}
	
	NSString *alertMsgDotEnc = [alertMsg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	alertMsgDotEnc = [alertMsgDotEnc stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	NSString *url = [NSString stringWithFormat:@"%@?message=%@&userid=%ld&lang=%@&isPlus=%i&alertmsg=%@&latitude=%0.14f&longitude=%0.14f&name=%@&source=%d", SEND_PHONES, messageDotEnc, uid, lang, isPlus, alertMsgDotEnc, lastLocation.latitude, lastLocation.longitude, [userName urlEncodedString], source];
    for (int i = 0; i < [friendsToNotify count]; i++) {
		Contact *f = [friendsToNotify objectAtIndex:i];
		NSString *phone = [AlertyDBMgr internationalizeNumber:f.phone];
		phone = [phone stringByReplacingOccurrencesOfString:@"\u00a0" withString:@""];
		phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
		phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
		phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
        if (f.name.length == 0) {
            [DataManager lookupFriendNameByPhone:f orPhone:nil];
        }
		NSString *parts = [NSString stringWithFormat:@"&p%i=%@&n%i=%@", i+1, [phone urlEncodedString], i+1,
						   f.name == nil ? @"" : [f.name urlEncodedString]];
		url = [url stringByAppendingString:parts];
	}
    /*if (source == ALERT_SOURCE_TIMER) {
        url = [url stringByAppendingFormat:@"&extra=%@", [[AlertySettingsMgr timerMessage] urlEncodedString]];
    }*/
    NSLog(@"sennd Phone Numbers %@",url);
	NSURL *urlObj = [[NSURL alloc] initWithString:url];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlObj cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error != nil) {
            if (self.smsTask != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:self.smsTask];
                self.smsTask = UIBackgroundTaskInvalid;
            }
            [self raiseCommunicationErrorEvent];
        } else {
            NSError *error;
            NSDictionary *response = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            [DataManager sharedDataManager].alertId = [[response objectForKey:@"alert"] intValue];
            [AlertySettingsMgr setRoomName:[response[@"room"] stringValue]];
            [AlertySettingsMgr setRoomToken:[response[@"token"] stringValue]];
            [DataManager sharedDataManager].voice = [response[@"voice"] stringValue];
            [DataManager sharedDataManager].voicePhone = [response[@"voicePhone"] stringValue];
            [AlertySettingsMgr setSosMode:[DataManager sharedDataManager].alertId];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlertCreatedNotification object:response];
            if (self.smsTask != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:self.smsTask];
                self.smsTask = UIBackgroundTaskInvalid;
            }
        }
    }];
    [task resume];
}

- (void) stopSOSMode {
    
	long uid = [AlertySettingsMgr userID];
	NSString *userName = [AlertySettingsMgr userFullName];
	if ([AlertySettingsMgr isBusinessVersion]) {
		userName = [AlertySettingsMgr userNameServer];
	}
	NSString *encodedUserName = [userName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	NSString *url = [NSString stringWithFormat:STOP_SOS, uid, encodedUserName, [AlertyAppDelegate language]];
	NSURL * urlObj = [[NSURL alloc] initWithString:url];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlObj cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error != nil) {
            [self raiseCommunicationErrorEvent];
        }
    }];
    [task resume];
}

- (void) sendSosInvitationTo:(NSString *)phone Name:(NSString *)name Position:(long)pos
{
	long uid = [AlertySettingsMgr userID];
    NSString *userName = nil;
	if ([AlertySettingsMgr isBusinessVersion]) {
		userName = [AlertySettingsMgr userNameServer];
	}
	else {
		userName = [AlertySettingsMgr userName];
	}
    NSString *lang = [AlertyAppDelegate language];
	phone = [phone stringByReplacingOccurrencesOfString:@"\u00a0" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
	phone = [[phone urlEncodedString] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	NSString *url = [NSString stringWithFormat:SEND_SOS_INVITATION, phone, [name urlEncodedString],
												uid, pos, [userName urlEncodedString], lang];
	NSURL * urlObj = [[NSURL alloc] initWithString:url];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlObj cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error != nil) {
            [self raiseCommunicationErrorEvent];
        } else {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self startSynchronization:YES];
            }];
        }
    }];
    [task resume];
}

#pragma mark Private Methods

- (void) raiseCommunicationErrorEvent {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(synchErrorEvent)]) {
		[self.delegate synchErrorEvent];
	}
}

- (void) cancelConnection {
	[_timeout invalidate];
	if( _syncRequest != nil )
	{
		[_syncRequest cancel];
		_underRequest = FALSE;
		_syncRequest = nil;
		[self raiseCommunicationErrorEvent];
	}
}

- (void) startRequest:(NSString*)postParameters requestUrl:(NSString*)url ProcessResponse:(BOOL)processResponse {
	if (_underRequest == FALSE) {
		NSData *postData = [postParameters dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
		NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
		[request setTimeoutInterval:TIMEOUT_INTERVAL];
		[request setURL:[NSURL URLWithString:url]];
		[request setHTTPMethod:@"POST"];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setHTTPBody:postData];
		
        
//        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]; //Save the response as string
//        NSLog(@"Respueta: %@", responseString); //Check the response

		_syncRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		needProcessResponse = processResponse;
		if (_syncRequest) {
			_underRequest = TRUE;
			self.responseData = [NSMutableData data];
		} else {
			[self raiseCommunicationErrorEvent];
		}
		
		_timeout = [NSTimer scheduledTimerWithTimeInterval:3*TIMEOUT_INTERVAL target:self selector:@selector(cancelConnection) userInfo:nil repeats:NO];
		
		if (self.bgTask != UIBackgroundTaskInvalid) {
			[[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
		}
		NSLog(@"Bg task SYNC start ----------------------------------------------------");
		self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
				  ^{
					  NSLog(@"Bg task SYNC forced end ----------------------------------------------------");
					  [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
					  self.bgTask = UIBackgroundTaskInvalid;
				  }];

	}
}

#pragma mark Communication Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if(connection == _syncRequest)
	{
		[self.responseData setLength:0];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if(connection == _syncRequest)
	{
		[self.responseData appendData:data];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (connection == _syncRequest) {
		[_timeout invalidate];
		_syncRequest = nil;
		_underRequest = FALSE;
		if (self.bgTask != UIBackgroundTaskInvalid)
		{
			NSLog(@"Bg task SYNC end ----------------------------------------------------");
			[[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
			self.bgTask = UIBackgroundTaskInvalid;
		}
	}

	[self raiseCommunicationErrorEvent];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	BOOL isSync = NO;
	if (connection == _syncRequest) {
		isSync = YES;
		[_timeout invalidate];
		_syncRequest = nil;
	}
	else {
		return;
	}

	if (needProcessResponse) {
		_responseHandled = FALSE;
		[self processResponse];
		if( _responseHandled == FALSE )
		{
			[self raiseCommunicationErrorEvent];
		}
		[self.delegate synchDataFinishedEvent:self];
		if (isSync) {
			[[NSNotificationCenter defaultCenter] postNotificationName:kSyncFinishedNotification object:nil];
		}
	}
	
	if (self.bgTask != UIBackgroundTaskInvalid)
	{
		NSLog(@"Bg task SYNC end ----------------------------------------------------");
		[[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
		self.bgTask = UIBackgroundTaskInvalid;
	}
	_underRequest = FALSE;
}

#pragma mark Processing Response

- (void)processResponse {
	if ([self.responseData length] == 0) {
		[self raiseCommunicationErrorEvent];
		return;
	}
	while( [self.responseData length] > 0 ) {
		//NSString *str = [[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding];
		//cmdlogtext(@" response len: %d\n%@", self.responseData.length, str);
		const unsigned char *data = [[self getResponseDataBytes:4] bytes];
		int command = *(int*)data;
		const unsigned char *data2 = [[self getResponseDataBytes:4] bytes];
		int size = *(int*)data2;

		switch ( command ) {
				
			case 1:
			{
				const unsigned char *userData = [[self getResponseDataBytes:size] bytes];
				
				int offset = 4; // speedcam, premium, 0, 0 (=4bytes)
				
				int userID = [self getIntFromData:userData offset:&offset];
				int sex = [self getIntFromData:userData offset:&offset];
				int age = [self getIntFromData:userData offset:&offset];
				NSString *fullName = [self getStringFromData:userData offset:&offset];
				NSString *generalInf = [self getStringFromData:userData offset:&offset];
				
				if ([AlertySettingsMgr userID] != 0 && [AlertySettingsMgr userID] != userID && [AlertySettingsMgr UserPhoneNr].length == 0 && ![AlertySettingsMgr isBusinessVersion]) {
					[[AlertyAppDelegate sharedAppDelegate].mainController performSelectorOnMainThread:@selector(showSetPhoneNrAlert) withObject:nil waitUntilDone:NO];
				}
				
				[AlertySettingsMgr setUserID:userID];
				[AlertySettingsMgr setUserFullName:fullName];
				[AlertySettingsMgr setUserSex:sex];
				[AlertySettingsMgr setUserAge:age];
				[AlertySettingsMgr setUserGeneralInfo:generalInf];
				[AlertySettingsMgr setFirstRun:YES];

				NSString *uname = [self getStringFromData:userData offset:&offset];
				if ([AlertySettingsMgr isBusinessVersion]) {
					NSString *uid = [self getStringFromData:userData offset:&offset];
					[AlertySettingsMgr setUserNameServer:uname];
					[AlertySettingsMgr setUserName:uid];
				}
				NSString* phoneNr = [self getStringFromData:userData offset:&offset];
				[AlertySettingsMgr setUserPhoneNr:phoneNr];
				
				while (offset%4 != 0) offset++;
				int invites = [self getIntFromData:userData offset:&offset];
				[AlertySettingsMgr setUserInvites:invites];
				
				_responseHandled = TRUE;
				break;
			}
			case 4: //friends list
			{
				_responseHandled = TRUE;
				break;
			}
			case 6:
			{
                if (size != 8) {
                    _responseHandled = YES;
                    break;
                }
                
                const unsigned char *userData = [[self getResponseDataBytes:size] bytes];
                int offset = 0;
                int firstByte = [self getIntFromData:userData offset:&offset];
                int secondByte = [self getIntFromData:userData offset:&offset];
                if (firstByte != 1 && secondByte != 6) {
                    _responseHandled = YES;
                    break;
                }

				[AlertySettingsMgr setUserPIN:@""];
				
				if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(synchUserNotRegisteredEvent)]) {
					[self.delegate synchUserNotRegisteredEvent];
				}
				_responseHandled = TRUE;
				break;
			}
			case 7:
			{
				const unsigned char *data = [[self getResponseDataBytes:size] bytes];
				int reason = (data ? *(int*)( data + 0 ) : 0);
				
				if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(synchRegistrationErrorWithCodeEvent:)]) {
					[self.delegate synchRegistrationErrorWithCodeEvent:reason];
				}
				_responseHandled = TRUE;
				break;
			}
			case 8:
			{
				// non-subscription type user
				const unsigned char *userData = [[self getResponseDataBytes:size] bytes];
				
				int ns = 0;
				while(userData && userData[ns] != 0) {
					ns++;
				}
				NSString *uid = [self charToNSString:(const char *)(userData) length:ns];
				
				bool settingsChanged = NO;
				NSString *uidOld = [AlertySettingsMgr userName];
				if( uidOld != nil ) {
					settingsChanged = YES;
				}
				
				[AlertySettingsMgr setUserName:uid];
                
                ns++;
                int i = 0, kezd = ns;
                while(userData && userData[ns] != 0) {
                    ns++;
                    i++;
				}
                NSString *uname = [self charToNSString:(const char *)(userData + kezd) length:i];
                [AlertySettingsMgr setUserNameServer:uname];
				
				// end
				
				// remove all user contacts
				[[AlertyDBMgr sharedAlertyDBMgr] delAllContacts];
				
				// remove all indoor wifi aps
				[[AlertyDBMgr sharedAlertyDBMgr] delAllWifiAPs];
				
				_responseHandled = TRUE;
				_underRequest = FALSE; // this is important so we can call an empty sync straight after this (REMOVE IF REGISTRATION RETURNS MULTIPLE COMMANDS!!)
				
				if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(synchUserRegisteredEvent:)]) {
					[self.delegate synchUserRegisteredEvent:settingsChanged];
				}
				break;
			}
			case 16:
			{
				if ([AlertySettingsMgr discreteModeEnabled]) {
					AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
				} else {
					const unsigned char *friendData = [[self getResponseDataBytes:size] bytes];
					NSString *friendName = [self charToNSString:(const char *)(friendData) length:size];
					[AlertyAppDelegate showLocalNotification:[self getNotificationMessage:friendName] action:NSLocalizedString(@"OK", @"OK") userInfo:nil];
				}
				_responseHandled = TRUE;
				break;
			}
                
            case 29:
            {
                // contacts (business and regular)
                const unsigned char *data = [[self getResponseDataBytes:size] bytes];
                
                int offset = 0;
                int itemCount = [self getIntFromData:data offset:&offset];
                
                NSMutableArray *contacts = [NSMutableArray array];
                NSMutableArray *bizContacts = [NSMutableArray array];
                
                for( int i=0; i < itemCount && offset < size; i++ ) {
                    NSString *contactData = [self getStringFromData:data offset:&offset];
                    NSString *name = [self getStringFromData:data offset:&offset];
                    unsigned char online = data[offset++];
                    unsigned char lastPosition = data[offset++];
                    
                    int typeInt = [[contactData substringWithRange:NSMakeRange(0, 1)] intValue];
                    int statusInt = [[contactData substringWithRange:NSMakeRange(1, 1)] intValue];
                    NSString *phone = [contactData substringFromIndex:2];
                    
                    NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
                    [contactDict setObject:phone forKey:@"phone"];
                    [contactDict setObject:name forKey:@"name"];
                    [contactDict setObject:[NSNumber numberWithInt:typeInt] forKey:@"type"];
                    [contactDict setObject:[NSNumber numberWithInt:statusInt] forKey:@"status"];
                    [contactDict setObject:[NSNumber numberWithInt:online] forKey:@"online"];
                    [contactDict setObject:[NSNumber numberWithInt:lastPosition] forKey:@"lastPosition"];
                    
                    if( typeInt == 1 ) {
                        // business contacts
                        [bizContacts addObject:contactDict];
                    }
                    else {
                        // personal contacts
                        [contacts addObject:contactDict];
                    }
                }
                
                // add personal contacts if they haven't been added yet
                if (![[AlertyDBMgr sharedAlertyDBMgr] hasActiveGroup]) {
                    [[AlertyDBMgr sharedAlertyDBMgr] addActiveGroup];
                }
                
                if ([contacts count] > 0) {
                    if ([[AlertyDBMgr sharedAlertyDBMgr] countAllContacts] == 0) {
                        // either after registration or first sync
                        [[AlertyDBMgr sharedAlertyDBMgr] addContactsFromWS:contacts];
                    }
                    else {
                        // update status of contacts
                        for (NSMutableDictionary *contactDict in contacts) {
                            NSString *phone = [contactDict objectForKey:@"phone"];
                            NSNumber *status = [contactDict objectForKey:@"status"];
                            NSNumber* online = contactDict[@"online"];
                            NSNumber* lastPosition = contactDict[@"lastPosition"];
                            [AlertyDBMgr.sharedAlertyDBMgr updateContactWithPhone:phone status:status online:online lastPostion:lastPosition];
                        }
                    }
                }
                
                if ([AlertySettingsMgr isBusinessVersion]) {
                    // remove and add business contacts
                    [[AlertyDBMgr sharedAlertyDBMgr] addEnterpriseGroupIfNoneFound];
                    [[AlertyDBMgr sharedAlertyDBMgr] delAllBusinessContacts];
                    [[AlertyDBMgr sharedAlertyDBMgr] addBizContactsFromWS:bizContacts];
                }
        
                _responseHandled = TRUE;
                break;
            }

                
			/*case 17:
			{
				// contacts (business and regular)
				const unsigned char *data = [[self getResponseDataBytes:size] bytes];
				
				int offset = 0;
				int itemCount = [self getIntFromData:data offset:&offset];
				
				NSMutableArray *contacts = [NSMutableArray array];
				NSMutableArray *bizContacts = [NSMutableArray array];
				
				for( int i=0; i < itemCount && offset < size; i++ ) {
					NSString *contactData = [self getStringFromData:data offset:&offset];
					NSString *name = [self getStringFromData:data offset:&offset];
					
					int typeInt = [[contactData substringWithRange:NSMakeRange(0, 1)] intValue];
					int statusInt = [[contactData substringWithRange:NSMakeRange(1, 1)] intValue];
					NSString *phone = [contactData substringFromIndex:2];
					
					NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
					[contactDict setObject:phone forKey:@"phone"];
					[contactDict setObject:name forKey:@"name"];
					[contactDict setObject:[NSNumber numberWithInt:typeInt] forKey:@"type"];
					[contactDict setObject:[NSNumber numberWithInt:statusInt] forKey:@"status"];
					
					if( typeInt == 1 ) {
						// business contacts
						[bizContacts addObject:contactDict];
					}
					else {
						// personal contacts
						[contacts addObject:contactDict];
					}
				}
				
				// add personal contacts if they haven't been added yet
				if (![[AlertyDBMgr sharedAlertyDBMgr] hasActiveGroup]) {
					[[AlertyDBMgr sharedAlertyDBMgr] addActiveGroup];
				}
				
				if ([contacts count] > 0) {
					if ([[AlertyDBMgr sharedAlertyDBMgr] countAllContacts] == 0) {
						// either after registration or first sync
						[[AlertyDBMgr sharedAlertyDBMgr] addContactsFromWS:contacts];
					}
					else {
						// update status of contacts
						for (NSMutableDictionary *contactDict in contacts) {
							NSString *phone = [contactDict objectForKey:@"phone"];
							NSNumber *status = [contactDict objectForKey:@"status"];
							[[AlertyDBMgr sharedAlertyDBMgr] updateContactWithPhone:phone setStatus:status];
						}
					}
				}
				
				if ([AlertySettingsMgr isBusinessVersion]) {
					// remove and add business contacts
					[[AlertyDBMgr sharedAlertyDBMgr] addEnterpriseGroupIfNoneFound];
					[[AlertyDBMgr sharedAlertyDBMgr] delAllBusinessContacts];
					[[AlertyDBMgr sharedAlertyDBMgr] addBizContactsFromWS:bizContacts];
				}
		
				_responseHandled = TRUE;
				break;
			}*/
			case 18:
			{
				// credit
				const unsigned char *data = [[self getResponseDataBytes:size] bytes];				
				int credits = (data ? *(int*)( data + 0 ) : 0);
				[AlertySettingsMgr setMaxCredit:credits];
				[self.delegate synchReloadCredits];
				_responseHandled = TRUE;
				break;
			}
			case 19:
			{
				// wifi access points - deprecated
				[self getResponseDataBytes:size];
				break;
			}
            case 25:
            {
                const unsigned char *data = [[self getResponseDataBytes:size] bytes];
                int offset = 0;
                int waCount = [self getIntFromData:data offset:&offset];
                
                // delete all enterprise type wifiaps
                [[AlertyDBMgr sharedAlertyDBMgr] delAllWifiAPsOfType:kWifiAPTypeCompany];
                [[AlertyDBMgr sharedAlertyDBMgr] delAllWifiAPsOfType:kWifiAPTypeBeaconCompany];
                
                // create and fill array of wifiAPDictionary type
                NSMutableArray *wifiAps = [NSMutableArray array];
                for( int i=0; i < waCount && offset < size; i++ )
                {
                    NSString *bssid = [self parseString:data offset:offset length:size];
                    offset += [bssid length]+1;
                    
                    NSString *name = [self parseString:data offset:offset length:size];
                    offset += strlen([name UTF8String])+1;
                    
                    NSString *info = [self parseString:data offset:offset length:size];
                    offset += strlen([info UTF8String])+1;
                    
                    NSString *locationLat = [self parseString:data offset:offset length:size];
                    offset += [locationLat length]+1;
                    
                    NSString *locationLon = [self parseString:data offset:offset length:size];
                    offset += [locationLon length]+1;
                    
                    while (offset % 4) {
                        offset++;
                    }
                    int mapId = [self getIntFromData:data offset:&offset];
                    
                    NSMutableDictionary *wifiAp = [NSMutableDictionary dictionary];
                    [wifiAp setValue:bssid forKey:@"bssid"];
                    [wifiAp setValue:name forKey:@"name"];
                    [wifiAp setValue:info forKey:@"info"];
                    [wifiAp setValue:[NSNumber numberWithInteger:kWifiAPTypeCompany] forKey:@"type"];
                    [wifiAp setValue:[NSNumber numberWithDouble:[locationLat doubleValue]] forKey:@"locationLat"];
                    [wifiAp setValue:[NSNumber numberWithDouble:[locationLon doubleValue]] forKey:@"locationLon"];
                    [wifiAp setValue:[NSNumber numberWithInt:mapId] forKey:@"mapId"];
                    [wifiAps addObject:wifiAp];
                }
                
                // add wifiaps to db
                [[AlertyDBMgr sharedAlertyDBMgr] addWifiAPsFromWS:wifiAps];
                
                [self.delegate synchReloadWifiAps];
                _responseHandled = TRUE;
                break;
            }
			case 20:
			{
				// number of contacts allowed for company
				const unsigned char *data = [[self getResponseDataBytes:size] bytes];
				int contactsMax = (data ? *(int*)( data + 0 ) : 0);
				[AlertySettingsMgr setMaxCompanyContacts:contactsMax];
				
                while (1) {
                    NSInteger count = 0;
                    NSArray<Contact*>* contacts = [AlertyDBMgr.sharedAlertyDBMgr getAllContacts];
                    for (Contact* contact in contacts) {
                        NSInteger type = [contact.type integerValue];
                        if (type == 0 || type == 1) {
                            count++;
                        }
                    }
                    if (count <= contactsMax) break;

                    Group* group = [AlertyDBMgr.sharedAlertyDBMgr getActiveGroup];
                    if (group.contacts.count == 0) {
                        break;
                    }
                    
                    Contact* contact = group.contacts.allObjects.firstObject;
                    [DataManager.sharedDataManager sendSosInvitationTo:contact.phone Name:@"" Position:-1];
                    [AlertyDBMgr.sharedAlertyDBMgr delContact:contact];
                }

                [self.delegate synchReloadFriendPhones];
				_responseHandled = TRUE;
				break;
			}
			case 22:
			{
				// ICE contacts
				const unsigned char *data = [[self getResponseDataBytes:size] bytes];
				
				int offset = 0;
				
				const int icount = [self getIntFromData:data offset:&offset];
				NSMutableArray *contacts = [NSMutableArray array];
				
				// remove all
				[AlertySettingsMgr setIceContacts:nil];
				
				for( int i=0; i < icount && offset < size; i++ )
				{
					NSString *phone = [self getStringFromData:data offset:&offset];
					NSString *name = [self getStringFromData:data offset:&offset];
					NSString *relation = [self getStringFromData:data offset:&offset];
					
					NSMutableDictionary *contact = [NSMutableDictionary dictionary];
					
					[contact setValue:name forKey:@"name"];
					[contact setValue:phone forKey:@"phone"];
					[contact setValue:relation forKey:@"relation"];
					
					[contacts addObject:contact];
				}
				[AlertySettingsMgr setIceContacts:contacts];
				
				_responseHandled = TRUE;
				break;
			}
			case 23:
				//[[NSNotificationCenter defaultCenter] postNotificationName:kFollowMeAcceptedNotification object:self userInfo:nil];
				_responseHandled = TRUE;
				break;
				
			case 24:
			{
				int offset = 0;
				const unsigned char *data = [[self getResponseDataBytes:size] bytes];
				const int alertId = [self getIntFromData:data offset:&offset];
				const int alertUserId = [self getIntFromData:data offset:&offset];
				NSString *message = [self getStringFromData:data offset:&offset];
				NSString *roomName = [self getStringFromData:data offset:&offset];
				/*NSString *token =*/ [self getStringFromData:data offset:&offset];
				NSString *userName = [self getStringFromData:data offset:&offset];
				//NSString *message = [self parseString:(const char *)data offset:offset length:size];
                [[AlertyAppDelegate sharedAppDelegate] showAlertWithId:alertId message:message user:alertUserId roomName:roomName token:@"" userName:userName];
				break;
			}
            case 26: {
                const unsigned char *data = [[self getResponseDataBytes:size] bytes];
                int offset = 0;
                NSString* follower = [self getStringFromData:data offset:&offset];
                [[NSNotificationCenter defaultCenter] postNotificationName:kFollowMeAcceptedNotification object:self userInfo:@{@"follower" : follower ? follower : @""}];
                break;
            }
                
            case 27: {
                const unsigned char *data = [[self getResponseDataBytes:size] bytes];
                int offset = 0;
                const int userId = [self getIntFromData:data offset:&offset];
                NSString* following = [self getStringFromData:data offset:&offset];
                NSString* userId1 = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];

                [[NSNotificationCenter defaultCenter] postNotificationName:kFollowMeFollowingNotification object:self userInfo:@{@"following" : following ? following : @"", @"user" : [NSString stringWithFormat:@"%d", userId],@"userid":userId1 }];
                break;
            }

			default:
			{
				NSLog(@"NO HANDLING");
				[self getResponseDataBytes:size];
				break;
			}
		}
	}
}

- (int) getIntFromData:(const unsigned char *)data offset:(int *)offset {
	int tmpoffset = *offset;
	int ret = (data ? *(int*)(data + tmpoffset) : 0);
	*offset = tmpoffset + sizeof(int);
	return ret;
}

- (NSString *) getStringFromData:(const unsigned char *)data offset:(int *)offset {
	int ns = 0;
	int tmpoffset = *offset;
	while( data[ns + tmpoffset] != 0) {
		ns++;
	}
	*offset = tmpoffset + ns + 1;
	return [self charToNSString:(const char *)(data + tmpoffset) length:ns];
}

- (NSString *) charToNSString:(const char *)sourceString length:(int)n {
	if (!sourceString) return nil;
	char buffer[n+1];
	buffer[n] = '\0';
	strncpy( buffer, sourceString, n );
	return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSMutableData *) getResponseDataBytes:(unsigned long)length {
	if (!length) return nil;
	if (length == NSNotFound) return nil;
	if (length > self.responseData.length) length = self.responseData.length;
	NSRange range;
	range.length = length;
	range.location = 0;
	NSMutableData *returnData = [[self.responseData subdataWithRange:range] mutableCopy];
	range.location = length;
	range.length = [self.responseData length] - length;
	self.responseData = [[self.responseData subdataWithRange:range] mutableCopy];
	return returnData;
}

- (NSString *) parseString:(const char *)data offset:(int)offset length:(int)length {
	char buffer[length];
	int n = 0;
	while( data[offset + n] != 0 ) {
		n++;
	}
	buffer[n] = '\0';
	strncpy( buffer, data+offset, n );
	NSString *ret = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
	return ret;
}

-(NSString *) getNotificationMessage:(NSString *)friendName {
	return [NSString stringWithFormat:NSLocalizedString(@"Your emergency message was accepted by %@.", @""), friendName];
}

#pragma mark battery level
- (float) batteryLevel {
	return 100.0f * [UIDevice currentDevice].batteryLevel;
}

@end
