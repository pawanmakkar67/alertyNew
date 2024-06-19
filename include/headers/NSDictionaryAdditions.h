//
//  NSDictionaryAdditions.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (ExtendedMethods)

+ (NSDictionary*) openFile:(NSString*)path;
+ (NSDictionary*) openFile:(NSString*)path error:(NSError**)error;
- (BOOL) saveAs:(NSString*)path;
- (BOOL) saveAs:(NSString*)path error:(NSError**)error;

// underlying NSData will give back NSDictionary or NSArray depending on the structure of the JSON string
+ (id) openJSON:(NSString*)path;
+ (id) openJSON:(NSString*)path error:(NSError**)error;
+ (id) openPList:(NSString*)path;
+ (id) openPList:(NSString*)path error:(NSError**)error;
+ (id) openXML:(NSString*)path;
+ (id) openXML:(NSString*)path error:(NSError**)error;

// case insensitive indexing
- (NSUInteger) indexOfCaseInsensitiveString:(NSString*)aString;

- (NSData*) csvData;
- (NSData*) csvData:(NSError**)error;
- (NSData*) csvData:(NSError**)error keyOrder:(NSArray*)order;
- (NSData*) csvData:(NSError**)error itemCount:(NSUInteger)count keyOrder:(NSArray*)order forwardCount:(BOOL)forwardCount forwardOrder:(BOOL)forwardOrder;		// for NSArray counterpart compatibility
- (NSData*) xmlData;
- (NSData*) xmlData:(NSError**)error;
- (NSData*) jsonData;
- (NSData*) jsonData:(NSError**)error;
- (NSData*) plistData;
- (NSData*) plistData:(NSError**)error;

- (NSMutableDictionary*) mutableDictionary;

- (NSMutableDictionary*) deepMutableDictionary;
- (NSMutableDictionary*) deepMutableDictionaryByDroppingNSNulls;
- (NSMutableDictionary*) nsNullSafeDeepMutableDictionary;
- (NSMutableDictionary*) nsNullSafeDeepMutableDictionaryWithMarker:(id)marker;

- (id) obj:(id)aKey;
- (id) anyKey;
- (id) anyObject;
- (id) safeObjectForKey:(id)aKey;

- (NSDictionary*) safeDictionaryBySettingObject:(id)anObject forKey:(id<NSCopying>)aKey;

+ (NSComparisonResult) compareDictionary:(NSDictionary*)dictionary1 withDictionary:(NSDictionary*)dictionary2;

- (NSDictionary*) writesafeDictionaryByDroppingNSNulls;
- (NSDictionary*) writesafeDictionaryByReplacingNSNulls;
- (NSDictionary*) writesafeDictionaryByAppendingNSNulls;
- (NSDictionary*) writesafeDictionaryByReplacingObjects:(id)object withReplacement:(id)replacement;
+ (NSDictionary*) writesafeDictionaryByReplacingObjects:(id)object inDictionary:(NSDictionary*)dictionary withReplacement:(id)replacement;
+ (void) writesafeDictionaryByReplacingObjects:(id)object input:(NSDictionary*)inDictionary output:(NSMutableDictionary**)outDictionary replacement:(id)replacement;

+ (NSDictionary*) dictionaryFromArray:(NSArray*)array;
+ (NSDictionary*) dictionaryFromArray:(NSArray*)array stringKeys:(BOOL)stringKeys;
+ (NSDictionary*) dictionaryFromGETString:(NSString*)getString;
+ (NSDictionary*) dictionaryFromGETString:(NSString*)getString convertNumbers:(BOOL)convertNumbers;

- (BOOL) containsAllOf:(NSDictionary*)contains;
- (BOOL) containsNoneOf:(NSDictionary*)contains;

- (NSDictionary*) filterByValue:(NSString*)filterValue;

- (id) firstValueByName:(NSString *)name;
- (NSArray*) valuesByName:(NSString*)name;
+ (NSArray*) valuesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary firstMatch:(BOOL)firstMatch;

@end
