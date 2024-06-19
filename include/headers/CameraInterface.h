//
//  CameraInterface.h
//
//  Created by Balint Bence on 5/18/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CAPTURE
#import <UIKit/UIKit.h>
#import "ViewControllerBase.h"
#import "PeakAvgBarView.h"
#import "CaptureView.h"
#import "SlideBar.h"
#import "MenuBar.h"
#import "BatteryLevelView.h"


// 
// MenuBar controls:
// 
// ---------------------------------------
// | [mediaBar]               [focusBar] |
// | [cameraBar]              [flashBar] |
// | [advancedBar]            [torchBar] |
// | [aspectBar]           [exposureBar] |
// | [triggerBar]           [balanceBar] |
// |                                     |
// |-------------------------------------|
// | [cancel]   [take|record]            |
// ---------------------------------------
// 
// 
// non MenuBar controls:
// 
// toolBar
// interestHighlight
// zoomControl
// peakAvgView
// 


@class CameraInterface;

@protocol CameraInterfaceDelegate <NSObject>
@optional
- (void) cameraInterfaceDidCancel:(CameraInterface*)camera;
- (void) imageReady:(CameraInterface*)camera image:(UIImage*)image error:(NSError*)error;
- (void) videoReady:(CameraInterface*)camera path:(NSString*)path error:(NSError*)error;
@end


@interface CameraInterface : ViewControllerBase <SlideBarDelegate,
												 MenuBarDelegate,
												 CameraCaptureDelegate>
{
	id<CameraInterfaceDelegate> _cameraInterfaceDelegate;
	CaptureView *captureView;
	
	UIPinchGestureRecognizer *_zoomRecognizer;
	UIPanGestureRecognizer *_moveRecognizer;
	UITapGestureRecognizer *_tapRecognizer;
	UIImageView *_interestHighlight;
	
	UISlider *_zoomSlider;
	UIImageView *_sliderPlus;
	UIImageView *_sliderMinus;
	
	BatteryLevelView *_batteryLevel;
	CGFloat _zoomFactor;
	CGPoint _interestPoint;
	CGPoint _lastDelta;
	
	UIView *toolbar;
	UIButton *cancelButton;
	UIButton *actionButton;
	
	NSTimer *_recordUpdateTimer;
	NSDate *_recordStartDate;
	PeakAvgBarView *_peakAvgBarView;
	UILabel *_timeLabel;
	UIView *_timeBg;
	
	MenuBar *_focusBar;
	MenuBar *_flashBar;
	MenuBar *_torchBar;
	MenuBar *_exposureBar;
	MenuBar *_balanceBar;
	MenuBar *_cameraBar;
	MenuBar *_mediaBar;
	MenuBar *_aspectBar;
	MenuBar *_advancedBar;
	MenuBar *_triggerBar;
	NSTimer *_triggerUpdateTimer;
	NSTimeInterval _lastBeepDiff;
	NSInteger _trigger;
	UILabel *_statusLabel;
	UIView *_statusBg;
	
	BOOL _triggerTicksDisabled;		// no tick sounds during countdown
	BOOL _advancedMode;				// YES to default
	BOOL _shouldAutorotate;			// YES to default
	BOOL _modeChangeDisabled;
	BOOL _torchForPhotoDisabled;
	BOOL _previewFittingDisabled;
	BOOL _advancedModeChangeDisabled;
	BOOL _cancelled;
	
	UIImageView *_imageToAnimate;
}

@property (readwrite,assign) id<CameraInterfaceDelegate> cameraInterfaceDelegate;
@property (readwrite,retain) NSTimer *recordUpdateTimer;
@property (readwrite,retain) IBOutlet UILabel *timeLabel;
@property (readwrite,retain) IBOutlet UIView *timeBg;
@property (nonatomic,retain) IBOutlet PeakAvgBarView *peakAvgBarView;
@property (nonatomic,retain) IBOutlet UIView *toolbar;
@property (nonatomic,retain) IBOutlet UIButton *cancelButton;
@property (nonatomic,retain) IBOutlet UIButton *actionButton;
@property (nonatomic,retain) IBOutlet CaptureView *captureView;
@property (nonatomic,retain) IBOutlet UIImageView *interestHighlight;
@property (nonatomic,retain) IBOutlet UISlider *zoomSlider;
@property (nonatomic,retain) IBOutlet UIImageView *sliderPlus;
@property (nonatomic,retain) IBOutlet UIImageView *sliderMinus;
@property (nonatomic,retain) IBOutlet BatteryLevelView *batteryLevel;
@property (readwrite,retain) MenuBar *focusBar;
@property (readwrite,retain) MenuBar *flashBar;
@property (readwrite,retain) MenuBar *torchBar;
@property (readwrite,retain) MenuBar *exposureBar;
@property (readwrite,retain) MenuBar *balanceBar;
@property (readwrite,retain) MenuBar *cameraBar;
@property (readwrite,retain) MenuBar *mediaBar;
@property (readwrite,retain) MenuBar *aspectBar;
@property (readwrite,retain) MenuBar *advancedBar;
@property (readwrite,retain) MenuBar *triggerBar;
@property (readwrite,retain) NSTimer *triggerUpdateTimer;
@property (readwrite,assign) NSTimeInterval lastBeepDiff;
@property (readwrite,retain) IBOutlet UILabel *statusLabel;
@property (readwrite,retain) IBOutlet UIView *statusBg;
@property (readwrite,assign) BOOL triggerTicksDisabled;
@property (readwrite,assign) BOOL advancedMode;
@property (readwrite,assign) BOOL shouldAutorotate;
@property (readwrite,assign) BOOL modeChangeDisabled;
@property (readwrite,assign) BOOL torchForPhotoDisabled;
@property (readwrite,assign) BOOL previewFittingDisabled;
@property (readwrite,assign) BOOL advancedModeChangeDisabled;

- (void) setCaptureMode:(CCCaptureMode)captureMode;

- (IBAction) cancelPressed:(id)sender;
- (IBAction) startVideoRecordPressed:(id)sender;
- (IBAction) stopVideoRecordPressed:(id)sender;
- (IBAction) startTakePhotoPressed:(id)sender;
- (IBAction) stopTakePhotoPressed:(id)sender;

@end
#endif
