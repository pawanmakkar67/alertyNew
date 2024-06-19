//
//  MWStores.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryConfig.h"
#import "AbstractSingleton.h"
#if HAVE_FMDATABASE
#import "FMDatabaseQueue.h"
#endif

@interface MWStoreBase : AbstractSingleton
{
	NSMutableDictionary *_store;
	NSMutableDictionary *_kepts;
}

+ (id) instance;

+ (void) reset;
+ (void) resetNonKepts;
+ (void) purgeNonKepts;
+ (BOOL) pushItem:(id)item forKey:(id)key;
+ (BOOL) popItem:(id)key;
+ (BOOL) popItem:(id)key delete:(BOOL)del;
+ (void) popAll;
+ (id) item:(id)key;
+ (BOOL) load:(id)key;
+ (void) loadAll;
+ (void) save:(id)key;
+ (void) saveAll;
+ (void) delete:(id)key;
+ (void) deleteAll;
+ (void) deleteOlderThan:(NSDate*)date byLastAccess:(BOOL)lastAccess;		// last access timestamp is not accessible by the FS (always set to creation date) so delete by modification date
+ (NSString*) storePath:(id)key;
+ (void) keep:(id)keeper key:(id)key;
+ (void) unkeep:(id)keeper key:(id)key;
+ (void) unkeepAll:(id)keeper;

// conversion methods
+ (NSData*) dataFromItem:(id)item;
+ (id) itemFromData:(NSData*)data;

@end


@interface MWStoreBase ()
@property (readwrite,retain) NSMutableDictionary *store;
@property (readwrite,retain) NSMutableDictionary *kepts;
+ (void) didReceiveMemoryWarning:(NSNotification*)notification;
+ (void) didReceiveApplicationTerminate:(NSNotification*)notification;
+ (BOOL) createOrDeleteBaseResource:(BOOL)create;
+ (NSData*) loadData:(id)key;
+ (BOOL) saveData:(NSData*)data forKey:(id)key;
+ (BOOL) deleteData:(id)key;
+ (BOOL) acceptItem:(id)item;
+ (id) createNewItem;
+ (NSString*) plainKey:(id)key;
@end


@interface MWDataStore : MWStoreBase
@end

@interface MWStringStore : MWStoreBase
@end

@interface MWArrayStore : MWStoreBase
@end

@interface MWDictionaryStore : MWStoreBase
@end

@interface MWMutableDataStore : MWStoreBase
@end

@interface MWMutableStringStore : MWStoreBase
@end

@interface MWMutableArrayStore : MWStoreBase
@end

@interface MWMutableDictionaryStore : MWStoreBase
@end

@interface MWImageStore : MWStoreBase
@end


#if HAVE_FMDATABASE
@interface MWSQLStoreBase : MWStoreBase
{
	FMDatabaseQueue *_databaseQueue;
}

+ (FMDatabaseQueue*) databaseQueue;

@end


@interface MWSQLStoreBase ()
@property (readwrite,retain) FMDatabaseQueue *databaseQueue;
+ (NSString*) databaseName;
+ (NSString*) tableName;
+ (NSString*) primaryKey;
+ (NSString*) dataKey;
+ (BOOL) createTables:(FMDatabaseQueue*)dbq;
+ (NSDictionary*) loadCompleteData:(id)key;
@end


@interface MWSQLDataStore : MWSQLStoreBase
@end

@interface MWSQLStringStore : MWSQLStoreBase
@end

@interface MWSQLArrayStore : MWSQLStoreBase
@end

@interface MWSQLDictionaryStore : MWSQLStoreBase
@end

@interface MWSQLMutableDataStore : MWSQLStoreBase
@end

@interface MWSQLMutableStringStore : MWSQLStoreBase
@end

@interface MWSQLMutableArrayStore : MWSQLStoreBase
@end

@interface MWSQLMutableDictionaryStore : MWSQLStoreBase
@end

@interface MWSQLImageStore : MWSQLStoreBase
@end
#endif
