//
//  AlertView.h
//
//  Created by Bence Balint on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"


//@interface AlertView : UIAlertView
@interface AlertView : CustomAlertView
{
	id _userInfo;
	NSTimer *_refreshTimer;
	NSDate *_dismissDate;
	NSString *_originalText;
}

@property (readwrite,retain) id userInfo;

+ (id) alertWithTitle:(NSString *)title
			  message:(NSString *)message
			 delegate:(id)delegate
	cancelButtonTitle:(NSString *)cancelButtonTitle
	 otherButtonTitle:(NSString *)otherButtonTitle;

+ (id) alertWithTitle:(NSString *)title
			  message:(NSString *)message
			 delegate:(id)delegate
	cancelButtonTitle:(NSString *)cancelButtonTitle
	 otherButtonTitle:(NSString *)otherButtonTitle
		 dismissDelay:(NSTimeInterval)dismissDelay;

+ (id) alertWithTitle:(NSString *)title
			  message:(NSString *)message
			 delegate:(id)delegate
		 dismissDelay:(NSTimeInterval)dismissDelay
	cancelButtonTitle:(NSString *)cancelButtonTitle
	 otherButtonTitle:(NSString *)otherButtonTitles
			arguments:(va_list)args;

+ (id) alertWithTitle:(NSString *)title
			  message:(NSString *)message
			 delegate:(id)delegate
	cancelButtonTitle:(NSString *)cancelButtonTitle
	otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (id) alertWithTitle:(NSString *)title
			  message:(NSString *)message
			 delegate:(id)delegate
	cancelButtonTitle:(NSString *)cancelButtonTitle
	 otherButtonTitle:(NSString *)otherButtonTitles
			arguments:(va_list)args;

+ (id) alertWithTitle:(NSString *)title
			  message:(NSString *)message
			 delegate:(id)delegate
		 dismissDelay:(NSTimeInterval)dismissDelay
	cancelButtonTitle:(NSString *)cancelButtonTitle
	otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
