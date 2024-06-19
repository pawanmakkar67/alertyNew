//
//  SBButton.h
//
//  Created by Balint Bence on 3/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SBButton;

@protocol SBButtonDelegate <NSObject>
@optional
- (void) buttonPressed:(SBButton*)button;
- (void) buttonPressed:(SBButton*)button withEvent:(UIEvent*)event;
@end


@interface SBButton : UIButton//UIView
{
	id<SBButtonDelegate> _buttonDelegate;
	id _target;
	SEL _selector;
	UIControlState _state;
	NSMutableDictionary *_views;
	id _userInfo;
}

+ (id) buttonWithNormalView:(UIView*)normalView selectedView:(UIView*)selectedView;
+ (id) buttonWithNormalView:(UIView*)normalView selectedView:(UIView*)selectedView target:(id)target selector:(SEL)selector;

@property (readwrite,assign) id<SBButtonDelegate> buttonDelegate;
@property (readwrite,assign,getter=isHighlighted) BOOL highlighted;
@property (readwrite,assign,getter=isDisabled) BOOL disabled;
@property (readwrite,assign,getter=isSelected) BOOL selected;
@property (readwrite,assign) id target;
@property (readwrite,assign) SEL selector;
@property (readwrite,assign) UIControlState state;
@property (readwrite,retain) NSMutableDictionary *views;

@property (readwrite,retain) IBOutlet UIView *normalView;
@property (readwrite,retain) IBOutlet UIView *selectedView;
@property (readwrite,retain) IBOutlet UIView *disabledView;

@property (readwrite,retain) IBOutlet UIView *normalHighlightedView;
@property (readwrite,retain) IBOutlet UIView *selectedHighlightedView;
@property (readwrite,retain) IBOutlet UIView *disabledHighlightedView;

@property (readwrite,retain) IBOutlet UIView *disabledSelectedView;
@property (readwrite,retain) IBOutlet UIView *disabledSelectedHighlightedView;

@property (readwrite,retain) id userInfo;

- (void) setView:(UIView*)view forState:(UIControlState)state;
- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void) setDisabled:(BOOL)disabled animated:(BOOL)animated;
- (void) setSelected:(BOOL)selected animated:(BOOL)animated;

- (UIView*) visibleView;
- (UIView*) viewForState:(UIControlState)state;

@end


@interface SBButton ()
- (void) initInternals;
- (void) changeViewAnimated:(BOOL)animated;
@end
