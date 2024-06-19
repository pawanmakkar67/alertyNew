//
//  MenuView.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuView : UIScrollView
{
	NSMutableArray *_items;
	BOOL _leaveCenterElementOutInPortraitMode;
	BOOL _plainMenu;
	CGFloat _iconDistance;
	UIEdgeInsets _menuMargin;
}

@property (readwrite,assign) NSInteger numOfColumnsPortrait;
@property (readwrite,assign) NSInteger numOfColumnsLandscape;
@property (readwrite,assign) NSInteger rowsPerScreenPortrait;
@property (readwrite,assign) NSInteger rowsPerScreenLandscape;
@property (readwrite,retain) NSMutableArray *items;
@property (readwrite,assign) BOOL leaveCenterElementOutInPortraitMode;
@property (readwrite,assign) BOOL plainMenu;
@property (readwrite,assign) CGFloat iconDistance;
@property (readwrite,assign) UIEdgeInsets menuMargin;

// methods to override
- (void) initInternals;

// public methods
- (void) rearrangeItems;

@end
