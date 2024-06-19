//
//  FMDatabaseQueueCustomAdditions.h
//
//  Created by Bence Balint on 10/14/13.
//  Copyright (c) 2013 viking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"


@interface FMDatabaseQueue (ExtendedMethods)

// helper methods
+ (FMDatabaseQueue*) openDatabase:(NSString*)path;
+ (FMDatabaseQueue*) openOrCreateDatabase:(NSString*)path creationBlock:(BOOL (^)(FMDatabaseQueue *dbq))block;
+ (BOOL) deleteDatabase:(FMDatabaseQueue*)dbq path:(NSString*)path;
+ (FMDatabaseQueue*) createDatabase:(NSString*)path creationBlock:(BOOL (^)(FMDatabaseQueue *dbq))block;
+ (FMDatabaseQueue*) resetDatabase:(FMDatabaseQueue*)dbq path:(NSString*)path creationBlock:(BOOL (^)(FMDatabaseQueue *dbq))block;
+ (void) closeDatabase:(FMDatabaseQueue*)dbq;

// db methods
- (NSNumber*) version;
- (NSNumber*) lastInsertedRowId;
- (NSNumber*) maxId:(NSString*)table fieldName:(NSString*)field;
- (BOOL) inTransaction;
- (BOOL) transaction;
- (BOOL) commit;
- (BOOL) rollback;
- (BOOL) execute:(NSString*)sentence;
- (BOOL) execute:(NSString*)sentence row:(NSDictionary*)row;
- (BOOL) execute:(NSString*)sentence rows:(NSArray*)rows;
- (NSMutableArray*) query:(NSString*)sentence;
- (NSMutableArray*) query:(NSString*)sentence row:(NSDictionary*)row;
- (NSMutableArray*) query:(NSString*)sentence rows:(NSArray*)rows;
- (NSNumber*) queryInteger:(NSString*)sentence;
- (NSNumber*) queryFloat:(NSString*)sentence;
- (NSNumber*) count:(NSString*)table whereString:(NSString*)where;
- (NSNumber*) insert:(NSString*)table row:(NSDictionary*)row;
- (NSNumber*) insert:(NSString*)table rows:(NSArray*)rows;									// gives back last inserted row id, or nil on error
- (BOOL) update:(NSString*)table row:(NSDictionary*)row primary:(NSString*)primary;
- (BOOL) update:(NSString*)table rows:(NSArray*)rows primary:(NSString*)primary;
- (BOOL) delete:(NSString*)table row:(NSDictionary*)row primary:(NSString*)primary;
- (BOOL) delete:(NSString*)table rows:(NSArray*)rows primary:(NSString*)primary;
- (BOOL) deleteAll:(NSString*)table;
- (BOOL) delete:(NSString*)table whereString:(NSString*)where;
- (BOOL) delete:(NSString*)table whereDictionary:(NSDictionary*)dictionary;
- (NSMutableArray*) select:(NSString*)table idx:(NSNumber*)idx primary:(NSString*)primary;
- (NSMutableArray*) select:(NSString*)table fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (NSMutableArray*) select:(NSString*)table fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit whereString:(NSString*)where;
- (NSMutableArray*) select:(NSString*)table whereString:(NSString*)where;
- (NSMutableArray*) select:(NSString*)table whereDictionary:(NSDictionary*)dictionary;
- (NSMutableArray*) backward:(NSString*)table fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (NSMutableArray*) backward:(NSString*)table fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit whereString:(NSString*)where;
- (NSMutableArray*) backward:(NSString*)table whereString:(NSString*)where;
- (NSMutableArray*) distinct:(NSString*)table primary:(NSString*)primary fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (NSMutableArray*) distinct:(NSString*)table primary:(NSString*)primary fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit whereString:(NSString*)where;
- (NSMutableArray*) distinct:(NSString*)table primary:(NSString*)primary whereString:(NSString*)where;
- (NSMutableArray*) distinctBackward:(NSString*)table primary:(NSString*)primary fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (NSMutableArray*) distinctBackward:(NSString*)table primary:(NSString*)primary fromOffset:(NSUInteger)offset withLimit:(NSUInteger)limit whereString:(NSString*)where;
- (NSMutableArray*) distinctBackward:(NSString*)table primary:(NSString*)primary whereString:(NSString*)where;
- (BOOL) exist:(NSString*)table idx:(NSNumber*)idx primary:(NSString*)primary;
- (BOOL) save:(NSString*)table row:(NSDictionary*)row primary:(NSString*)primary;			// insert / update
- (BOOL) save:(NSString*)table rows:(NSArray*)rows primary:(NSString*)primary;				// insert / update

// management methods
- (NSInteger) cacheSize;
- (BOOL) setCacheSize:(NSInteger)pages;
- (NSInteger) pageSize;
- (BOOL) setPageSize:(NSInteger)size;
- (NSInteger) pageCount;
- (NSInteger) maxPageCount;
- (BOOL) setMaxPageCount:(NSInteger)count;

@end
