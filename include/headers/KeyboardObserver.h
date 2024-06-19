//
//  KeyboardObserver.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractSingleton.h"


@interface KeyboardObserver : AbstractSingleton
{
	BOOL _keyboardOn;
	BOOL _showingKeyboard;
	BOOL _hidingKeyboard;
//	BOOL _changingKeyboard;
	BOOL _pickerOn;
	CGRect _keyboardOnRect;
	CGRect _keyboardOffRect;
	NSTimeInterval _keyboardOnDuration;
	UIViewAnimationCurve _keyboardAnimationCurve;
}

@property (readwrite,assign,getter=isKeyboardOn) BOOL keyboardOn;
@property (readwrite,assign,getter=isShowingKeyboard) BOOL showingKeyboard;
@property (readwrite,assign,getter=isHidingKeyboard) BOOL hidingKeyboard;
//@property (readwrite,assign,getter=isChangingKeyboard) BOOL changingKeyboard;
@property (readwrite,assign,getter=isPickerOn) BOOL pickerOn;
@property (readwrite,assign) CGRect keyboardOnRect;
@property (readwrite,assign) CGRect keyboardOffRect;
@property (readwrite,assign) NSTimeInterval keyboardOnDuration;
@property (readwrite,assign) UIViewAnimationCurve keyboardAnimationCurve;

+ (KeyboardObserver*) instance;

// global state of the keyboard
+ (BOOL) isKeyboardOn;
+ (BOOL) isShowingKeyboard;
+ (BOOL) isHidingKeyboard;
//+ (BOOL) isChangingKeyboard;
+ (BOOL) isPickerOn;
// dismissing any keyboard
+ (BOOL) dismissKeyboard;
// shorthand functions
+ (NSNotification*) createKeyboardNotification:(NSString*)name;
+ (NSNotification*) createKeyboardNotification:(NSString*)name onRect:(CGRect)onRect offRect:(CGRect)offRect duration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve;
+ (NSDictionary*) createKeyboardNotificationUserInfo:(NSString*)name onRect:(CGRect)onRect offRect:(CGRect)offRect duration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve;
// helper methods
+ (CGRect) extractKeyboardOnRect:(NSNotification*)notification;
+ (CGRect) extractKeyboardOffRect:(NSNotification*)notification;
+ (NSTimeInterval) extractKeyboardOnDuration:(NSNotification*)notification;
+ (UIViewAnimationCurve) extractKeyboardAnimationCurve:(NSNotification*)notification;

@end
