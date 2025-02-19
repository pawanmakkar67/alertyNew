//
//  CoreDataMgr.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataMgr.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"

@interface CoreDataMgr ()
@end

@implementation CoreDataMgr

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


#pragma mark - Public methods

- (NSFetchRequest*) getFetchRequestWithEntity:(NSEntityDescription*)entity
								 andPredicate:(NSPredicate*)predicate
							andSortDescriptor:(NSSortDescriptor*)sortDescriptor
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	if (entity) [fetchRequest setEntity:entity];
	if (predicate) [fetchRequest setPredicate:predicate];
	if (sortDescriptor) [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
	return fetchRequest;
}

- (NSFetchRequest*) getFetchRequestWithEntity:(NSEntityDescription*)entity
								 andPredicate:(NSPredicate*)predicate
{
	return [self getFetchRequestWithEntity:entity andPredicate:predicate andSortDescriptor:nil];
}

- (NSFetchRequest*) getFetchRequestFromTemplate:(NSString*)templateName
									withSubVars:(NSDictionary*)subVars
{
	NSManagedObjectModel *objectModel = [self managedObjectModel];
	NSFetchRequest *fetchRequest = subVars == nil ? [objectModel fetchRequestTemplateForName:templateName] : [objectModel fetchRequestFromTemplateWithName:templateName substitutionVariables:subVars];
	return fetchRequest;
}

- (NSArray*) executeFetchRequest:(NSFetchRequest*)fetchRequest
{
	// get managed object context
	NSManagedObjectContext *context = [self managedObjectContext];
	// return result of fetch request
	NSError *error = nil;
	NSArray *ret = [context executeFetchRequest:fetchRequest error:&error];
	if (error) {
		cmdlogtext(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	return ret;
}

- (NSUInteger) executeCountRequest:(NSFetchRequest*)fetchRequest
{
	// get managed object context
	NSManagedObjectContext *context = [self managedObjectContext];
	// return result of fetch request
	NSError *error = nil;
	NSUInteger ret = [context countForFetchRequest:fetchRequest error:&error];
	if (error) {
		cmdlogtext(@"Unresolved error %@, %@", error, [error userInfo]);
	}
	return ret;
}

- (NSManagedObject*) insertNewObjectForEntityForName:(NSString*)entityName
{
	NSManagedObjectContext *context = [self managedObjectContext];
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
}

- (NSArray*) fetchAllObjectsInEntity:(NSString*)entityName {
	return [self fetchAllObjectsInEntity:entityName withPredicate:nil];
}

- (NSArray*) fetchAllObjectsInEntity:(NSString*)entityName
					   withPredicate:(NSPredicate*)predicate
{
	// get managed object context
	NSManagedObjectContext *context = [self managedObjectContext];
	// get entity description
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	// create fetch request
	NSFetchRequest *fetchRequest = [self getFetchRequestWithEntity:entity andPredicate:predicate];
	// return result of fetch request
	return [self executeFetchRequest:fetchRequest];
}

- (NSArray*) fetchAllObjectsWithTemplate:(NSString*)templateName
								 subVars:(NSDictionary*)subVars
{
	// create fetch request from template
	NSFetchRequest *fetchRequest = [self getFetchRequestFromTemplate:templateName withSubVars:subVars];
	// return result of fetch request
	return [self executeFetchRequest:fetchRequest];
}

- (NSUInteger) countAllObjectsInEntity:(NSString*)entityName
{
	return [self countAllObjectsInEntity:entityName withPredicate:nil];
}

- (NSUInteger) countAllObjectsInEntity:(NSString*)entityName
						 withPredicate:(NSPredicate*)predicate
{
	// get managed object context
	NSManagedObjectContext *context = [self managedObjectContext];
	// get entity description
    if (entityName !=  nil) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        // create fetch request
        NSFetchRequest *fetchRequest = [self getFetchRequestWithEntity:entity andPredicate:predicate];
        // return result of fetch count
        return [self executeCountRequest:fetchRequest];
    }
}

- (NSUInteger) countAllObjectsWithTemplate:(NSString*)templateName
								   subVars:(NSDictionary*)subVars
{
	// create fetch request from template
	NSFetchRequest *fetchRequest = [self getFetchRequestFromTemplate:templateName withSubVars:subVars];
	// return result of fetch request
	return [self executeCountRequest:fetchRequest];
}

- (void) deleteObject:(NSManagedObject *)object
{
	NSManagedObjectContext *context = [self managedObjectContext];
	[context deleteObject:object];
	[self saveManagedObjectContext];
}

- (void) deleteAllObjectsInEntity:(NSString*)entityName
{
	[self deleteAllObjectsInEntity:entityName withPredicate:nil];
}

- (void) deleteAllObjectsInEntity:(NSString*)entityName
					withPredicate:(NSPredicate*)predicate
{
	// get managed object context
	NSManagedObjectContext *context = [self managedObjectContext];
	// fetch all objects
	NSArray *objects = [self fetchAllObjectsInEntity:entityName withPredicate:predicate];
	// set all objects deleted
	for( NSManagedObject *object in objects ) {
		[context deleteObject:object];
	}
	// save context 
	[self saveManagedObjectContext];
}

- (void) deleteAllObjectsWithTemplate:(NSString*)templateName
							  subVars:(NSDictionary*)subVars
{
	// get managed object context
	NSManagedObjectContext *context = [self managedObjectContext];
	// fetch all objects
	NSArray *objects = [self fetchAllObjectsWithTemplate:templateName subVars:subVars];
	// set all objects deleted
	for( NSManagedObject *object in objects ) {
		[context deleteObject:object];
	}
	// save context 
	[self saveManagedObjectContext];
}

- (void) saveManagedObjectContext
{
	NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges]) {
			if( ![managedObjectContext save:&error] ) {
				cmdlogtext(@"Unresolved error %@, %@", error, [error userInfo]);
			}
        }
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Alerty" withExtension:@"mom"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[AlertyAppDelegate applicationDocumentsDirectory] URLByAppendingPathComponent:@"Alerty.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES};
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        cmdlogtext(@"Unresolved error %@, %@", error, [error userInfo]);
		//        abort();
    }    
    
    return __persistentStoreCoordinator;
}

@end
