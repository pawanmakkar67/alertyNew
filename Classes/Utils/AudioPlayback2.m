//
//  AudioPlayback.m
//
//  Created by Bence Balint on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AudioPlayback2.h"
#import "NSExtensions.h"


//NSString *const APStateChangedEvent		= @"APStateChangedEvent";


@interface AudioPlayback2 ()
@property (readwrite, strong) AudioStreamer *streamer;
@property (readwrite, strong) AVAudioPlayer *player;
@property (readwrite, strong) NSString *url;
@property (readwrite, assign) BOOL loop;

- (void) startStreamer;
- (void) createStreamer:(NSString*)url;
- (void) destroyStreamer;
- (void) playbackStateChanged:(NSNotification *)aNotification;

- (void) startPlayer;
- (void) createPlayer:(NSString*)file;
- (void) destroyPlayer;

+ (void) reset;

- (void) start:(NSString*)url;
- (void) start:(NSString*)url loop:(BOOL)loop;
- (void) stop;
- (void) pause;

- (NSString*) currentUrl;
- (BOOL) isPlaying;
- (void) seek:(NSTimeInterval)position;
- (NSTimeInterval) position;
- (NSTimeInterval) duration;

- (APState) state;

@end


@implementation AudioPlayback2

@synthesize streamer = _streamer;
@synthesize player = _player;
@synthesize url = _url;
@synthesize loop = _loop;

static AudioPlayback2 *__AudioPlaybackSingletonInstance = nil;

+ (AudioPlayback2*) instance {
	@synchronized([AudioPlayback2 class]) {
		if (!__AudioPlaybackSingletonInstance) __AudioPlaybackSingletonInstance = [AudioPlayback2 singleton];
	}
	return __AudioPlaybackSingletonInstance;
}

- (id)initSingleton {
	if (self = [super initSingleton]) {
		self.streamer = nil;
		self.player = nil;
		self.url = nil;
	}
	return self;
}

+ (void) reset {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		[ap destroyStreamer];
		ap.streamer = nil;
		[ap destroyPlayer];
		ap.player = nil;
	}
}

#pragma mark -
#pragma mark Public methods

+ (AVAudioPlayer*) player {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		return ap.player;
	}
	return nil;
}

+ (AudioStreamer*) streamer {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		return ap.streamer;
	}
	return nil;
}

+ (void) start:(NSString*)url {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		[ap start:url];
	}
}

+ (void) start:(NSString*)url loop:(BOOL)loop {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		[ap start:url loop:loop];
	}
}

+ (void) stop {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		[ap stop];
	}
}

+ (void) pause {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		[ap pause];
	}
}

+ (NSString*) currentUrl {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		NSString *ret = [ap currentUrl];
		return ret;
	}
	return nil;
}

+ (BOOL) isPlaying {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		BOOL ret = [ap isPlaying];
		return ret;
	}
	return NO;
}

+ (void) seek:(NSTimeInterval)position {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		[ap seek:position];
	}
}

+ (NSTimeInterval) position {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		return [ap position];
	}
	return 0.0;
}

+ (NSTimeInterval) duration {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		return [ap duration];
	}
	return 0.0;
}

+ (APState) state {
	@synchronized([AudioPlayback2 class]) {
		AudioPlayback2 *ap = [AudioPlayback2 instance];
		return [ap state];
	}
	return APStateStopped;
}

#pragma mark -
#pragma mark Control methods

- (void) start:(NSString*)url {
	[self start:url loop:NO];
}

- (void) start:(NSString*)url loop:(BOOL)loop {
	[self stop];
	self.url = url;
	_loop = loop;
	if ([url isCompleteWebURLPath]) {
		[self createStreamer:url];
		[self startStreamer];
	}
	else {
		[self createPlayer:url];
		[self startPlayer];
	}
}

- (void) stop {
	[self destroyPlayer];
	[self destroyStreamer];
	self.url = nil;
}

