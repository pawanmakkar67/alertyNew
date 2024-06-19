//
//  VideoManager.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 11/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AudioVideoManager.h"
#import "config.h"
#import "NSHelpers.h"
#import "DataManager.h"
#import "AlertySettingsMgr.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"

@interface AudioVideoManager()
- (void) invalidateTimers;
- (void) initVideoRecorder;
- (void) initAudioRecorder;
- (NSURL*) tempFileURL:(NSString *)extension;
- (void) postRecordingAtURL:(NSURL*)outputFileURL;
@end

@implementation AudioVideoManager

@synthesize captureSession = _captureSession;
@synthesize capturedMovieOutput = _capturedMovieOutput;
@synthesize fetcherTmp = _fetcherTmp;
@synthesize audioOnly = _audioOnly;
@synthesize audioRecorder = _audioRecorder;

#pragma mark - Overrides

- (void)dealloc {
	[self invalidateTimers];
	
    [_captureSession release];
	[_capturedMovieOutput release];
	[_fetcherTmp release];
	[_audioPlayer release];
	[_audioRecorder release];
	
    [super dealloc];
}

#pragma mark - Private methods

- (void) invalidateTimers {
	[_durationTimer invalidate];
	_durationTimer = nil;
}

- (void) initVideoRecorder
{
#if !(TARGET_IPHONE_SIMULATOR)
	AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
	AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
	
	self.capturedMovieOutput = [[[AVCaptureMovieFileOutput alloc] init] autorelease];
	self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
	
	[self.captureSession addInput:videoInput];
    [self.captureSession addInput:audioInput];
	
 	[self.captureSession addOutput:self.capturedMovieOutput];
	
	[self.captureSession beginConfiguration]; 
	[self.captureSession setSessionPreset:AVCaptureSessionPresetLow]; 
	[self.captureSession commitConfiguration]; 
#endif
	
}

- (void) initAudioRecorder
{
	NSDictionary *recordSettings = [NSDictionary 
									dictionaryWithObjectsAndKeys:
									[NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
									[NSNumber numberWithInt:AVAudioQualityMin], AVEncoderAudioQualityKey,
									[NSNumber numberWithInt:8], AVEncoderBitRateKey,
									[NSNumber numberWithInt:1], AVNumberOfChannelsKey,
									[NSNumber numberWithFloat:22050.0], AVSampleRateKey,
									nil];
	
	NSError *error = nil;
	
	self.audioRecorder = [[[AVAudioRecorder alloc] initWithURL:[self tempFileURL:@"aac"] settings:recordSettings error:&error] autorelease];
	self.audioRecorder.delegate = self;
	
	if (error) {
		cmdlogtext(@"error: %@", [error localizedDescription]);
	}
	else {
		[self.audioRecorder prepareToRecord];
	}
}

- (NSURL*) tempFileURL:(NSString *)extension
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd-HHmmss"];
	
	NSString *outputPath = [NSString stringWithFormat:@"%@/%@%@.%@",
							documentsDirectory,
							//							@"sosvideo",
							@"sosfile",
							[dateFormatter stringFromDate:[NSDate date]],
							extension];
	
	
	NSURL *outputURL = [[[NSURL alloc] initFileURLWithPath:outputPath] autorelease];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:outputPath]) {
		[[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
	}
	
	return outputURL;
}

- (void) postRecordingAtURL:(NSURL*)outputFileURL
{
	NSError *error;
	NSData *fileData = [NSData dataWithContentsOfURL:outputFileURL options:0 error:&error];
	
	NSArray *docs = [NSArray arrayWithObjects:@"uploadedfile", nil];
	NSArray *fns = [NSArray arrayWithObjects:[outputFileURL lastPathComponent], nil];
	
	NSString *type = ([AlertySettingsMgr isBusinessVersion] ? @"business" : @"personal");
	NSString *sosURLStr = (self.audioOnly ? SOS_AUDIO_URL : SOS_VIDEO_URL);
	
	[URLFetcher postFormData:self
						 url:[NSString stringWithFormat:sosURLStr, [DataManager sharedDataManager].alertId, type]
						 get:nil
					   forms:_nsarray(fileData)
				   documents:docs
				   filenames:fns
					userInfo:nil];
}

#pragma mark - Audio

- (void) initAudioPlayer {
	if (!_audioPlayer) {
		NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"trick" ofType: @"wav"];
		NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: soundFilePath] autorelease];
		_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	}
}

