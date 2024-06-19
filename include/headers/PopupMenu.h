//
//  PopupMenu.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupItem.h"


@class PopupMenu;

@protocol PopupMenuDelegate <NSObject>
@optional
- (void) popupMenu:(PopupMenu*)popupMenu menuItemSelected:(NSInteger)selected;
- (void) popupMenuCloseDidPress:(PopupMenu*)popupMenu;
@end


@interface PopupMenu : UIView
{
	id<PopupMenuDelegate> _popupDelegate;
	NSArray *_menu;
	NSArray *_items;
	NSArray *_originals;
	UIEdgeInsets _margin;
}

@property (assign, readwrite) IBOutlet id<PopupMenuDelegate> popupDelegate;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *closeButton;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;

+ (PopupMenu*) popupMenu:(id<PopupMenuDelegate>)delegate frame:(CGRect)frame descriptor:(NSArray*)descriptor backgroundImage:(UIImage *)backgroundImage margin:(UIEdgeInsets)margin;
+ (PopupMenu*) showPopupInView:(UIView*)view belowView:(UIView*)below delegate:(id<PopupMenuDelegate>)delegate descriptor:(NSArray*)descriptor startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame animated:(BOOL)animated backgroundImage:(UIImage *)backgroundImage margin:(UIEdgeInsets)margin;

- (IBAction) closeButtonPressed:(id)sender;

- (BOOL) isShown;
- (void) showPopup:(BOOL)show frame:(CGRect)frame animated:(BOOL)animated;
- (void) dismissPopup:(BOOL)animated frame:(CGRect)frame;

- (PopupItem*) popupItemAtIndex:(NSInteger)index;
- (PopupItem*) popupItemWithId:(NSInteger)itemId;

@end
