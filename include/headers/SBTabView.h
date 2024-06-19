//
//  SBTabView.h
//
//  Created by Balint Bence on 3/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SBTabView : UIView
{
	UIView *_view;
	UIView *_background;
	UILabel *_label;
	UIViewContentMode _align;
	UIInterfaceOrientation _orientation;
}

+ (id) tabWithTitle:(NSString*)title
			   view:(UIView*)view
		 background:(UIView*)background
			  align:(UIViewContentMode)align
		orientation:(UIInterfaceOrientation)orientation
			   font:(UIFont*)font
			  color:(UIColor*)color
			   mode:(UIViewContentMode)mode;

@property (readwrite,retain) UIView *view;
@property (readwrite,retain) UIView *background;
@property (readwrite,retain) UILabel *label;
@property (readwrite,assign) UIViewContentMode align;
@property (readwrite,assign) UIInterfaceOrientation orientation;

@end
