//
//  UIViewControllerAdditions.h
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
#import <UIKit/UIKit.h>


@interface UIViewController (ExtendedMethods)

@property (readwrite,retain) id userInfo;
//@property (readwrite,retain) id userInfo;
//@property (readonly,retain) NSMutableDictionary *userInfoDictionary;

- (BOOL) isOrientationPortrait;

- (UIViewController *) modalController;
- (UIViewController *) parentController;

- (void) dismissControllerAnimated:(BOOL)animated;
- (void) dismissControllerAnimated:(BOOL)animated completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0);
- (void) presentController:(UIViewController *)viewController animated:(BOOL)animated;
- (void) presentController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0);

+ (UIViewController*) findFirstModalController:(UIViewController*)child;
+ (UIViewController*) findLastModalController:(UIViewController*)parent;
+ (UIViewController*) findModalControllerByClass:(Class)modal inControllers:(UIViewController*)controller;

+ (void) presentController:(UIViewController*)controller byDismissingController:(UIViewController*)dismiss;
+ (void) presentController:(UIViewController*)controller byDismissingController:(UIViewController*)dismiss animated:(BOOL)animated;
+ (void) presentController:(UIViewController*)controller inContext:(UIViewController*)context;
+ (void) presentController:(UIViewController*)controller inContext:(UIViewController*)context animated:(BOOL)animated;

+ (void) swapScreenTo:(UIViewController*)controller;
+ (void) swapScreenTo:(UIViewController*)controller animated:(BOOL)animated;
+ (void) swapScreenTo:(UIViewController*)controller fromContext:(UIViewController*)context;
+ (void) swapScreenTo:(UIViewController*)controller fromContext:(UIViewController*)context animated:(BOOL)animated;

@end
