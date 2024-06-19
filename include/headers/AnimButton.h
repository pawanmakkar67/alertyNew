//
//  AnimButton.h
//
//  Created by Bence Balint on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LibraryConfig.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#if HAVE_AUDIO
#import <AVFoundation/AVFoundation.h>
#endif
#import "ShapeButton.h"
#import "NSExtensionsConfig.h"


@interface AnimButton : ShapeButton
#if HAVE_AUDIO
									 <AVAudioPlayerDelegate>
#endif
{
	CGFloat _fps;
	NSInteger _counter;
	NSTimer *_timer;
	NSString *_name;
	CAAnimation *_fly;
	id _userInfo;
#if HAVE_AUDIO
	AVAudioPlayer *_player;
#endif
	
	NSInteger _audioRepeat;
	NSInteger _animRepeat;
	NSInteger _flyRepeat;
	NSInteger _audioCount;
	NSInteger _animCount;
	NSInteger _flyCount;
	
	BOOL _audioPaused;
	BOOL _animPaused;
	BOOL _flyPaused;
	
	UIView *_highlight;
}

@property (readwrite,retain) id userInfo;

+ (CAKeyframeAnimation*) flyWithDictionary:(NSDictionary*)fly;

+ (id) animButtonWithFrame:(CGRect)frame
					  name:(NSString*)name
					   fps:(CGFloat)fps
					   fly:(CAAnimation*)fly
				  userInfo:(id)userInfo;

+ (id) animButtonWithFrame:(CGRect)frame
					  name:(NSString*)name
					   fps:(CGFloat)fps
					   fly:(CAAnimation*)fly
				  userInfo:(id)userInfo
			   audioRepeat:(NSInteger)audioRepeat
				animRepeat:(NSInteger)animRepeat
				 flyRepeat:(NSInteger)flyRepeat;

- (void) play;
- (void) pause;
- (void) stop;

- (void) showHighlight:(UIView*)highlight;
- (void) showHighlight:(UIView*)highlight at:(CGPoint)position;		// position parameter is normalized in range: [0.0, 1.0]

- (void) playAudio;
- (void) pauseAudio;
- (void) stopAudio;
- (void) playAnim;
- (void) pauseAnim;
- (void) stopAnim;
- (void) playFly;
- (void) pauseFly;
- (void) stopFly;

@end
