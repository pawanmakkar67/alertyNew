//
//  CustomAlertView.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomAlertView;

@protocol CustomAlertViewDelegate <NSObject>
@optional
- (void) alertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end


@interface CustomAlertView : UIView
{
	id/*<CustomAlertViewDelegate>*/ _delegate;
	BOOL _shown;
	UIImageView *_fadeBackgroundView;
	UIView *_alertView;
	UIImageView *_alertBackgroundView;
	UILabel *_titleLabel;
	UITextView *_messageText;
	UIButton *_cancelButton;
	NSMutableArray *_otherButtons;
	BOOL _mayFlashIndicator;
}

@property (nonatomic,assign) id/*<CustomAlertViewDelegate>*/ delegate;
@property (nonatomic,assign,getter=isShown) BOOL shown;
@property (nonatomic,retain) UIImageView *fadeBackgroundView;
@property (nonatomic,retain) UIView *alertView;
@property (nonatomic,retain) UIImageView *alertBackgroundView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UITextView *messageText;
@property (nonatomic,retain) UIButton *cancelButton;
@property (nonatomic,retain) NSMutableArray *otherButtons;
@property (readwrite,retain) NSString *title;
@property (readwrite,retain) NSString *message;

+ (id) customAlertWithTitle:(NSString *)title
					message:(NSString *)message
				   delegate:(id)delegate
		  cancelButtonTitle:(NSString *)cancelButtonTitle
		   otherButtonTitle:(NSString *)otherButtonTitle;

+ (id) customAlertWithTitle:(NSString *)title
					message:(NSString *)message
				   delegate:(id)delegate
		  cancelButtonTitle:(NSString *)cancelButtonTitle
		   otherButtonTitle:(NSString *)otherButtonTitle
				  arguments:(va_list)args;

+ (id) customAlertWithTitle:(NSString *)title
					message:(NSString *)message
				   delegate:(id)delegate
		  cancelButtonTitle:(NSString *)cancelButtonTitle
		  otherButtonTitles:(NSString *)otherButtonTitles, ...;

+ (id) showCustomAlertInView:(UIView *)view
					   title:(NSString *)title
					 message:(NSString *)message
					delegate:(id)delegate
		   cancelButtonTitle:(NSString *)cancelButtonTitle
			otherButtonTitle:(NSString *)otherButtonTitle;

+ (id) showCustomAlertInView:(UIView *)view
					   title:(NSString *)title
					 message:(NSString *)message
					delegate:(id)delegate
		   cancelButtonTitle:(NSString *)cancelButtonTitle
			otherButtonTitle:(NSString *)otherButtonTitle
				   arguments:(va_list)args;

+ (id) showCustomAlertInView:(UIView *)view
					   title:(NSString *)title
					 message:(NSString *)message
					delegate:(id)delegate
		   cancelButtonTitle:(NSString *)cancelButtonTitle
		   otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void) showInView:(UIView *)view;
- (void) show;

- (void) dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (NSString *) buttonTitleAtIndex:(NSInteger)buttonIndex;

// methods to override
- (void) show:(BOOL)show animated:(BOOL)animated;
- (void) killAlert;
- (Class) titleLabelClass;
- (Class) messageTextClass;

@end
