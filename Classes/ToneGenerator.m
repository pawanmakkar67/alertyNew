//
//  ToneGenerator.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/3/13.
//
//

#import "ToneGenerator.h"
#import "NSHelpers.h"
#import <AVFoundation/AVFoundation.h>


static void stopAudioUnit(ToneGenerator *viewController);

@implementation ToneGenerator

@synthesize delegate = _delegate;

- (void)dealloc
{
	cmdlog
	
	stopAudioUnit(self);
	
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        sampleRate = 44100;
		frequency = 910;
		
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
		[self startGenerator];
    }
    return self;
}

- (void) startGenerator
{
	if( !toneUnit ) {
		[self createToneUnit];
		
		// Stop changing parameters on the unit
		OSErr err = AudioUnitInitialize(toneUnit);
		NSAssert1(err == noErr, @"Error initializing unit: %ld", (long)err);
		
		// Start playback
		playPhase = playPhaseStopped;
		err = AudioOutputUnitStart(toneUnit);
		NSAssert1(err == noErr, @"Error starting unit: %ld", (long)err);
	}
}

- (void) stopGenerator
{
	cmdlog
	if( toneUnit ) {
		stopAudioUnit(self);
	}
}

OSStatus RenderTone(
					void *inRefCon,
					AudioUnitRenderActionFlags *ioActionFlags,
					const AudioTimeStamp *inTimeStamp,
					UInt32 inBusNumber,
					UInt32 inNumberFrames,
					AudioBufferList *ioData)

{
    // Fixed amplitude is good enough for our purposes
    const double amplitude = 0.25;
	
	const double cutofflen = 100;
	
    // Get the tone parameters out of the view controller
    ToneGenerator *viewController = (ToneGenerator *)inRefCon;
    double theta = viewController->theta;
    double theta_increment = 2.0 * M_PI * viewController->frequency / viewController->sampleRate;
	
    // This is a mono tone generator so we only need the first buffer
    const int channel = 0;
    Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
    // Generate the samples
    for (UInt32 frame = 0; frame < inNumberFrames; frame++)
    {
		double tmpamplitude = amplitude;
		
		switch( viewController->playPhase )
		{
			case playPhaseStarting:
				if( frame == 0 ) {
					tmpamplitude = 0;
				}
				else if( frame < cutofflen ) {
					tmpamplitude = amplitude * ((double)frame / cutofflen);
				}
				else {
					viewController->playPhase = playPhasePlaying;
				}
				break;
			case playPhaseStopping:
				if( frame == inNumberFrames - 1 ) {
					tmpamplitude = 0;
					viewController->playPhase = playPhaseStopped;
				}
				else if( frame > inNumberFrames - cutofflen ) {
					tmpamplitude = amplitude * ((double)(inNumberFrames-frame) / cutofflen);
				}
				
				break;
			case playPhaseStopped:
				tmpamplitude = 0;
				break;
			default:
				break;
		}
		
        buffer[frame] = sin(theta) * tmpamplitude;
		
        theta += theta_increment;
		
        if (theta > 2.0 * M_PI)
        {
            theta -= 2.0 * M_PI;
        }
    }
	
    // Store the updated theta back in the view controller
    viewController->theta = theta;
	
    return noErr;
}

void stopAudioUnit(ToneGenerator *toneGenerator)
{
	AudioOutputUnitStop(toneGenerator->toneUnit);
	AudioUnitUninitialize(toneGenerator->toneUnit);
	AudioComponentInstanceDispose(toneGenerator->toneUnit);
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
	toneGenerator->toneUnit = NULL;
//	if( toneGenerator.delegate && [toneGenerator.delegate respondsToSelector:@selector(didStopToneGenerator:)] ) {
//		[toneGenerator.delegate didStopToneGenerator:toneGenerator];
//	}
}

- (void)createToneUnit
{
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %ld", (long)err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = self;
	err = AudioUnitSetProperty(toneUnit,
							   kAudioUnitProperty_SetRenderCallback,
							   kAudioUnitScope_Input,
							   0,
							   &input,
							   sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %ld", (long)err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
	kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
								kAudioUnitProperty_StreamFormat,
								kAudioUnitScope_Input,
								0,
								&streamFormat,
								sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %ld", (long)err);
}

- (void) playTone:(BOOL)play forSeconds:(double)seconds
{
	if (play) {
		if( playPhase == playPhaseStopped ) {
			playPhase = playPhaseStarting;			
			[self performSelector:@selector(cutoff) withObject:nil afterDelay:seconds];
		}
	}
	else {
		if( playPhase == playPhasePlaying ) {
			playPhase = playPhaseStopping;
		}
	}
}

- (void) cutoff
{
	[self playTone:NO forSeconds:0];
}

@end
