//
//  KeyboardAwareViewControllerBase.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerBase.h"


@interface KeyboardAwareViewControllerBase : ViewControllerBase <UITextFieldDelegate>
{
	NSTimeInterval _keyboardOnDuration;
	CGRect _keyboardOnRect;
	BOOL _keyboardOn;
	BOOL _showingKeyboard;
	BOOL _hidingKeyboard;
}

@property (nonatomic, retain) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

// keyboard hadlers to override
- (void) keyboardWillShow:(NSNotification*)notification;
- (void) keyboardWillHide:(NSNotification*)notification;

// adjustment methods to override
- (void) moveAboveKeyboard;
- (void) moveBackToOriginal;

@end


@interface KeyboardAwareViewControllerBase ()
@property (readwrite,assign) NSTimeInterval keyboardOnDuration;
@property (readwrite,assign) CGRect keyboardOnRect;
@property (readwrite,assign) BOOL keyboardOn;
@property (readwrite,assign) BOOL showingKeyboard;
@property (readwrite,assign) BOOL hidingKeyboard;
- (void) collectKeyboardInfoFromNotification:(NSNotification*)notification;
@end