- (void) pause {
	_paused = !_paused;
	if (_paused) {
		[_streamer pause];
		[_player pause];
	}
	else {
		[_streamer start];
		[_player play];
	}
}

- (NSString*) currentUrl {
	return _url;
}

- (BOOL) isPlaying {
	if (_player) {
		return _player.isPlaying;
	}
	else if (_streamer) {
		return _streamer.isPlaying;
	}
	return NO;
}

- (void) seek:(NSTimeInterval)position {
	if (_player) {
		[_player stop];
		[_player setCurrentTime:position];
		[_player prepareToPlay];
		[_player play];
	}
	else {
		[_streamer seekToTime:position];
	}
}

- (NSTimeInterval) position {
	if (_player) {
		return [_player currentTime];
	}
	else {
		return [_streamer progress];
	}
}

- (NSTimeInterval) duration {
	if (_player) {
		return [_player duration];
	}
	else {
		return [_streamer duration];
	}
}

- (APState) state {
	if (_player) {
		if (_paused) {
			return APStatePaused;
		}
		else if ([_player isPlaying]) {
			return APStatePlaying;
		}
		else {
			return APStateStopped;
		}
	}
	else if (_streamer) {
		if (_paused) {
			return APStatePaused;
		}
		else if ([_streamer isPlaying]) {
			return APStatePlaying;
		}
		else {
			return APStateStopped;
		}
	}
	else {
		_paused = NO;
		return APStateNone;
	}
}

#pragma mark -
#pragma mark AVAudioPlayer

- (void) startPlayer {
	if (!_player) return;
	[_player setVolume:1.0];
	[_player prepareToPlay];
	[_player play];
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

- (void) createPlayer:(NSString*)file {
	if (!file.length) return;
	if (_player) return;
	// set audio category
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	// activates the audio session
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	// creates the player
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:file.url error:nil];
	_player.delegate = self;
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

- (void) destroyPlayer {
	if (!_player) return;
	[_player stop];
	self.player = nil;
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

// audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption.
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[self destroyPlayer];
	// repeat
	if (_loop) {
		[self start:_url loop:YES];
	}
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

// if an error occurs while decoding it will be reported to the delegate.
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	[self destroyPlayer];
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

// audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused.
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

// audioPlayerEndInterruption: is called when the audio session interruption has ended and this player had been interrupted while playing. The player can be restarted at this point.
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	[self startPlayer];
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

#pragma mark -
#pragma mark AudioStreamer

- (void) startStreamer {
	if (!_streamer) return;
	[_streamer start];
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

//
// createStreamer
//
// Creates or recreates the AudioStreamer object.
//
- (void) createStreamer:(NSString*)url {
	if (!url.length) return;
	if (_streamer) return;
	// creates the streamer
	self.streamer = [[AudioStreamer alloc] initWithURL:url.url];
	// subscribe to notification
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:_streamer];
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

//
// destroyStreamer
//
// Removes the streamer, the UI update timer and the change notification
//
- (void) destroyStreamer {
	if (!_streamer) return;
	// unsubscribe from notification
	[[NSNotificationCenter defaultCenter] removeObserver:self name:ASStatusChangedNotification object:_streamer];
	[_streamer stop];
	self.streamer = nil;
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

#pragma mark -
#pragma mark AudioStreamer notification

//
// playbackStateChanged:
//
// Invoked when the AudioStreamer
// reports that its playback status has changed.
//
- (void) playbackStateChanged:(NSNotification *)aNotification {
	if ([_streamer isWaiting]) {
	}
	else if ([_streamer isPlaying]) {
	}
	else if ([_streamer isIdle]) {
		[self destroyStreamer];
		// repeat
		if (_loop) {
			[self start:_url loop:YES];
		}
	}
	
	[NSNotificationCenter postAsyncNotificationOnMainThreadName:APStateChangedEvent object:nil userInfo:nil];
}

@end
