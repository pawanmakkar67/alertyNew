//
//  CoreDataMgr.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataMgr : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// save managed object context
- (void) saveManagedObjectContext;

// new object in entity
- (NSManagedObject*) insertNewObjectForEntityForName:(NSString*)entityName;

// fetchRequest creation/execution
- (NSFetchRequest*) getFetchRequestWithEntity:(NSEntityDescription*)entity
								 andPredicate:(NSPredicate*)predicate
							andSortDescriptor:(NSSortDescriptor*)sortDescriptor;

- (NSFetchRequest*) getFetchRequestWithEntity:(NSEntityDescription*)entity
								 andPredicate:(NSPredicate*)predicate;

- (NSFetchRequest*) getFetchRequestFromTemplate:(NSString*)templateName
									withSubVars:(NSDictionary*)subVars;
- (NSArray*) executeFetchRequest:(NSFetchRequest*)request;
- (NSUInteger) executeCountRequest:(NSFetchRequest*)fetchRequest;

// fetch objects
- (NSArray*) fetchAllObjectsInEntity:(NSString*)entityName;
- (NSArray*) fetchAllObjectsInEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (NSArray*) fetchAllObjectsWithTemplate:(NSString*)templateName subVars:(NSDictionary*)subVars;

// count objects
- (NSUInteger) countAllObjectsInEntity:(NSString*)entityName;
- (NSUInteger) countAllObjectsInEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (NSUInteger) countAllObjectsWithTemplate:(NSString*)templateName subVars:(NSDictionary*)subVars;

// delete objects
- (void) deleteObject:(NSManagedObject*)object;
- (void) deleteAllObjectsInEntity:(NSString*)entityName;
- (void) deleteAllObjectsInEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;
- (void) deleteAllObjectsWithTemplate:(NSString*)templateName subVars:(NSDictionary*)subVars;

@end
