//
//  LockView.h
//  Shareroutes
//
//  Created by Mac on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LockViewClosingView.h"
#import "GWCall.h"
#import "TargetConditionals.h"

@protocol LockViewDelegate;

@interface LockView : UIView <LockViewClosingViewDelegate,
								UIGestureRecognizerDelegate,
								UIScrollViewDelegate,
								GWCallDelegate> {
	CGPoint				_startLocation;
	BOOL				_quitTouched;
	CABasicAnimation	*_maskAnim;
	CALayer				*_maskLayer;
	int					_loop;
	BOOL				_callHasStarted;
	BOOL _endCall;
}
@property (nonatomic, weak, readwrite) id<LockViewDelegate>	delegate;

@property (nonatomic, strong) LockViewClosingView *lockViewClosingView;
@property (nonatomic, strong) IBOutlet UIImageView		*unlockButtonView;
@property (nonatomic, strong) IBOutlet UILabel *slideToLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) NSString			*imageName;
@property (nonatomic, strong) NSString			*label;
@property (nonatomic, strong) CABasicAnimation	*maskAnim;
@property (nonatomic, strong) CALayer			*maskLayer;
@property (nonatomic, assign) BOOL showPinEntryViewOnUnlock;

@property (strong, nonatomic) IBOutlet UIView *viewToast;

@property (strong, nonatomic) IBOutlet UIScrollView *videoScrollView;
@property (strong, nonatomic) IBOutlet UIView *activeView;

@property (strong, nonatomic) UISwipeGestureRecognizer* swipeRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer* longPressRecognizer;

@property (strong, nonatomic) IBOutlet UIButton *micButton;
@property (strong, nonatomic) IBOutlet UIButton *callButton;

@property (nonatomic, strong) GWCall* setVideoUrlCall;
@property (nonatomic, assign) BOOL videoUrlSet;
@property (strong, nonatomic) IBOutlet UIView *videoView;

- (void) startAnimation;
+ (LockView *) lockView;

@end

@protocol LockViewDelegate <NSObject>
- (void) lockDidRequestPin:(LockView *)lockView;
- (void) lockDidUnlock:(LockView *)lockView;
@optional
- (void) lockDidLongPressLock:(LockView *)lockView;
@end

