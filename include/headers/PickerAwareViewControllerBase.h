//
//  PickerAwareViewControllerBase.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardAwareViewControllerBase.h"
#import "CustomPicker.h"


@interface PickerAwareViewControllerBase : KeyboardAwareViewControllerBase
{
	BOOL _pickerOn;
	BOOL _showingPicker;
	BOOL _hidingPicker;
	BOOL _wasPickerOn;
}

@property (retain,nonatomic) CustomPicker *pickerView;

// picker hadlers to override
- (void) pickerWillShow:(NSNotification*)notification;
- (void) pickerWillHide:(NSNotification*)notification;

// picker configuration override
- (void) showPicker:(BOOL)show animated:(BOOL)animated;
- (void) showPicker:(UIView*)picker show:(BOOL)show animated:(BOOL)animated;

// selection handlers to override
- (void) pickerSelectionDidChange:(id)picker selected:(NSInteger)selected;
- (void) pickerSelectionDidChange:(id)picker date:(NSDate*)date;

@end


@interface PickerAwareViewControllerBase ()
@property (readwrite,assign) BOOL pickerOn;
@property (readwrite,assign) BOOL showingPicker;
@property (readwrite,assign) BOOL hidingPicker;
- (void) svPickerSelectionChangedHandler:(NSNotification*)notification;
@end
