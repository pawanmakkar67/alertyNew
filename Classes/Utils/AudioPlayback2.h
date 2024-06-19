//
//  AudioPlayback.h
//
//  Created by Bence Balint on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LibraryConfig.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AbstractSingleton.h"
#import "AudioStreamer.h"


extern NSString *const APStateChangedEvent;

typedef enum {
	APStateNone,
	APStateStopped,
	APStatePlaying,
	APStatePaused
} APState;


@class AudioStreamer;
@class AVAudioPlayer;

@interface AudioPlayback2 : AbstractSingleton <AVAudioPlayerDelegate>
{
	AudioStreamer *_streamer;
	AVAudioPlayer *_player;
	NSString *_url;
	BOOL _loop;
	BOOL _paused;
}

+ (AudioPlayback2*) instance;

+ (AVAudioPlayer*) player;
+ (AudioStreamer*) streamer;

+ (void) start:(NSString*)url;
+ (void) start:(NSString*)url loop:(BOOL)loop;
+ (void) stop;
+ (void) pause;

+ (NSString*) currentUrl;
+ (BOOL) isPlaying;

+ (void) seek:(NSTimeInterval)position;
+ (NSTimeInterval) position;
+ (NSTimeInterval) duration;

+ (APState) state;

@end
