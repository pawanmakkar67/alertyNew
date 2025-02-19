//
//  AlertySettingsMgr.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"

#define S_MANDOWN_SET					@"S_MANDOWN_SET"
#define S_MANDOWN_LEVEL					@"S_MANDOWN_LEVEL"
#define S_LAST_POSITION_SET             @"S_LAST_POSITION_SET"
#define S_LAST_POSITION_DATE            @"S_LAST_POSITION_DATE"
#define S_TRACKING_SET					@"S_TRACKING_SET"
#define S_DISCRETE_SET					@"S_DISCRETE_SET"
#define S_FRONT_CAMERA_SET              @"S_FRONT_CAMERA_SET"
#define S_SCREENSHOT_SET                @"S_SCREENSHOT_SET"
#define S_SPEAKER_SET                   @"S_SPEAKER_SET"
#define S_HAS_FOLLOW_ME					@"UserHasFollowMe"
#define S_HAS_PLUS						@"UserHasPlus"
#define S_HAS_INDOOR_LOCATIONING		@"S_HAS_INDOOR_LOCATIONING"
#define S_HAS_SOS_ALARM					@"S_HAS_SOS_ALARM"
#define S_VALID_SUBSCRIPTION			@"ValidSubscription"
#define S_USER_NAME						@"UserName"
#define S_USER_NAME_SERVER				@"UserNameServer"
#define S_USER_FULLNAME					@"UserFullName"
#define S_USER_EMAIL					@"UserEmail"
#define S_USER_PASSWORD					@"UserPassword"
#define S_USER_PHONE_NR					@"UserPhoneNr"
#define S_LALARM                         @"S_LALARM"
#define S_NOTIFICATION_KEY              @"notificationKeyy"

#define S_USER_ID						@"UserID"
#define S_USER_SEX						@"UserSex"
#define S_USER_AGE						@"UserAge"
#define S_USER_PIN						@"PinCode"
#define S_ICE_CONTACTS					@"ICEContacts"
#define S_USER_GENERALINF				@"UserGeneralInfo"
#define S_MAX_CREDIT					@"MaxNumberOfCredits"
#define S_ENABLE_HEADSET				@"EnableHeadset"
#define S_ALERT_MESSAGE					@"AlertMessage"
#define S_MAX_CCONTACTS					@"MaxCompanyContacts"
#define S_GROUPID						@"GroupID"
#define S_BIZ_TYPE						@"BusinessType"
#define S_FIRST_FB_USE					@"FirstFacebookUse"
#define S_PREACTIVATION					@"Preactivation"
#define S_BUSINESS_VERSION				@"BusinessVersion"
#define S_INVITES						@"Invites"
#define S_SOSMODE						@"SOSMode"
#define S_FIRSTRUN						@"FirstRun"
#define S_ASKNETWORK					@"AskNetwork"
#define S_TIMER                         @"Timer"
#define S_TIMER_MESSAGE                 @"TimerMessage"
#define S_TIMER_ADDRESS                 @"TimerAddress"
#define S_TIMER_LATITUDE                @"TimerLatitude"
#define S_TIMER_LONGITUDE               @"TimerLongitude"
#define S_HOME_TIMER                    @"homeTimer"
#define S_HOME_TIMER_MESSAGE            @"homeTimerMessage"
#define S_AGING                         @"Aging"
#define S_LAST_USER_ID					@"LastUserID"
#define S_LAST_AUTH_CODE                @"LastAuthCode"
#define S_TILT_ENABLED                  @"TiltEnabled"
#define S_TILT_VALUE                    @"TiltValue"

#define S_USE_PIN                       @"UsePin"
#define S_VIDEO_ROOM_NAME               @"S_VIDEO_ROOM_NAME"
#define S_VIDEO_TOKEN                   @"S_VIDEO_TOKEN"
#define S_HAS_IAX                        @"UserHasIAX"
#define S_IAX_DETAILS                    @"IAX_Details"

