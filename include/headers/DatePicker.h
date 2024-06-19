//
//  DatePicker.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryConfig.h"


@interface DatePicker : UIDatePicker
{
	id _userInfo;
#if PICKER_ENABLE_SMALL_SIZE
	BOOL _smallSized;
#endif
}

#if PICKER_ENABLE_SMALL_SIZE
@property (readwrite,assign,getter=isSmallSized) BOOL smallSized;
#endif
@property (readwrite,retain) id userInfo;

// public methods
- (BOOL) isShown;
- (void) showFromBottom:(BOOL)show inView:(UIView*)view animated:(BOOL)animated;
// view handling methods for CustomPicker encapsulation
- (UIView*) containerView;
- (UIView*) contentView;

@end


@interface DatePicker ()
- (void) initInternals;
@end
