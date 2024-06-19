//
//  NSMutableArrayAdditions.h
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


typedef NSMutableArray		NSNonRetainingMutableArray;


@interface NSMutableArray (ExtendedMethods)

+ (NSMutableArray*) openFile:(NSString*)path;
+ (NSMutableArray*) openFile:(NSString*)path error:(NSError**)error;

+ (NSMutableArray*) nonRetainingArray;

+ (NSMutableArray*) safeArrayWithObject:(id)anObject;

- (void) safeAddObject:(id)anObject;
- (void) safeAddObjectsFromArray:(NSArray*)array;
- (void) safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void) safeInsertObjects:(NSArray*)objects atIndex:(NSUInteger)index;
- (void) safeRemoveObject:(id)anObject;
- (void) safeRemoveObjectAtIndex:(NSInteger)index;
- (void) safeReplaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
- (void) safeSwapObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;

- (void) reverse;

- (void) moveObjectFromIndex:(NSInteger)from toIndex:(NSInteger)to;

- (void) addDistinctObjectsFromArray:(NSArray*)array;
- (void) recursiveAddDistinctObjectsFromArray:(NSArray*)otherArray;

@end
