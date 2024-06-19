//
//  MenuBar.h
//
//  Created by Balint Bence on 6/17/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideBar.h"


typedef enum {
	MBDirectionRight = 0,
	MBDirectionLeft,
	MBDirectionUp,
	MBDirectionDown
} MBDirection;


@class MenuBar;

@protocol MenuBarDelegate <NSObject>
@optional
- (void)menuBarWillOpen:(MenuBar*)menuBar;
- (void)menuBarDidOpen:(MenuBar*)menuBar;
- (void)menuBarWillClose:(MenuBar*)menuBar;
- (void)menuBarDidClose:(MenuBar*)menuBar;
@end


@interface MenuBar : SlideBar {
	id<MenuBarDelegate> _menuBarDelegate;
	UIButton *_tapButton;
	UIImageView *_animationImage;
	MBDirection _openDirection;
	BOOL _oneHitOpenAndClose;			// YES to default
	BOOL _shrinkToZero;
	BOOL _open;
	BOOL _menuOpeningDisabled;
}

@property (readwrite,assign) id<MenuBarDelegate> menuBarDelegate;
@property (readwrite,assign) MBDirection openDirection;
@property (readwrite,assign) BOOL oneHitOpenAndClose;
@property (readwrite,assign) BOOL shrinkToZero;
@property (readonly,assign,getter=isOpen) BOOL open;
@property (readwrite,assign) BOOL menuOpeningDisabled;

+ (id) menuBarWithFrame:(CGRect)frame
		  slideDelegate:(id<SlideBarDelegate>)slideDelegate
		   menuDelegate:(id<MenuBarDelegate>)menuDelegate
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

+ (MBDirection) oppositeDirection:(MBDirection)direction;
- (void) open;
- (void) open:(MBDirection)direction animated:(BOOL)animated;
- (void) close;
- (void) close:(MBDirection)direction animated:(BOOL)animated;

@end