- (void) playAudio {
	[_audioPlayer play];
}

- (void) pauseAudio {
	[_audioPlayer pause];
}

#pragma mark - Media recording

- (void) initCapture {
	if (self.audioOnly) {
		[self initAudioRecorder];
	}
	else {
		[self initVideoRecorder];
	}
}

- (void) startRecording
{
	if (self.audioOnly) {
		[self.audioRecorder record];
	}
	else {
		[self.capturedMovieOutput startRecordingToOutputFileURL:[self tempFileURL:@"qt"] recordingDelegate:self];
		_durationTimer = [NSTimer scheduledTimerWithTimeInterval:2*VIDEO_DURATION target:self selector:@selector(stopRecording) userInfo:nil repeats:NO];
	}
	cmdlogtext(@"start record video");
}

- (void) stopRecording
{
	[_durationTimer invalidate];
	_durationTimer = nil;
	
	if (self.audioOnly) {
		if([self.audioRecorder isRecording])
		{
			[self.audioRecorder stop];
		}
	}
	else {
		if([self.capturedMovieOutput isRecording])
		{
			[self.capturedMovieOutput stopRecording];
		}
	}
}

#pragma mark - AVAudioRecorderDelegate

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	if( flag ) {
		NSURL *outputFileURL = [recorder url];
		[self postRecordingAtURL:outputFileURL];
	}
	if( [DataManager sharedDataManager].underSosMode && [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
	{
        [self performSelector:@selector(startRecording) withObject:self afterDelay:0.5];
	}
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
	cmdlogtext(@"Encode Error occurred");
	
	if( [DataManager sharedDataManager].underSosMode && [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
	{
        [self performSelector:@selector(startRecording) withObject:self afterDelay:0.5];
	}
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
	cmdlogtext(@"start record video");
	[_durationTimer invalidate];
	_durationTimer = nil;
	_durationTimer = [NSTimer scheduledTimerWithTimeInterval:VIDEO_DURATION target:self selector:@selector(stopRecording) userInfo:nil repeats:NO];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
	BOOL recordedSuccessfully = YES; 
	if ([error code] != noErr) {
		id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
		if (value) { 
			recordedSuccessfully = [value boolValue];
		}
		/*if (!recordedSuccessfully) {
			[AlertyAppDelegate showAlert:@"Video recording error" :[error description] :NSLocalizedString(@"OK", @"OK") :nil];
		}*/
	}
	if( recordedSuccessfully )
	{
		[self postRecordingAtURL:outputFileURL];
	}
	if( [DataManager sharedDataManager].underSosMode && [UIApplication sharedApplication].applicationState != UIApplicationStateBackground )
	{
        [self performSelector:@selector(startRecording) withObject:self afterDelay:0.5];
	}
}

//#pragma mark - URLFetcherDataStore
//
//- (void) urlFetcher:(URLFetcher*)uf clear:(long long)size {
//	self.fetcherTmp = [NSMutableData data];
//}
//
//- (void) urlFetcher:(URLFetcher*)uf append:(NSData*)data {
//	[self.fetcherTmp appendData:data];
//}
//
//- (long long) urlFetcherDataLength:(URLFetcher*)uf {
//	return (long long)self.fetcherTmp.length;
//}
//
//- (NSData*) urlFetcherData:(URLFetcher*)uf {
//	return self.fetcherTmp;
//}
//
#pragma mark - URLFetcherDelegate

//- (void) urlFetcherSuccess:(URLFetcher*)uf;
- (void) urlFetcherDidSucceed:(URLFetcher*)uf;
{
	cmdlog
}

//- (void) urlFetcherFail:(URLFetcher*)uf error:(NSError*)error
- (void) urlFetcherDidFail:(URLFetcher*)uf error:(NSError*)error
{
	cmdlog
}

@end
