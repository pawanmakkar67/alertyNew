/*
 *  config.h
 *  Alerty
 *
 *  Created by moni on 4/26/11.
 *  Copyright 2011 __M/Users/viking/Documents/nat-rules.txtyCompanyName__. All rights reserved.
 *
 */

#ifndef alerty_config_h
#define alerty_config_h

#define IPAD_VIEW_MAX_WIDTH			768
#define IPAD_VIEW_MAX_HEIGHT		1024
#define NAVBAR_AND_STATBAR_HEIGHT	20

#define SOS_SYNC_INTERVAL			5			//in seconds
#define VIDEO_DURATION				10			//in seconds
#define TIMEOUT_INTERVAL			30

// man down manager
#define kMDMAccelerometerUpdateInterval		1.0 / 15.0;

// bubble view show length (-1 for perpetual)
#define kBVCBubbleViewTimeToShow			-1 // 5 mins for bubble view

// Alerty AppStore url
#define ALERTY_APPSTORE_URL		@"https://itunes.apple.com/us/app/alerty-personal/id496833687"

// URLs
#ifdef OPUS
#define HOME_URL				@"https://opuslf.getalerty.com"
//#define HOME_URL                @"https://portal.getalerty.com"
#elif defined(SAKERHETSAPPEN)
#define HOME_URL				@"https://sakappen.getalerty.com"
#else
//#define HOME_URL                @"https://alertytest.amigo.se"
#define HOME_URL                @"https://alerty.amigo.se"

//#define HOME_URL				@"https://portal.getalerty.com"
//#define HOME_URL                @"https://beta.getalerty.com"
#endif
#define HOME_URL_SE				@"http://www.alerty.se"
#define GOOGLE_STATICMAP		@"http://maps.google.com/maps/api/staticmap?"

#define DATA_URL				HOME_URL @"/wss/sync_new.php"
#define REGISTRATION_URL		HOME_URL @"/ws/register.php"
#define CHANGEPASSWORD_URL		HOME_URL @"/changepwd.php"
#define SEND_SOS_INVITATION		HOME_URL @"/ws/sendinvitation.php?p=%@&n=%@&userid=%ld&c=%ld&u=%@&lang=%@"
#define SEND_PURCHASE_RECEIPT	HOME_URL @"/wss/purchase.php"
#define MAPS_URL				HOME_URL @"/wss/maps.php"
#define SCREENSHOT_URL          HOME_URL @"/wss/screenshot.php"

#define REGISTER_TOKEN			HOME_URL @"/ws/registertoken.php"
#define GET_VIDEO_LIST			HOME_URL @"/ws/getpreviousalertsjson.php?userid=%ld"
#define GET_VIDEO_DATA			HOME_URL @"/ws/getvideodatajson.php?userid=%ld&id=%ld"

// sos
//#define SEND_PHONES				HOME_URL @"/ws/startalerttokbox2.php"
#define SEND_PHONES				HOME_URL @"/wss/startalert.php"
//#define SOS_VIDEO_URL			HOME_URL @"/sos_test.php?imei=%@&type=%@"		// audio/video
//#define STOP_SOS				HOME_URL @"/closesos_test.php?user=%i"			// audio/video
#define SOS_VIDEO_URL			HOME_URL @"/sos_ios.php?id=%i&type=%@"		// audio/video
#define STOP_SOS				HOME_URL @"/wss/closesos2.php?user=%ld&name=%@&lang=%@"			// audio/video

#define ADD_WIFI_URL			HOME_URL @"/ws/addwifi.php?name=%@&info=%@&bssid=%@&latitude=%f&longitude=%f&user=%ld"
#define CREATE_ACCOUNT_URL		HOME_URL @"/ws/createaccount.php"
#define LOGIN_URL				HOME_URL @"/wss/login.php"
#define RESET_PASSWORD_URL      HOME_URL @"/wss/resetpwd.php"
#define STAT_MAP_URL			HOME_URL @"/statmapget.php?lat=%@&lon=%@" //@"http://tah.openstreetmap.org/MapOf/?lat=%@&long=%@&z=14&w=200&h=200&format=jpeg"
#define UPDATE_USER_URL            HOME_URL @"/wss/updateuser.php" // contacts (json array (name, phone)), full_name, sex (int), age (int), general_info
#define ALERTY_INFO_URL			HOME_URL @"/ws/info_ios/%@"

