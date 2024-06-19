//
//  PeakAvgSineView.h
//
//  Created by Balint Bence on 5/18/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PeakAvgSineView : UIView
{
	float _peak;
	float _average;
	CGFloat _peakOffs;
	CGFloat _averageOffs;
	CGFloat _meanOffs;
	
	CGFloat _displayScale;
	CGFloat _displayCutoff;
}

@property (readwrite,assign) float peak;
@property (readwrite,assign) float average;

@property (readwrite,assign) CGFloat displayScale;
@property (readwrite,assign) CGFloat displayCutoff;

@end
