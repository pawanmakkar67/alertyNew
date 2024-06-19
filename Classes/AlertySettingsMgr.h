//
//  AlertySettingsMgr.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kWifiAPTypeUser = 0,
	kWifiAPTypeCompany,
	kWifiAPTypeAdd,
    kWifiAPTypeBeaconPrivate,
    kWifiAPTypeBeaconCompany
} kWifiAPType;

typedef enum {
	kContactStatusUnspecified = -1,
	kContactStatusInvited,
	kContactStatusAccepted,
	kContactStatusRejected
} kContactStatus;

@interface AlertySettingsMgr : NSObject

+ (BOOL) hasManDownMgr;
+ (BOOL) setManDownManager:(BOOL)enabled;
+ (BOOL) hasFollowMe;
+ (BOOL) setFollowMe:(BOOL)enabled;
+ (BOOL) hasPlus;
+ (BOOL) setPlus:(BOOL)enabled;
+ (BOOL) hasFacebook;
+ (BOOL) hasIndoorLocationing;
+ (BOOL) setIndoorLocationing:(BOOL)enabled;
+ (BOOL) hasSosAlarm;
+ (BOOL) setSosAlarm:(BOOL)enabled;

+ (BOOL) tutorialShown;
+ (BOOL) setTutorialShown:(BOOL)shown;

+ (BOOL) groupsVCBubble1Shown;
+ (BOOL) setGroupsVCBubble1Shown:(BOOL)shown;
+ (BOOL) groupsVCBubble2Shown;
+ (BOOL) setGroupsVCBubble2Shown:(BOOL)shown;
+ (BOOL) headsetVCBubble1Shown;
+ (BOOL) setHeadsetVCBubble1Shown:(BOOL)shown;
+ (BOOL) indoorLocVCBubble1Shown;
+ (BOOL) setIndoorLocVCBubble1Shown:(BOOL)shown;
+ (BOOL) indoorLocVCBubble2Shown;
+ (BOOL) setIndoorLocVCBubble2Shown:(BOOL)shown;
+ (BOOL) indoorLocVCBubble3Shown;
+ (BOOL) setIndoorLocVCBubble3Shown:(BOOL)shown;
+ (BOOL) wifiAPVCBubble1Shown;
+ (BOOL) setWifiAPVCBubble1Shown:(BOOL)shown;

+ (NSString*) userName;
+ (BOOL) setUserName:(NSString*)name;
+ (NSString*) userEmail;
+ (BOOL) setUserEmail:(NSString*)email;
+ (NSString*) userPassword;
+ (BOOL) setUserPassword:(NSString*)password;
+ (NSString*) userNameServer;
+ (BOOL) setUserNameServer:(NSString*)name;
+ (NSString*) userFullName;
+ (BOOL) setUserFullName:(NSString*)name;
+ (NSInteger) userID;
+ (BOOL) setUserID:(NSInteger)userID;
+ (NSInteger) userSex;
+ (BOOL) setUserSex:(NSInteger)userSex;
+ (NSInteger) userAge;
+ (BOOL) setUserAge:(NSInteger)userAge;
+ (NSString*) userPIN;
+ (BOOL) setUserPIN:(NSString*)userPIN;
+ (NSString*) userGeneralInfo;
+ (BOOL) setUserGeneralInfo:(NSString*)generalInfo;
+ (NSArray*) iceContacts;
+ (BOOL) setIceContacts:(NSArray*)iceContacts;
+ (NSInteger) maxCredit;
+ (NSString*) UserPhoneNr;
+ (BOOL) setUserPhoneNr:(NSString*)phone;
+ (BOOL) setMaxCredit:(NSInteger)maxCredit;
+ (BOOL) headsetEnabled;
+ (BOOL) setHeadsetEnabled:(BOOL)enabled;
+ (NSString*) alertMessage;
+ (BOOL) setAlertMessage:(NSString*)message;
+ (NSInteger) maxCompanyContacts;
+ (BOOL) setMaxCompanyContacts:(NSInteger)maxCompanyContacts;
+ (NSString*) groupID;
+ (BOOL) setGroupID:(NSString*)groupID;
+ (NSInteger) businessType;
+ (BOOL) setBusinessType:(NSInteger)businessType;
+ (BOOL) hasUsedFacebookBefore;
+ (BOOL) setHasUsedFacebookBefore:(BOOL)yesno;
+ (BOOL) hasPreactivation;
+ (BOOL) setPreactivation:(BOOL)enabled;

+ (BOOL) isBusinessVersion;
+ (void) setBusinessVersion:(BOOL)business;

+ (double) manDownLevel;
+ (BOOL) setManDownLevel:(double)level;
+ (BOOL) trackingEnabled;
+ (BOOL) setLastPositionEnabled:(BOOL)enabled;

+ (BOOL) lastPositionEnabled;

+ (BOOL) setLAlarmEnabled:(BOOL)enabled;

+ (BOOL) lAlarmEnabled;

+ (BOOL) setTrackingEnabled:(BOOL)enabled;
+ (NSDate* _Nullable) lastPositionDate;
+ (BOOL) setLastPositionDate:(NSDate* _Nullable)date;

+ (BOOL) discreteModeEnabled;
+ (BOOL) setDiscreteModeEnabled:(BOOL)enabled;

+ (BOOL) frontCameraEnabled;
+ (BOOL) setFrontCameraEnabled:(BOOL)enabled;

+ (BOOL) screenshotEnabled;
+ (BOOL) setScreenshotEnabled:(BOOL)enabled;

+ (BOOL) speakerEnabled;
+ (BOOL) setSpeakerEnabled:(BOOL)enabled;

+ (NSInteger) userInvites;
+ (BOOL) setUserInvites:(NSInteger)userInvites;

+ (void) addNoWifi: (NSString*) bssid;
+ (BOOL) isNoWifi: (NSString*) bssid;

+ (int) sosMode;
+ (void) setSosMode:(int)sosMode;

+ (BOOL) firstRun;
+ (void) setFirstRun:(BOOL)firstRun;

+ (BOOL) askNetwork;
+ (void) setAskNetwork:(BOOL)askNetwork;

+ (NSDate*) timer;
+ (void) setTimer:(NSDate*)timer;

+ (NSString*) timerMessage;
+ (void) setTimerMessage:(NSString*)message;

+ (NSString*) timerAddress;
+ (void) setTimerAddress:(NSString*)location;

+ (NSNumber*) timerLatitude;
+ (void) setTimerLatitude:(NSNumber *)latitude;

+ (NSNumber*) timerLongitude;
+ (void) setTimerLongitude:(NSNumber *)latitude;

+ (NSDate*) homeTimer;
+ (void) sethomeTimer:(NSDate*)timer;

+ (NSString*) homeTimerMessage;
+ (void) sethomeTimerMessage:(NSString*)message;


+ (double) aging;
+ (void) setAging:(double)aging;

+ (NSString*) lastUserID;
+ (BOOL) setLastUserID:(NSString*)lastUserID;
+ (NSString*) lastAuthCode;
+ (BOOL) setLastAuthCode:(NSString*)lastUserID;

+ (BOOL) tiltEnabled;
+ (void) setTiltEnabled:(BOOL)tiltEnabled;

+ (NSInteger) tiltValue;
+ (void) setTiltValue:(NSInteger)tiltValue;

+ (BOOL) usePIN;
+ (void) setUsePIN:(BOOL)usePIN;

+ (NSString* _Nullable) roomName;
+ (void) setRoomName:(NSString* _Nullable)roomName;

+ (NSString* _Nullable) roomToken;
+ (void) setRoomToken:(NSString* _Nullable)roomToken;

@end