#define kGroupsVCBubble1ShownKey				@"kGroupsVCBubble1ShownKey"
#define kGroupsVCBubble2ShownKey				@"kGroupsVCBubble2ShownKey"
#define kHeadsetVCBubble1ShownKey				@"kHeadsetVCBubble1ShownKey"
#define kIndoorLocationingVCBubble1ShownKey		@"kIndoorLocationingVCBubble1ShownKey"
#define kIndoorLocationingVCBubble2ShownKey		@"kIndoorLocationingVCBubble2ShownKey"
#define kIndoorLocationingVCBubble3ShownKey		@"kIndoorLocationingVCBubble3ShownKey"
#define kWifiApInfoVCBubble1ShownKey			@"kWifiApInfoVCBubble1ShownKey"
#define kTutorialShownKey                       @"kTutorialShownKey"

@implementation AlertySettingsMgr

// man down manager

+ (BOOL) hasManDownMgr
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_MANDOWN_SET];
}

+ (BOOL) setManDownManager:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_MANDOWN_SET];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (double) manDownLevel
{
	NSInteger level = [[NSUserDefaults standardUserDefaults] doubleForKey:S_MANDOWN_LEVEL];
	if (level == 0.0) {
		/*if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568) {
			level = 250.0;
		} else*/ {
			level = 25.0;
		}
	}
	return level;
}

+ (BOOL) setManDownLevel:(double)level
{
	[[NSUserDefaults standardUserDefaults] setDouble:level forKey:S_MANDOWN_LEVEL];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) trackingEnabled {
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_TRACKING_SET];
}

+ (BOOL) setLastPositionEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_LAST_POSITION_SET];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) lastPositionEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_LAST_POSITION_SET];
}

+ (BOOL) setLAlarmEnabled:(BOOL)enabled {
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_LALARM];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL) lAlarmEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_LALARM];
}

+ (NSDate*) lastPositionDate {
    double date = [[NSUserDefaults.standardUserDefaults valueForKey:S_LAST_POSITION_DATE] doubleValue];
    return date == 0.0 ? nil : [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:date];
}

+ (BOOL) setLastPositionDate:(NSDate*)date {
    [NSUserDefaults.standardUserDefaults setObject:[NSNumber numberWithDouble:[date timeIntervalSinceReferenceDate]] forKey:S_LAST_POSITION_DATE];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) setTrackingEnabled:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_TRACKING_SET];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) discreteModeEnabled {
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_DISCRETE_SET];
}

+ (BOOL) setDiscreteModeEnabled:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_DISCRETE_SET];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

//Switch to Front Facing Camera
+ (BOOL) frontCameraEnabled{
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_FRONT_CAMERA_SET];
};

+ (BOOL) setFrontCameraEnabled:(BOOL)enabled{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_FRONT_CAMERA_SET];
    return [[NSUserDefaults standardUserDefaults] synchronize];
};

//Switch to Screenshot saving
+ (BOOL) screenshotEnabled{
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_SCREENSHOT_SET];
};

+ (BOOL) setScreenshotEnabled:(BOOL)enabled{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_SCREENSHOT_SET];
    return [[NSUserDefaults standardUserDefaults] synchronize];
};

//Switch to Speaker saving
+ (BOOL) speakerEnabled{
    return [[NSUserDefaults standardUserDefaults] boolForKey:S_SPEAKER_SET];
};

+ (BOOL) setSpeakerEnabled:(BOOL)enabled{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_SPEAKER_SET];
    return [[NSUserDefaults standardUserDefaults] synchronize];
};

// follow me
+ (BOOL) hasFollowMe {
	if ([AlertySettingsMgr isBusinessVersion]) {
		return YES;
	}
	else {
		return [[NSUserDefaults standardUserDefaults] boolForKey:S_HAS_FOLLOW_ME];
	}
}

