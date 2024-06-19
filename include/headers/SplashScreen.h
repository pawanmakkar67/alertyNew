//
//  SplashScreen.h
//
//  Created by Bence Balint on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryConfig.h"
#if HAVE_AUDIO
#import <AVFoundation/AVFoundation.h>
#endif


@class SplashScreen;

@protocol SplashScreenDelegate <NSObject>
@optional
- (void) didActionSplash:(SplashScreen*)splash;
- (void) didFinishSplash:(SplashScreen*)splash;
- (void) didCancelSplash:(SplashScreen*)splash;
@end


@interface SplashScreen : UIImageView
#if HAVE_AUDIO
									  <AVAudioPlayerDelegate>
#endif
{
	id<SplashScreenDelegate> _delegate;
	NSString *_sound;
	NSTimer *_timeout;
#if HAVE_AUDIO
	AVAudioPlayer *_player;
#endif
	BOOL _dismissAfterPlay;
	BOOL _dismissOnTouch;
	id _userInfo;
}

@property (readwrite,retain) id userInfo;

+ (id) splashInView:(UIView*)view
			  frame:(CGRect)frame
			  image:(UIImage*)image
			 images:(NSArray*)images
		   duration:(NSTimeInterval)duration
			repeats:(NSInteger)repeats
			   play:(NSString*)filename
			   date:(NSDate*)date
		   delegate:(id<SplashScreenDelegate>)delegate
		   userInfo:(id)userInfo
   dismissAfterPlay:(BOOL)dismissAfterPlay
	 dismissOnTouch:(BOOL)dismissOnTouch;

- (void) dismiss;
- (void) start;
- (void) cancel;

@property (readwrite,assign) id<SplashScreenDelegate> delegate;
@property (readwrite,retain) NSString *sound;

@end
