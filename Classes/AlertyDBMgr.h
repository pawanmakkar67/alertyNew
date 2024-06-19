//
//  AlertyDBMgr.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataMgr.h"
#import "Group.h"
#import "Contact.h"
#import "WifiAP.h"
#import "IndoorMap.h"

@interface AlertyDBMgr : CoreDataMgr

// static methods
+ (AlertyDBMgr*)sharedAlertyDBMgr;
+ (NSString*) internationalizeNumber:(NSString*)phone;

// contacts
- (NSArray*) getAllContacts;
- (NSArray*) getAllContactsInActiveGroup;
- (NSInteger) countAllContacts;
- (NSInteger) countAllPersonalContacts;
- (NSInteger) countAllContactsInActiveGroup;
- (void) addContactFromDictionary:(NSDictionary*)contact;
- (void) addContactFromDictionary:(NSDictionary*)contactDict toGroup:(Group*)toGroup;
- (void) addContactsFromWS:(NSArray*)contacts;
- (void) addBizContactsFromWS:(NSArray*)contacts;
- (void) delContact:(Contact*)contact;
- (void) delAllContacts;
- (void) delAllBusinessContacts;
- (BOOL) doesContactExistWithPhone:(NSString*)phone;
- (BOOL) doesContactExistWithPhone:(NSString*)phone inGroup:(Group*)group;
- (void) updateContactWithPhone:(NSString*)phone status:(NSNumber*)status online:(NSNumber*)online lastPostion:(NSNumber*)lastPosition;

// wifiAPs
- (WifiAP*) temporaryWifiAP;
- (WifiAP*) getWifiApByBSSID:(NSString*)bssid;
- (NSArray*) getAllWifiAPs;
- (void) addWifiAP:(WifiAP*)wifiAP;
- (void) addWifiAPFromDict:(NSDictionary*)wifiAP;
- (void) addWifiAPsFromWS:(NSArray*)wifiAPs;
- (void) delWifiAP:(WifiAP*)wifiAP;
- (void) delAllWifiAPs;
- (void) delAllWifiAPsOfType:(int)type;

// groups
- (BOOL) hasActiveGroup;
- (BOOL) hasEnterpriseGroup;
- (void) addActiveGroup;
- (void) addEnterpriseGroup;
- (void) addActiveGroupIfNoneFound;
- (void) addEnterpriseGroupIfNoneFound;
- (Group*) getActiveGroup;
- (Group *) getEnterpriseGroup;
- (NSArray*) getAllGroups;
- (void) delGroup:(Group*)group;
- (void) delAllGroups;
- (void) addGroupWithName:(NSString*)name;
- (void) setGroupActive:(Group*)group;
- (void) removeEnterpriseGroupIfFound;

// fetched results controllers
- (NSFetchedResultsController*) fetchedResultsControllerForGroups;

- (void) deleteAllMaps;
- (void) addMap:(IndoorMap*)map;
- (NSArray<IndoorMap*>*) getMaps;

@end