+ (BOOL) setFollowMe:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_HAS_FOLLOW_ME];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// plus

+ (BOOL) hasPlus
{
	if ([AlertySettingsMgr isBusinessVersion]) {
		return YES;
	}
	else {
		return [[NSUserDefaults standardUserDefaults] boolForKey:S_HAS_PLUS];
	}
}

+ (BOOL) setPlus:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_HAS_PLUS];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL) hasIAX
{
        return [[NSUserDefaults standardUserDefaults] boolForKey:S_HAS_IAX];
}

+ (BOOL) setIAX:(BOOL)enabled
{
    [[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_HAS_IAX];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDictionary *) IAXDetails
{
    NSData *dataRepresentingSavedArray = [[NSUserDefaults standardUserDefaults] objectForKey:S_IAX_DETAILS];
    if (dataRepresentingSavedArray != nil)
    {
        NSDictionary *oldSavedDICT = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        
        return oldSavedDICT;
    }
    return nil;
}

+ (BOOL) setIAXDetails:(NSDictionary *)profileDictionary
{

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:profileDictionary] forKey:S_IAX_DETAILS];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL) setNotificationkey:(NSString *)val
{

    [[NSUserDefaults standardUserDefaults] setObject:val forKey:S_NOTIFICATION_KEY];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) getNotificationKey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_NOTIFICATION_KEY];
}




// facebook

+ (BOOL) hasFacebook
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"];
}

// indoor locationing

+ (BOOL) hasIndoorLocationing
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_HAS_INDOOR_LOCATIONING];
}

+ (BOOL) setIndoorLocationing:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_HAS_INDOOR_LOCATIONING];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// sos alarm

+ (BOOL) hasSosAlarm
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_HAS_SOS_ALARM];
}

+ (BOOL) setSosAlarm:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_HAS_SOS_ALARM];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// valid subscription

+ (BOOL) hasValidSubscription
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_VALID_SUBSCRIPTION];
}

+ (BOOL) setValidSubscription:(BOOL)valid
{
	[[NSUserDefaults standardUserDefaults] setBool:valid forKey:S_VALID_SUBSCRIPTION];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}


// headset view controller bubbles

+ (BOOL) tutorialShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kTutorialShownKey];
}

+ (BOOL) setTutorialShown:(BOOL)shown
{
    [[NSUserDefaults standardUserDefaults] setBool:shown forKey:kTutorialShownKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}


// groups view controller bubbles

+ (BOOL) groupsVCBubble1Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kGroupsVCBubble1ShownKey];
}

+ (BOOL) setGroupsVCBubble1Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kGroupsVCBubble1ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) groupsVCBubble2Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kGroupsVCBubble2ShownKey];
}

+ (BOOL) setGroupsVCBubble2Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kGroupsVCBubble2ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// headset view controller bubbles

+ (BOOL) headsetVCBubble1Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kHeadsetVCBubble1ShownKey];
}

+ (BOOL) setHeadsetVCBubble1Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kHeadsetVCBubble1ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// indoor locationing view controller bubbles

+ (BOOL) indoorLocVCBubble1Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kIndoorLocationingVCBubble1ShownKey];
}

+ (BOOL) setIndoorLocVCBubble1Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kIndoorLocationingVCBubble1ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) indoorLocVCBubble2Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kIndoorLocationingVCBubble2ShownKey];
}

+ (BOOL) setIndoorLocVCBubble2Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kIndoorLocationingVCBubble2ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) indoorLocVCBubble3Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kIndoorLocationingVCBubble3ShownKey];
}

+ (BOOL) setIndoorLocVCBubble3Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kIndoorLocationingVCBubble3ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// wifi ap info view controller bubbles

+ (BOOL) wifiAPVCBubble1Shown
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kWifiApInfoVCBubble1ShownKey];
}

