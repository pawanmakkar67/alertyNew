//
//  AlertyDBMgr.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlertyDBMgr.h"
#import "NSExtensions.h"
#import "SynthesizeSingleton.h"

static NSString *const kContactEntity = @"Contacts";
static NSString *const kGroupEntity = @"Groups";
static NSString *const kWifiAPEntity = @"WifiAPs";
static NSString *const kMapEntity = @"Map";

@interface AlertyDBMgr ()
- (Contact *) insertNewContact;
- (Contact *) insertNewContactFromDictionary:(NSDictionary*)contactDict;
- (Contact *) insertNewContactFromDictionary:(NSDictionary*)contactDict toGroup:(Group *)toGroup;
- (WifiAP *) insertNewWifiAP;
- (WifiAP *) insertNewWifiAPFromDictionary:(NSDictionary*)wifiAPDict;
- (Group *) insertNewGroup;
- (Group *) insertNewGroupWithName:(NSString*)name ofType:(int)type;
@end


@implementation AlertyDBMgr

SYNTHESIZE_SINGLETON_FOR_CLASS(AlertyDBMgr);

#pragma mark - Public Static methods

+ (NSString *) internationalizeNumber:(NSString *)phone {
	return [[[[[[phone stringByReplacingOccurrencesOfString:@"+" withString:@"00"] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"\u00a0" withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
}

#pragma mark - Contacts

- (Contact *) insertNewContact {
	return (Contact *)[self insertNewObjectForEntityForName:kContactEntity];
}

- (Contact *) insertNewContactFromDictionary:(NSDictionary*)contactDict {
	return [self insertNewContactFromDictionary:contactDict toGroup:nil];
}

- (Contact *) insertNewContactFromDictionary:(NSDictionary*)contactDict toGroup:(Group *)toGroup {
	Contact *contact = [self insertNewContact];
	contact.phone = [contactDict objectForKey:@"phone"];
	contact.name = [contactDict objectForKey:@"name"];
	contact.type = [contactDict objectForKey:@"type"];
	contact.status = [contactDict objectForKey:@"status"];
    contact.online = contactDict[@"online"];
    contact.lastPosition = contactDict[@"lastPosition"];
	if( toGroup ) [contact addGroupsObject:toGroup];
	return contact;
}

- (NSArray *) getAllContacts {
	// fetch all objects from store
	return [self fetchAllObjectsInEntity:kContactEntity];
}

- (NSArray *) getAllContactsInActiveGroup {
	// fetch all objects from store in active group
	Group *group = [self getActiveGroup];
	return [[group contacts] allObjects];
}

- (NSInteger) countAllContacts {
	return [self countAllObjectsInEntity:kContactEntity];
}

- (NSInteger) countAllPersonalContacts {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 0"];
	return [self countAllObjectsInEntity:kContactEntity withPredicate:predicate];
}

- (NSInteger) countAllContactsInActiveGroup {
	Group *group = [self getActiveGroup];
	return [[group contacts] count];
}

- (void) delContact:(Contact*)contact {
	[self deleteObject:contact];
}

- (void) addContactFromDictionary:(NSDictionary*)contactDict toGroup:(Group *)toGroup {
	// create and setup contact in context
	[self insertNewContactFromDictionary:contactDict toGroup:toGroup];
	
	// save context
	[self saveManagedObjectContext];
}

- (void) addContactFromDictionary:(NSDictionary*)contactDict {
	[self addContactFromDictionary:contactDict toGroup:nil];
}

- (void) addContactsFromWS:(NSArray*)contacts {
	// add contacts to context
	Group *group = [self getActiveGroup];
	if( group ) {
		cmdlogtext(@"adding contacts to group %@", group.name)
		for (NSDictionary *contactDict in contacts) {
			[self insertNewContactFromDictionary:contactDict toGroup:group];
		}
	}
	
	// save context
	[self saveManagedObjectContext];
}

- (void) addBizContactsFromWS:(NSArray*)contacts {
	// add contacts to context
	Group *group = [self getEnterpriseGroup];
	if( group ) {
		cmdlogtext(@"adding contacts to group %@", group.name)
		for (NSDictionary *contactDict in contacts) {
			[self insertNewContactFromDictionary:contactDict toGroup:group];
		}
	}
	
	// save context
	[self saveManagedObjectContext];
}

- (void) delAllContacts {
	[self deleteAllObjectsInEntity:kContactEntity];
}

- (void) delAllBusinessContacts {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 1"];
	[self deleteAllObjectsInEntity:kContactEntity withPredicate:predicate];
}

- (BOOL) doesContactExistWithPhone:(NSString *)phone {
	if( ![self hasActiveGroup ] ) return NO;
	Group *activeGroup = [self getActiveGroup];
	return [self doesContactExistWithPhone:phone inGroup:activeGroup];
}

- (BOOL) doesContactExistWithPhone:(NSString *)phone inGroup:(Group *)group {
	BOOL found = NO;
	for( Contact *contact in group.contacts ) {
		NSString *phoneToCheck = [AlertyDBMgr internationalizeNumber:phone];
		NSString *phoneInDb = [AlertyDBMgr internationalizeNumber:contact.phone];
		if( [phoneInDb isEqualToString:phoneToCheck] ) {
			found = YES;
			break;
		}
	}
	return found;
}

- (void) updateContactWithPhone:(NSString*)phone status:(NSNumber*)status online:(NSNumber*)online lastPostion:(NSNumber*)lastPosition {
	phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
	phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
	NSArray *contacts = [self fetchAllObjectsInEntity:kContactEntity];
	for( Contact *contact in contacts ) {
		NSString* phoneNr = [contact.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
		phoneNr = [phoneNr stringByReplacingOccurrencesOfString:@" " withString:@""];
		phoneNr = [phoneNr stringByReplacingOccurrencesOfString:@"+" withString:@""];
		phoneNr = [phoneNr stringByReplacingOccurrencesOfString:@"-" withString:@""];
		phoneNr = [phoneNr stringByReplacingOccurrencesOfString:@"(" withString:@""];
		phoneNr = [phoneNr stringByReplacingOccurrencesOfString:@")" withString:@""];
		if ([phoneNr compare:phone] == NSOrderedSame) {
			contact.status = status;
            contact.online = online;
            contact.lastPosition = lastPosition;
		}
	}
	[self saveManagedObjectContext];
}

#pragma mark - WifiAPs

- (WifiAP *) temporaryWifiAP {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:kWifiAPEntity inManagedObjectContext:context];
    return [[WifiAP alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
}

- (WifiAP *) insertNewWifiAP {
	return (WifiAP *)[self insertNewObjectForEntityForName:kWifiAPEntity];
}

- (WifiAP *) insertNewWifiAPFromDictionary:(NSDictionary*)wifiAPDict {
	// create and setup wifiAP in context
	WifiAP *wifiAP = [self insertNewWifiAP];
	wifiAP.bssid = [wifiAPDict objectForKey:@"bssid"];
	wifiAP.name = [wifiAPDict objectForKey:@"name"];
	wifiAP.info = [wifiAPDict objectForKey:@"info"];
	wifiAP.type = [wifiAPDict objectForKey:@"type"];
	wifiAP.locationLat = [wifiAPDict objectForKey:@"locationLat"];
	wifiAP.locationLon = [wifiAPDict objectForKey:@"locationLon"];
    wifiAP.map = [wifiAPDict objectForKey:@"mapId"];
	return wifiAP;
}

- (NSArray *) getAllWifiAPs {
	// fetch all objects from store
	//return [self fetchAllObjectsInEntity:kWifiAPEntity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    // get managed object context
    NSManagedObjectContext *context = [self managedObjectContext];
    // get entity description
    NSEntityDescription *entity = [NSEntityDescription entityForName:kWifiAPEntity inManagedObjectContext:context];
    // create fetch request
    NSFetchRequest *fetchRequest = [self getFetchRequestWithEntity:entity andPredicate:nil];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    // return result of fetch request
    return [self executeFetchRequest:fetchRequest];
}

- (WifiAP *) getWifiApByBSSID:(NSString *)bssid {
    // get managed object context
    NSManagedObjectContext *context = [self managedObjectContext];
    // get entity description
    NSEntityDescription *entity = [NSEntityDescription entityForName:kWifiAPEntity inManagedObjectContext:context];
    // create fetch request
    NSFetchRequest *fetchRequest = [self getFetchRequestWithEntity:entity andPredicate:nil];
    // return result of fetch request
    NSArray *wifiAPs = [self executeFetchRequest:fetchRequest];
    
    for (NSInteger i=0; i<wifiAPs.count; i++) {
        WifiAP* ap = wifiAPs[i];

        NSString* pattern = [NSString stringWithFormat:@"^%@", [ap.bssid stringByReplacingOccurrencesOfString:@"X" withString:@"[0-9a-f]"]];
        NSError* error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

        NSUInteger count = [regex numberOfMatchesInString:bssid options:0 range:NSMakeRange(0, bssid.length)];
        if (count) {
            return ap;
        }
    }
    return nil;
}

- (void) addWifiAP:(WifiAP*)wifiAP {
	NSManagedObjectContext *context = [self managedObjectContext];
	[context insertObject:wifiAP];
	[self saveManagedObjectContext];
}

- (void) addWifiAPFromDict:(NSDictionary*)wifiAPDict {
	[self insertNewWifiAPFromDictionary:wifiAPDict];
	
	// save context
	[self saveManagedObjectContext];
}

- (void) addWifiAPsFromWS:(NSArray*)wifiAPs {
	// add wifiAPs to context
	for (NSDictionary *wifiAPDict in wifiAPs) {
		[self insertNewWifiAPFromDictionary:wifiAPDict];
	}
	
	// save context
	[self saveManagedObjectContext];
}

- (void) delWifiAP:(WifiAP*)wifiAP {
	[self deleteObject:wifiAP];
}

- (void) delAllWifiAPs {
	[self deleteAllObjectsInEntity:kWifiAPEntity];
}

- (void) delAllWifiAPsOfType:(int)type {
	NSDictionary *subVars = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:type] forKey:@"TYPE"];
	[self deleteAllObjectsWithTemplate:@"fetchWifiAPByType" subVars:subVars];
}

#pragma mark - Groups

- (NSArray *) getAllGroups {
	return [self fetchAllObjectsInEntity:kGroupEntity];
}

- (Group *) getActiveGroup {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 1"];
	NSArray *groups = [self fetchAllObjectsInEntity:kGroupEntity withPredicate:predicate];
	return [groups safeAt:0];
}

- (Group *) getEnterpriseGroup {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 2"];
	NSArray *groups = [self fetchAllObjectsInEntity:kGroupEntity withPredicate:predicate];
	return [groups safeAt:0];
}

- (void) delGroup:(Group*)group {
	NSSet* contacts = group.contacts;
	for(Contact* contact in contacts) {
		[self deleteObject:contact];
	}
	[self deleteObject:group];
}

- (void) delAllGroups {
	[self deleteAllObjectsInEntity:kGroupEntity];
}

- (Group *) insertNewGroup {
	return (Group *)[self insertNewObjectForEntityForName:kGroupEntity];
}

- (Group *) insertNewGroupWithName:(NSString*)name ofType:(int)type {
	Group *group = [self insertNewGroup];
	group.name = name;
	group.type = [NSNumber numberWithInt:type];
	return group;
}

- (BOOL) hasActiveGroup {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 1"];
	return [self countAllObjectsInEntity:kGroupEntity withPredicate:predicate] > 0;
}

- (BOOL) hasEnterpriseGroup {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == 2"];
	return [self countAllObjectsInEntity:kGroupEntity withPredicate:predicate] > 0;
}

- (void) addActiveGroup {
	[self insertNewGroupWithName:NSLocalizedString(@"MY CONTACTS", @"") ofType:1];
	[self saveManagedObjectContext];
}

- (void) addEnterpriseGroup {
	[self insertNewGroupWithName:NSLocalizedString(@"Default", @"") ofType:2];
	[self saveManagedObjectContext];
}

- (void) addActiveGroupIfNoneFound {
	if( ![self hasActiveGroup] ) {
		[self addActiveGroup];
	}
}

- (void) addEnterpriseGroupIfNoneFound {
	if( ![self hasEnterpriseGroup] ) {
		[self addEnterpriseGroup];
	}
}

- (void) removeEnterpriseGroupIfFound {
	Group* group = [self getEnterpriseGroup];
	if (group) {
		[self delGroup:group];
	}
}

- (void) addGroupWithName:(NSString*)name {
	[self insertNewGroupWithName:name ofType:0];
	[self saveManagedObjectContext];
}

- (void) setGroupActive:(Group*)group {
	NSArray *allGroups = [self fetchAllObjectsInEntity:kGroupEntity];
	for( Group *aGroup in allGroups ) {
		if ([aGroup.type intValue] == 2) continue; // enterprise groups cannot be made active
		int type = ( [group.objectID.URIRepresentation isEqual:aGroup.objectID.URIRepresentation] ) ? 1 : 0;
		aGroup.type = [NSNumber numberWithInt:type];
	}
	[self saveManagedObjectContext];
}

#pragma mark - Maps

- (void) deleteAllMaps {
    [self deleteAllObjectsInEntity:kMapEntity];
}

- (void)addMap:(IndoorMap *)map {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context insertObject:map];
    [self saveManagedObjectContext];
}

- (NSArray<IndoorMap*>*) getMaps {
    // fetch all objects from store
    return [self fetchAllObjectsInEntity:kMapEntity];
}

#pragma mark - NSFetchedResultsControllers

- (NSFetchedResultsController*) fetchedResultsControllerForGroups {
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
	NSEntityDescription *entity = [NSEntityDescription entityForName:kGroupEntity inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest *fetchRequest = [self getFetchRequestWithEntity:entity andPredicate:nil andSortDescriptor:sort];
	
	[fetchRequest setFetchBatchSize:20];
	
	// create FRC
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																								  managedObjectContext:[self managedObjectContext]
																									sectionNameKeyPath:@"type"
																											 cacheName:@"Root"];
	return theFetchedResultsController;
}

@end
