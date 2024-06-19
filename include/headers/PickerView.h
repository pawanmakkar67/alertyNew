//
//  PickerView.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryConfig.h"


extern NSString *const SVPickerWillShowNotification;
extern NSString *const SVPickerWillHideNotification;


@interface PickerView : UIPickerView <UIPickerViewDelegate,
									  UIPickerViewDataSource>
{
	id _userInfo;
#if PICKER_ENABLE_SMALL_SIZE
	BOOL _smallSized;
#endif
	NSArray *_items;
	NSUInteger _selected;
	CGFloat _rowHeight;
	CGFloat _componentWidth;
}

#if PICKER_ENABLE_SMALL_SIZE
@property (readwrite,assign,getter=isSmallSized) BOOL smallSized;
#endif
@property (readwrite,retain) id userInfo;
@property (readwrite,retain) NSArray *items;
@property (readwrite,assign) NSUInteger selected;
@property (readwrite,assign) CGFloat rowHeight;
@property (readwrite,assign) CGFloat componentWidth;

+ (id) pickerWithItems:(NSArray*)items selected:(NSUInteger)selected;

// methods to override
- (UIView*) makeRowView;
- (void) configureRowView:(UIView*)view forRow:(NSUInteger)row;
// public methods
- (void) setSelected:(NSUInteger)selected animated:(BOOL)animated;
- (BOOL) isShown;
- (void) showFromBottom:(BOOL)show inView:(UIView*)view animated:(BOOL)animated;
// view handling methods for CustomPicker encapsulation
- (UIView*) containerView;
- (UIView*) contentView;

@end


@interface PickerView ()
- (void) initInternals;
@end