#ifdef OPUS
#define FOLLOW_ME_INVITE_URL	@"https://opuslf.getalerty.com/followmap.php?id=%ld&lang=%@"
#else
#define FOLLOW_ME_INVITE_URL    @"https://alerty.amigo.se/followmap.php?id=%ld&lang=%@"
#endif
#define START_FOLLOW_ME_URL        HOME_URL @"/ws/followme.php"
#define START_FOLLOW_ME_URL_ORIG  HOME_URL @"/ws/startfollowme.php"
#define STOP_FOLLOW_ME_URL		HOME_URL @"/ws/stopfollowme.php"
#define USERDATA_URL              HOME_URL @"/ws/userdata.php"
#define NOTIFICATION_DETAIL_URL    HOME_URL @"/ws/get_key.php"

#define CONFIRMPHONE_URL		HOME_URL @"/wss/confirmphone.php"
#define STARTDIRECTCALL_URL		HOME_URL @"/ws/startdirectcalltwilio.php"
#define CANCELDIRECTCALL_URL	HOME_URL @"/ws/canceldirectcalltokbox.php"
#define CANCELDIRECTCALL2_URL	HOME_URL @"/ws/canceldirectcalltokbox2.php"
#define SETREFERRAL_URL			HOME_URL @"/ws/setreferral.php"
#define ACCEPTCALL_URL			HOME_URL @"/ws/accept.php"
#define SETVIDEOURL_URL			HOME_URL @"/ws/setvideourl.php"
#define STARTRECORDING_URL		HOME_URL @"/ws/startrecording.php"
#define ADDTIMER_URL			HOME_URL @"/ws/addtimer.php"
#define ADDALARM_URL            HOME_URL @"/ws/addalarm.php"

#define ADDFLICTEST_URL			HOME_URL @"/wss/addflictest.php"
#define ALERTTOKENCALL_URL      HOME_URL @"/wss/alerttoken.php"

// facebook id
#define kFacebookAPPID						@"239503656079296"

// admin status codes
#define REG_ADMIN_STATUS_FAILED				-1	// internal error
#define REG_ADMIN_STATUS_ADMIN_CREATED		 0  // an admin was created, info will be attached
#define REG_ADMIN_STATUS_NO_ADMIN_CREATED	 1  // no admin was created, group already had an admin

// keys in video plist
#define VIDEOS_DICT				@"videos"
#define VIDEO_TITLE				@"videotitle"
#define VIDEO_ID				@"id"
#define VIDEO_DATE				@"date"
#define VIDEO_STARTTIME			@"starttime"
#define VIDEO_ACCEPTEDTIME		@"accepted"
#define VIDEO_ACCEPTED_BY		@"friend"
#define VIDEO_CANCELTIME		@"canceltime"
#define VIDEO_URL				@"video"
#define VIDEO_POLYLINE			@"polyline"
#define VIDEO_MAP_BOUNDS		@"bounds"
#define VIDEO_MAP_SW			@"sw"
#define VIDEO_MAP_NE			@"ne"
#define VIDEO_STARTLAT			@"startlat"
#define VIDEO_STARTLONG			@"startlong"
#define VIDEO_TRACKING			@"tracking"
#define VIDEO_SOURCE			@"source"
#define VIDEO_EXTRA				@"extra"

// notifications
#define kSyncFinishedNotification			@"kSyncFinishedNotification"
#define kManDownNotification				@"kManDownNotification"
#define kNotifRegistrationSuccessful		@"kNotifRegistrationSuccessful"
#define kNotifRegistrationFailed			@"kNotifRegistrationFailed"
#define kFollowMeAcceptedNotification		@"kFollowMeAcceptedNotification"
#define kAlertCreatedNotification			@"kAlertCreatedNotification"
#define kUserIdReceivedNotification         @"kUserIdReceivedNotification"
#define kFollowMeFollowingNotification      @"kFollowMeFollowingNotification"

// helpers
#define DEVICE_ID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
//#define DEVICE_ID @"CCA86D28-69D2-448D-B3D8-FC2F1C8BB3D8"

#define OPENTOK_API_KEY @"45135692"

#define ALERT_SOURCE_BUTTON                 0
#define ALERT_SOURCE_MANDOWN                1
#define ALERT_SOURCE_TIMER                  2
#define ALERT_SOURCE_PEBBLE                 3
#define ALERT_SOURCE_EXTERNAL_BUTTON        4
#define ALERT_SOURCE_WEB                    5
#define ALERT_SOURCE_TWILIO                 6

extern NSString* const ALERTINFOCALL_URL;

#endif // alerty_config_h
