//
//  AudioVideoManager.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "URLFetcher.h"

@interface AudioVideoManager : NSObject <
									AVAudioRecorderDelegate,
									AVCaptureFileOutputRecordingDelegate,
//									URLFetcherDataStore,
									URLFetcherDelegate
									>
{
	AVAudioPlayer *_audioPlayer;
	NSTimer *_durationTimer;
}

@property (nonatomic, retain) AVAudioRecorder *audioRecorder;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureMovieFileOutput *capturedMovieOutput;
@property (nonatomic, retain) NSMutableData *fetcherTmp;
@property (nonatomic, assign) BOOL audioOnly;

- (void) initAudioPlayer;
- (void) playAudio;
- (void) pauseAudio;

- (void) initCapture;
- (void) startRecording;
- (void) stopRecording;

@end
