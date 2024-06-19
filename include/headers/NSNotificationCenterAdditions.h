//
//  NSNotificationCenterAdditions.h
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


extern NSString *const NEEventNameKey;


@interface NSNotificationCenter (ExtendedMethods)

+ (void) addObserver:(id)observer selector:(SEL)aSelector name:(NSString*)aName object:(id)anObject;
+ (void) addObserverOnce:(id)observer selector:(SEL)aSelector name:(NSString*)aName object:(id)anObject;
+ (void) removeObserver:(id)observer;
+ (void) removeObserver:(id)observer name:(NSString*)aName object:(id)anObject;
#if NS_BLOCKS_AVAILABLE
+ (id) addObserverForName:(NSString*)name object:(id)obj queue:(NSOperationQueue*)queue usingBlock:(void (^)(NSNotification *note))block NS_AVAILABLE(10_6, 4_0);
#endif
+ (void) postNotificationName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo;														// always synchron
+ (void) postAsyncNotificationName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo;													// always asynchron
+ (void) postNotificationName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo async:(BOOL)async;										// choose behavior
+ (void) postNotificationName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo async:(BOOL)async onMainThread:(BOOL)onMainThread;		// synchron behavior can be asynchron if it needs to switch the thread
+ (void) postAsyncNotificationOnMainThreadName:(NSString*)name object:(id)object userInfo:(NSDictionary*)userInfo;										// always asynchron and will callback on Main Thread

@end