+ (BOOL) setWifiAPVCBubble1Shown:(BOOL)shown
{
	[[NSUserDefaults standardUserDefaults] setBool:shown forKey:kWifiApInfoVCBubble1ShownKey];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// userName

+ (NSString*) userName
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:S_USER_NAME];
}

+ (BOOL) setUserName:(NSString*)name
{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:S_USER_NAME];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) userEmail
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:S_USER_EMAIL];
}

+ (BOOL) setUserEmail:(NSString*)email
{
	[[NSUserDefaults standardUserDefaults] setObject:email forKey:S_USER_EMAIL];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) userPassword
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:S_USER_PASSWORD];
}

+ (BOOL) setUserPassword:(NSString*)password
{
	[[NSUserDefaults standardUserDefaults] setObject:password forKey:S_USER_PASSWORD];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// userNameServer

+ (NSString*) userNameServer
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:S_USER_NAME_SERVER];
}

+ (BOOL) setUserNameServer:(NSString*)name
{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:S_USER_NAME_SERVER];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// full name

+ (NSString*) userFullName
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:S_USER_FULLNAME];
}

+ (BOOL) setUserFullName:(NSString*)name
{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:S_USER_FULLNAME];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// user id

+ (NSInteger) userID
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_USER_ID];
}

+ (BOOL) setUserID:(NSInteger)userID
{
	[[NSUserDefaults standardUserDefaults] setInteger:userID forKey:S_USER_ID];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// last user id

+ (NSString*) lastUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_LAST_USER_ID];
}

+ (BOOL) setLastUserID:(NSString*)lastUserID
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUserID forKey:S_LAST_USER_ID];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

// last user auth code

+ (NSString*) lastAuthCode {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_LAST_AUTH_CODE];
}

+ (BOOL) setLastAuthCode:(NSString *)lastAuthCode {
    [[NSUserDefaults standardUserDefaults] setObject:lastAuthCode forKey:S_LAST_AUTH_CODE];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

// user sex type

+ (NSInteger) userSex
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_USER_SEX];
}

+ (BOOL) setUserSex:(NSInteger)userSex
{
	[[NSUserDefaults standardUserDefaults] setInteger:userSex forKey:S_USER_SEX];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// user age

+ (NSInteger) userAge
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_USER_AGE];
}

+ (BOOL) setUserAge:(NSInteger)userAge
{
	[[NSUserDefaults standardUserDefaults] setInteger:userAge forKey:S_USER_AGE];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// user pin

+ (NSString*) userPIN
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:S_USER_PIN];
}

+ (BOOL) setUserPIN:(NSString*)userPIN
{
    DDLogInfo(@"AlertySettingsManager setUserPIN: %@", userPIN);
	[[NSUserDefaults standardUserDefaults] setObject:userPIN forKey:S_USER_PIN];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// user general info


+ (NSString*) userGeneralInfo
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:S_USER_GENERALINF];
}

+ (BOOL) setUserGeneralInfo:(NSString*)generalInfo
{
	[[NSUserDefaults standardUserDefaults] setObject:generalInfo forKey:S_USER_GENERALINF];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// ice contacts

+ (NSArray*) iceContacts
{
	return [[NSUserDefaults standardUserDefaults] arrayForKey:S_ICE_CONTACTS];
}

+ (BOOL) setIceContacts:(NSArray*)iceContacts
{
	[[NSUserDefaults standardUserDefaults] setObject:iceContacts forKey:S_ICE_CONTACTS];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// phone nr name

+ (NSString*) UserPhoneNr
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:S_USER_PHONE_NR];
}

+ (BOOL) setUserPhoneNr:(NSString*)phone
{
	[[NSUserDefaults standardUserDefaults] setObject:phone forKey:S_USER_PHONE_NR];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// max credit

+ (NSInteger) maxCredit
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_MAX_CREDIT];
}

