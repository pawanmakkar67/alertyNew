//
//  NSObjectAdditions.h
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


@interface NSObject (ExtendedMethods)

- (void) swizzleSelector:(SEL)origSel withSelector:(SEL)newSel;
+ (NSComparisonResult) compareObject:(id)anObject withObject:(id)withObject;

- (id) invoke:(SEL)selector arguments:(va_list)args;
- (id) invoke:(SEL)selector, ...;

- (void) performSelectorInBackground:(SEL)aSelector withObject:(id)arg afterDelay:(NSTimeInterval)delay;
- (void) cancelPreviousPerformRequestsOnBackgroundThreadWithSelector:(SEL)aSelector object:(id)anArgument;
- (void) performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg afterDelay:(NSTimeInterval)delay;
- (void) cancelPreviousPerformRequestsOnMainThreadWithSelector:(SEL)aSelector object:(id)anArgument;

- (id) replaceClass:(Class)classToReplace withClass:(Class)replacementClass;

@end


@interface NSObject (BlockPerforming)

+ (id)performBlockOnMainQueue:(void (^)(id arg))block withObject:(id)anObject;
+ (id)performBlockOnMainQueue:(void (^)(id arg))block withObject:(id)anObject waitUntilDone:(BOOL)wait;
+ (id)performBlockOnMainQueue:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;
+ (id)performBlockOnGlobalQueue:(void (^)(id arg))block withObject:(id)anObject;
+ (id)performBlockOnGlobalQueue:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;
- (id)performBlockOnMainQueue:(void (^)(id arg))block withObject:(id)anObject;
- (id)performBlockOnMainQueue:(void (^)(id arg))block withObject:(id)anObject waitUntilDone:(BOOL)wait;
- (id)performBlockOnMainQueue:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;
- (id)performBlockOnGlobalQueue:(void (^)(id arg))block withObject:(id)anObject;
- (id)performBlockOnGlobalQueue:(void (^)(id arg))block withObject:(id)anObject afterDelay:(NSTimeInterval)delay;

+ (void)cancelBlock:(id)block;

- (void) addObserverOnce:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
- (void) safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context NS_AVAILABLE(10_7, 5_0);
- (void) safeRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end
