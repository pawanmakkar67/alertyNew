//
//  UIViewAdditions.h
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
#import "LibraryConfig.h"


typedef enum {
	UIViewMoveLeft,
	UIViewMoveRight,
	UIViewMoveUp,
	UIViewMoveDown
} UIViewMoveDirection;


@interface UIView (ExtendedMethods)

- (CGFloat) x;
- (void) setX:(CGFloat)x;
- (CGFloat) y;
- (void) setY:(CGFloat)y;
- (CGFloat) centerX;
- (void) setCenterX:(CGFloat)x;
- (CGFloat) centerY;
- (void) setCenterY:(CGFloat)y;
- (CGFloat) width;
- (void) setWidth:(CGFloat)width;
- (CGFloat) height;
- (void) setHeight:(CGFloat)height;
- (CGPoint) origin;
- (void) setOrigin:(CGPoint)origin;
- (CGSize) size;
- (void) setSize:(CGSize)size;
- (CGFloat) left;
- (void) setLeft:(CGFloat)left;
- (void) moveLeftTo:(CGFloat)left;
- (CGFloat) right;
- (void) setRight:(CGFloat)right;
- (void) moveRightTo:(CGFloat)right;
- (CGFloat) top;
- (void) setTop:(CGFloat)top;
- (void) moveTopTo:(CGFloat)top;
- (CGFloat) bottom;
- (void) setBottom:(CGFloat)bottom;
- (void) moveBottomTo:(CGFloat)bottom;

- (void) debugRed;
- (void) debugGreen;
- (void) debugBlue;
- (void) debugRed:(CGFloat)alpha;
- (void) debugGreen:(CGFloat)alpha;
- (void) debugBlue:(CGFloat)alpha;

- (UIImage*) viewImage;
+ (UIImage*) getFullImage:(UIView*)view;
- (UIColor*) pixelColor:(CGPoint)point;

- (UIView*) findFirstResponder;
- (UIView*) firstSubviewWithClass:(Class)subviewClass;
- (CGRect) subviewsBoundingRect;
- (void) fitToSubviews;

+ (UIView*) debugRed;
+ (UIView*) debugGreen;
+ (UIView*) debugBlue;
+ (UIView*) debugRed:(CGRect)frame;
+ (UIView*) debugGreen:(CGRect)frame;
+ (UIView*) debugBlue:(CGRect)frame;

+ (UIView*) coloredView:(UIColor*)color;
+ (UIView*) coloredView:(UIColor*)color frame:(CGRect)frame;

+ (void) animateOrNot:(NSTimeInterval)duration animations:(void (^)(void))animations;
+ (void) animateOrNot:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
+ (void) animateOrNot:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

+ (void) dumpSuperviews:(UIView*)view;
+ (void) dumpHierarchy:(UIView*)view;

- (void) show;
- (void) hide;
- (void) show:(BOOL)show;
- (void) hide:(BOOL)hide;
- (void) fade:(BOOL)show;
- (void) fade:(BOOL)show duration:(NSTimeInterval)duration;
- (void) fadeIn;
- (void) fadeIn:(NSTimeInterval)duration;
- (void) fadeOut;
- (void) fadeOut:(NSTimeInterval)duration;
- (void) move:(BOOL)into direction:(UIViewMoveDirection)direction;
- (void) move:(BOOL)into duration:(NSTimeInterval)duration direction:(UIViewMoveDirection)direction;
- (void) moveIn:(UIViewMoveDirection)direction;
- (void) moveIn:(NSTimeInterval)duration direction:(UIViewMoveDirection)direction;
- (void) moveOut:(UIViewMoveDirection)direction;
- (void) moveOut:(NSTimeInterval)duration direction:(UIViewMoveDirection)direction;

#if HAVE_OPEN_GL
// Note: Call this method after you draw and before -presentRenderbuffer:
- (UIImage*) snapshotOfOpenGLRenderBuffer:(GLuint)renderbuffer;
#endif

// alignment helpers
+ (CGFloat) alignLeft:(NSArray*)controls margin:(CGFloat)margin;
+ (CGFloat) alignRight:(NSArray*)controls margin:(CGFloat)margin;
+ (CGFloat) alignTop:(NSArray*)controls margin:(CGFloat)margin;
+ (CGFloat) alignBottom:(NSArray*)controls margin:(CGFloat)margin;

// string <-> content mode conversion
+ (UIViewContentMode) stringToContentMode:(NSString*)string;
+ (NSString*) contentModeToString:(UIViewContentMode)contentMode shortName:(BOOL)shortName;

@end
