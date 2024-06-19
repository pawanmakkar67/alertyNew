//
//  FMDatabaseCustomAdditions.h
//
//  Created by Bence Balint on 10/14/13.
//  Copyright (c) 2013 viking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface FMDatabase (ExtendedMethods)


// shorthand methods
+ (NSString*) selectSentence:(NSString*)table fields:(NSArray*)fields;
+ (NSString*) insertSentence:(NSString*)table fields:(NSArray*)fields;
+ (NSString*) updateSentence:(NSString*)table fields:(NSArray*)fields primary:(NSString*)primary;
+ (NSString*) deleteSentence:(NSString*)table fields:(NSArray*)fields;
+ (NSString*) deleteSentence:(NSString*)table primary:(NSString*)primary;

// helper methods
+ (FMDatabase*) openDatabase:(NSString*)path;
+ (FMDatabase*) openOrCreateDatabase:(NSString*)path creationBlock:(BOOL (^)(FMDatabase *db))block;
+ (BOOL) deleteDatabase:(FMDatabase*)db path:(NSString*)path;
+ (FMDatabase*) createDatabase:(NSString*)path creationBlock:(BOOL (^)(FMDatabase *db))block;
+ (FMDatabase*) resetDatabase:(FMDatabase*)db path:(NSString*)path creationBlock:(BOOL (^)(FMDatabase *db))block;
+ (void) closeDatabase:(FMDatabase*)db;

// db methods
- (NSNumber*) version;
- (NSNumber*) lastInsertedRowId;
- (NSNumber*) maxId:(NSString*)table fieldName:(NSString*)field;
- (BOOL) transaction;
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
- (NSNumber*) insert:(NSString*)table rows:(NSArray*)rows;
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
