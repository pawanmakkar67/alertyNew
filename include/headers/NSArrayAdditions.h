//
//  NSArrayAdditions.h
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


@interface NSArray (ExtendedMethods)

NSComparisonResult finderSortWithLocale(id string1, id string2, void *locale);
- (NSArray*) finderSortedArray;

- (NSMutableArray*) mutableArray;

- (NSMutableArray*) deepMutableArray;
- (NSMutableArray*) deepMutableArrayByDroppingNSNulls;
- (NSMutableArray*) nsNullSafeDeepMutableArray;
- (NSMutableArray*) nsNullSafeDeepMutableArrayWithMarker:(id)marker;

+ (NSArray*) openFile:(NSString*)path;
+ (NSArray*) openFile:(NSString*)path error:(NSError**)error;
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
- (NSData*) csvDataWithItemCount:(NSUInteger)count;
- (NSData*) csvData:(NSError**)error itemCount:(NSUInteger)count;
- (NSData*) csvData:(NSError**)error itemCount:(NSUInteger)count keyOrder:(NSArray*)order forwardCount:(BOOL)forwardCount forwardOrder:(BOOL)forwardOrder;		// for NSArray NSDictionary compatibility
- (NSData*) xmlData;
- (NSData*) xmlData:(NSError**)error;
- (NSData*) jsonData;
- (NSData*) jsonData:(NSError**)error;
- (NSData*) plistData;
- (NSData*) plistData:(NSError**)error;

+ (NSComparisonResult) compareArray:(NSArray*)array1 withArray:(NSArray*)array2;

+ (NSArray*) arrayOf:(id)obj count:(NSInteger)count;

- (void) voidPerformSelector:(SEL)selector;
- (void) voidPerformSelectorAsync:(SEL)selector withObject:(id)arg;
- (void) voidPerformSelector:(SEL)selector withObject:(id)arg;
- (void) voidPerformSelector:(SEL)selector withObject:(id)arg1 withObject:(id)arg2;
- (NSArray*) performSelector:(SEL)selector;
- (NSArray*) performSelector:(SEL)selector withObject:(id)arg;
- (NSArray*) performSelector:(SEL)selector withObject:(id)arg1 withObject:(id)arg2;
- (void) voidPerformSelector:(SEL)selector onObject:(id)object;
- (NSArray*) performSelector:(SEL)selector onObject:(id)object;

- (NSArray*) reversedArray;

- (NSArray*) writesafeArrayByDroppingNSNulls;
- (NSArray*) writesafeArrayByReplacingNSNulls;
- (NSArray*) writesafeArrayByAppendingNSNulls;
- (NSArray*) writesafeArrayByReplacingObjects:(id)object withReplacement:(id)replacement;
+ (NSArray*) writesafeArrayByReplacingObjects:(id)object inArray:(NSArray*)array withReplacement:(id)replacement;
+ (void) writesafeArrayByReplacingObjects:(id)object input:(NSArray*)inArray output:(NSMutableArray**)outArray replacement:(id)replacement;

- (NSArray*) safeArrayByAddingObject:(id)anObject;
+ (NSArray*) safeArrayWithObject:(id)anObject;

- (NSString*) concatenate;
- (NSString*) concatenate:(NSString*)separator;

- (id) at:(NSInteger)index;
- (id) safeAt:(NSInteger)index;
- (BOOL) safeContainsObject:(id)anObject;
- (NSArray*) safeSubarray:(NSRange)range;

- (NSInteger) findObject:(id)object;

- (NSArray*) arrayByInsertingObject:(id)anObject;
- (NSArray*) arrayByInsertingObject:(id)anObject atIndex:(NSInteger)index;
- (NSArray*) arrayByRemovingObjectAtIndex:(NSInteger)index;
- (NSArray*) arrayByRemovingObject:(id)anObject;
- (NSArray*) arrayByRemovingObjects:(id)anObject;

- (NSArray*) arrayByInterleavingWithArray:(NSArray*)evenArray;
- (NSArray*) arrayByMergingWithArray:(NSArray*)otherArray forMaximums:(BOOL)maximum;
- (NSArray*) arrayBySubstractingArray:(NSArray*)array;
- (NSInteger) cumulate;

- (NSArray*) arrayByAddingStartBracket:(NSString*)start endBracket:(NSString*)end;
- (NSArray*) arrayByRemovingStartBracket:(NSString*)start endBracket:(NSString*)end;

- (id) firstValueByName:(NSString *)name;
- (NSArray*) valuesByName:(NSString*)name;
+ (NSArray*) valuesByName:(NSString*)name inArray:(NSArray*)array firstMatch:(BOOL)firstMatch;

- (va_list*) valistCreate:(BOOL)addnil;
+ (void) valistRelease:(va_list*)valist;

@end
