//
//  ToneGenerator.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/3/13.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol ToneGeneratorDelegate;

@interface ToneGenerator : NSObject {
	AudioComponentInstance toneUnit;
	
	double frequency;
	double sampleRate;
	double theta;
	
	enum {
		playPhaseStarting,
		playPhasePlaying,
		playPhaseStopping,
		playPhaseStopped
	} playPhase;
}

@property (nonatomic, assign) id<ToneGeneratorDelegate> delegate;

- (void) playTone:(BOOL)play forSeconds:(double)seconds;
- (void) startGenerator;
- (void) stopGenerator;

@end

@protocol ToneGeneratorDelegate <NSObject>
- didStopToneGenerator:(ToneGenerator*)toneGenerator;
@end
