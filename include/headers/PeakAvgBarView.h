//
//  PeakAvgBarView.h
//
//  Created by Balint Bence on 5/18/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
	PADirectionLeft = 0,
	PADirectionRight,
	PADirectionUp,
	PADirectionDown
} PADirection;


@interface PeakAvgBarView : UIView
{
	UIImage *_vuPeakImage;
	UIImage *_vuOnImage;
	UIImage *_vuOffImage;
	
	float _peak;
	float _average;
	NSInteger _ledNumber;
	
	CGFloat _displayScale;
	CGFloat _displayCutoff;
	PADirection _direction;
	CGFloat _ledMargin;
}

@property (readwrite,assign) float peak;
@property (readwrite,assign) float average;
@property (readwrite,assign) NSInteger ledNumber;

@property (readwrite,assign) CGFloat displayScale;
@property (readwrite,assign) CGFloat displayCutoff;
@property (readwrite,assign) PADirection direction;
@property (readwrite,assign) CGFloat ledMargin;

@end
