//
//  AudioRecordInterface.h
//
//  Created by Balint Bence on 5/18/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_MEDIA_AUDIO
#import <UIKit/UIKit.h>
#import "ViewControllerBase.h"
#import "MediaPicker.h"
#import "PeakAvgSineView.h"


@interface AudioRecordInterface : ViewControllerBase
#if HAVE_AUDIO
													 <AudioRecorderInterface>
#endif
{
	MediaPicker *_ownerPicker;
	NSTimer *_recordPeakTimer;
	BOOL _shouldAutorotate;			// YES to default
	NSMutableArray *_labels;
	BOOL _recording;
	PeakAvgSineView *peakAvgSineView;
	UIView *labelView;
	UIToolbar *toolbar;
}

@property (readwrite,assign) MediaPicker *ownerPicker;
@property (readwrite,retain) NSTimer *recordPeakTimer;
@property (readwrite,assign) BOOL shouldAutorotate;
@property (nonatomic,retain) IBOutlet PeakAvgSineView *peakAvgSineView;
@property (nonatomic,retain) IBOutlet UIView *labelView;
@property (nonatomic,retain) IBOutlet UIToolbar *toolbar;

- (void) cancelAudioRecordPressed:(id)sender;
- (void) startAudioRecordPressed:(id)sender;
- (void) stopAudioRecordPressed:(id)sender;

@end
#endif
