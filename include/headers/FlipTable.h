//
//  FlipTable.h
//
//  Created by Bence Balint on 2010.12.07..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface FlipTable : UIView
{
	UIImageView *_topView;
	UIImageView *_topFlip;
	UIImageView *_bottomView;
	UIImageView *_bottomFlip;
	NSTimeInterval _animationDuration;
}

@property (readwrite,assign) NSTimeInterval animationDuration;

- (void) setTop:(UIImage*)top bottom:(UIImage*)bottom;
- (void) flipToTop:(UIImage*)top bottom:(UIImage*)bottom;

@end
