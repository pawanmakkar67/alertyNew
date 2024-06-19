//
//  SlideBar.h
//
//  Created by Balint Bence on 3/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBButton.h"


@class SlideBar;

@protocol SlideBarDelegate <NSObject>
@optional
- (void) slideBar:(SlideBar*)slideBar didSelectButtonAtIndex:(NSInteger)index;
@end


@interface SlideBar : UIView <UIScrollViewDelegate,
							  SBButtonDelegate>
{
	id<SlideBarDelegate> _slideBarDelegate;
	UIScrollView *_contentView;
	NSMutableArray *_buttons;
	UIButton *_headButton;
	UIButton *_tailButton;
	BOOL _disableScrollCallback;
	
	UIView *_highlight;
	UIView *_selectedBackground;
	UIView *_deselectedBackground;
	UIImage *_headMore;
	UIImage *_tailMore;
	UIImage *_headEnd;
	UIImage *_tailEnd;
	NSInteger _selected;
	CGFloat _iconLength;
	CGFloat _margin;
	CGFloat _treshold;
	BOOL _selectionCanScrollOut;
	BOOL _accessoriesAlwaysShown;
	BOOL _vertical;
	BOOL _animationsDisabled;
	BOOL _statinaryHighlightForOneItemWidth;
}

+ (id) slideBarWithFrame:(CGRect)frame
				delegate:(id<SlideBarDelegate>)delegate
				 buttons:(NSArray*)buttons
			   highlight:(UIView*)highlight
	  selectedBackground:(UIView*)selectedBackground
	deselectedBackground:(UIView*)deselectedBackground
			  iconLength:(CGFloat)iconLength
				  margin:(CGFloat)margin
				treshold:(CGFloat)treshold
				headMore:(UIImage*)headMore
				tailMore:(UIImage*)tailMore
				 headEnd:(UIImage*)headEnd
				 tailEnd:(UIImage*)tailEnd;

- (void) reloadData;
- (void) flashIndicators;
- (CGRect) convertButtonFrame:(SBButton*)button toView:(UIView*)view;
- (SBButton*) buttonForIndex:(NSInteger)index;

- (void) setSelected:(NSInteger)selected animated:(BOOL)animated;

@property (readwrite,assign) id<SlideBarDelegate> slideBarDelegate;
@property (readwrite,retain) NSMutableArray *buttons;
@property (readwrite,retain) UIView *highlight;
@property (readwrite,retain) UIView *selectedBackground;
@property (readwrite,retain) UIView *deselectedBackground;
@property (readwrite,retain) UIImage *headMore;
@property (readwrite,retain) UIImage *tailMore;
@property (readwrite,retain) UIImage *headEnd;
@property (readwrite,retain) UIImage *tailEnd;
@property (readwrite,assign) NSInteger selected;
@property (readwrite,assign) CGFloat iconLength;
@property (readwrite,assign) CGFloat margin;
@property (readwrite,assign) CGFloat treshold;
@property (readwrite,assign) BOOL selectionCanScrollOut;
@property (readwrite,assign) BOOL accessoriesAlwaysShown;
@property (readwrite,assign) BOOL vertical;
@property (readwrite,assign) BOOL animationsDisabled;
@property (readwrite,assign) BOOL statinaryHighlightForOneItemWidth;

@end


@interface SlideBar ()
- (void) initInternals;
@end
