//
//  SlideBarController.h
//
//  Created by Balint Bence on 6/1/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SlideBar.h"
#import "SBButton.h"


@interface SlideBarController : UITabBarController <SlideBarDelegate>
{
	SlideBar *_slideBar;
}

@property (nonatomic,retain) IBOutlet SlideBar *slideBar;

- (CGFloat) tabHeight;
- (void) setTabHeight:(CGFloat)height;

// methods to override
- (SBButton*) tabButtonForIndex:(NSInteger)index;
- (UIView*) tabHighlight;
- (UIView*) tabSelectedBackground;
- (UIView*) tabDeselectedBackground;
- (CGFloat) tabIconLength;
- (CGFloat) tabMargin;
- (CGFloat) tabTreshold;
- (UIImage*) tabHeadMore;
- (UIImage*) tabTailMore;
- (UIImage*) tabHeadEnd;
- (UIImage*) tabTailEnd;

@end