+ (BOOL) setMaxCredit:(NSInteger)maxCredit
{
	[[NSUserDefaults standardUserDefaults] setInteger:maxCredit forKey:S_MAX_CREDIT];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// enable headset

+ (BOOL) headsetEnabled
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_ENABLE_HEADSET];
}

+ (BOOL) setHeadsetEnabled:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_ENABLE_HEADSET];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// alert message

+ (NSString*) alertMessage
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:S_ALERT_MESSAGE];
}

+ (BOOL) setAlertMessage:(NSString*)message
{
	[[NSUserDefaults standardUserDefaults] setObject:message forKey:S_ALERT_MESSAGE];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// max company contacts

+ (NSInteger) maxCompanyContacts
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_MAX_CCONTACTS];
}

+ (BOOL) setMaxCompanyContacts:(NSInteger)maxCompanyContacts
{
	[[NSUserDefaults standardUserDefaults] setInteger:maxCompanyContacts forKey:S_MAX_CCONTACTS];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// group ID (String)

+ (NSString*) groupID
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:S_GROUPID];
}

+ (BOOL) setGroupID:(NSString*)groupID
{
	[[NSUserDefaults standardUserDefaults] setObject:groupID forKey:S_GROUPID];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// business type (0=normal 1=subscription)

+ (NSInteger) businessType
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_BIZ_TYPE];
}

+ (BOOL) setBusinessType:(NSInteger)businessType
{
	[[NSUserDefaults standardUserDefaults] setInteger:businessType forKey:S_BIZ_TYPE];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// facebook use

+ (BOOL) hasUsedFacebookBefore
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_FIRST_FB_USE];
}

+ (BOOL) setHasUsedFacebookBefore:(BOOL)yesno
{
	[[NSUserDefaults standardUserDefaults] setBool:yesno forKey:S_FIRST_FB_USE];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

// preactivation

+ (BOOL) hasPreactivation
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_PREACTIVATION];
}

+ (BOOL) setPreactivation:(BOOL)enabled
{
	[[NSUserDefaults standardUserDefaults] setBool:enabled forKey:S_PREACTIVATION];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isBusinessVersion
{
	id isBusiness = [[NSUserDefaults standardUserDefaults] objectForKey:S_BUSINESS_VERSION];
	if (!isBusiness) return YES;
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_BUSINESS_VERSION];
}

+ (void) setBusinessVersion:(BOOL)business
{
	[[NSUserDefaults standardUserDefaults] setBool:business forKey:S_BUSINESS_VERSION];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

// max credit

+ (NSInteger) userInvites
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:S_INVITES];
}

+ (BOOL) setUserInvites:(NSInteger)userInvites
{
	[[NSUserDefaults standardUserDefaults] setInteger:userInvites forKey:S_INVITES];
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) addNoWifi: (NSString*) bssid {
	NSMutableArray* list = nil;
	id nowifi = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowifi"];
	if (nowifi && [nowifi isKindOfClass:[NSArray class]]) {
		list = [NSMutableArray arrayWithArray:(NSArray*)nowifi];
	} else if (nowifi && [nowifi isKindOfClass:[NSMutableArray class]]) {
		list = (NSMutableArray*)nowifi;
	}
	if (!list) list = [NSMutableArray array];
	[list addObject:bssid];
	[[NSUserDefaults standardUserDefaults] setObject:list forKey:@"nowifi"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) isNoWifi: (NSString*) bssid {
	NSMutableArray* list = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowifi"];
	if (!list) return NO;
	return ([list indexOfObject:bssid] != NSNotFound);
}


// sos mode
+ (int) sosMode
{
	return (int)[[NSUserDefaults standardUserDefaults] integerForKey:S_SOSMODE];
}

+ (void) setSosMode:(int)sosMode
{
	[[NSUserDefaults standardUserDefaults] setInteger:sosMode forKey:S_SOSMODE];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) firstRun {
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_FIRSTRUN];
}

+ (void) setFirstRun:(BOOL)firstRun {
	[[NSUserDefaults standardUserDefaults] setBool:firstRun forKey:S_FIRSTRUN];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) askNetwork {
	return [[NSUserDefaults standardUserDefaults] boolForKey:S_ASKNETWORK];
}

+ (void) setAskNetwork:(BOOL)askNetwork {
	[[NSUserDefaults standardUserDefaults] setBool:askNetwork forKey:S_ASKNETWORK];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate*) timer {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_TIMER];
    
}

+ (void) setTimer:(NSDate*)timer {
    [[NSUserDefaults standardUserDefaults] setObject:timer forKey:S_TIMER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) timerMessage {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_TIMER_MESSAGE];
}

+ (void) setTimerMessage:(NSString *)message {
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:S_TIMER_MESSAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) timerAddress {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_TIMER_ADDRESS];
}

+ (void) setTimerAddress:(NSString *)location {
    [[NSUserDefaults standardUserDefaults] setObject:location forKey:S_TIMER_ADDRESS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber*) timerLatitude {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_TIMER_LATITUDE];
}

+ (void) setTimerLatitude:(NSNumber *)latitude {
    [[NSUserDefaults standardUserDefaults] setObject:latitude forKey:S_TIMER_LATITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSNumber*) timerLongitude {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_TIMER_LONGITUDE];
}

+ (void) setTimerLongitude:(NSNumber *)longitude {
    [[NSUserDefaults standardUserDefaults] setObject:longitude forKey:S_TIMER_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDate*) homeTimer {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_HOME_TIMER];
    
}

+ (void) sethomeTimer:(NSDate*)timer {
    [[NSUserDefaults standardUserDefaults] setObject:timer forKey:S_HOME_TIMER];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) homeTimerMessage {
    return [[NSUserDefaults standardUserDefaults] objectForKey:S_HOME_TIMER_MESSAGE];
}

+ (void) sethomeTimerMessage:(NSString *)message {
    [[NSUserDefaults standardUserDefaults] setObject:message forKey:S_HOME_TIMER_MESSAGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




+ (double) aging {
    /*if ([[NSUserDefaults standardUserDefaults] objectForKey:S_AGING]) {
        return [[NSUserDefaults standardUserDefaults] doubleForKey:S_AGING];
    }*/
    return 0.05;
}

+ (void) setAging:(double)aging {
    [[NSUserDefaults standardUserDefaults] setDouble:aging forKey:S_AGING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL) tiltEnabled {
    return [NSUserDefaults.standardUserDefaults boolForKey:S_TILT_ENABLED];
}

+ (void) setTiltEnabled:(BOOL)tiltEnabled {
    [NSUserDefaults.standardUserDefaults setBool:tiltEnabled forKey:S_TILT_ENABLED];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (NSInteger) tiltValue {
    return [NSUserDefaults.standardUserDefaults integerForKey:S_TILT_VALUE];
}

+ (void) setTiltValue:(NSInteger)tiltValue {
    [NSUserDefaults.standardUserDefaults setInteger:tiltValue forKey:S_TILT_VALUE];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (BOOL) usePIN {
    if ([NSUserDefaults.standardUserDefaults objectForKey:S_USE_PIN]) {
        return [NSUserDefaults.standardUserDefaults boolForKey:S_USE_PIN];
    }
    return YES;
}

+ (void) setUsePIN:(BOOL)usePIN {
    [NSUserDefaults.standardUserDefaults setBool:usePIN forKey:S_USE_PIN];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (NSString*) roomName {
    return [[NSUserDefaults standardUserDefaults] stringForKey:S_VIDEO_ROOM_NAME];
}

+ (void) setRoomName:(NSString*)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:S_VIDEO_ROOM_NAME];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (NSString*) roomToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:S_VIDEO_TOKEN];
}

+ (void) setRoomToken:(NSString*)name {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:S_VIDEO_TOKEN];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
