//
//  CameraCapture.h
//
//  Created by Balint Bence on 6/10/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CAPTURE
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>


// Frameworks:
//  CoreGraphics
//  QuartzCore
//  AVFoundation
//  CoreVideo
//  CoreMedia


extern CGFloat const kMaxZoomFactor;


typedef enum {
	CCCaptureNone,
	CCCapturePhoto,
	CCCaptureVideo
} CCCaptureMode;


@class CameraCapture;

@protocol CameraCaptureDelegate <NSObject>
@optional
- (void) imageReady:(CameraCapture*)capture image:(UIImage*)image;
- (void) imageError:(CameraCapture*)capture error:(NSError*)error;
- (void) videoReady:(CameraCapture*)capture path:(NSString*)path;
- (void) videoError:(CameraCapture*)capture path:(NSString*)path error:(NSError*)error;
@end


@interface CameraCapture : NSObject <//AVCaptureVideoDataOutputSampleBufferDelegate,
									 AVCaptureFileOutputRecordingDelegate>
{
	id<CameraCaptureDelegate> _captureDelegate;
	AVCaptureSession *_captureSession;
	AVCaptureInput *_captureInputBack;
	AVCaptureInput *_captureInputFront;
	AVCaptureInput *_captureInputAudio;
	AVCaptureOutput *_captureOutput;
	AVCaptureVideoPreviewLayer *_capturePreview;
	AVCaptureDevicePosition _capturePosition;
	CCCaptureMode _captureMode;
	CGFloat _zoomScale;
	CGPoint _interestPoint;
	CGFloat _movieFPS;
	NSString *_moviePreset;
	BOOL _recording;				// recording video
	BOOL _taking;					// taking photo
	BOOL _inflateZoomedPhotos;		// for digital zoom: no reason to store a big bitmap as it use digital zoom => we have less pixels
	AVCaptureVideoOrientation _currentVideoOrientation;
	NSTimer *_triggerTimer;
	
	// workaround for Apple bug 9807495
	AVCaptureExposureMode _workaroundExposureMode;
}

@property (readwrite,assign) id<CameraCaptureDelegate> captureDelegate;
@property (readwrite,retain) AVCaptureSession *captureSession;
@property (readwrite,retain) AVCaptureInput *captureInputBack;
@property (readwrite,retain) AVCaptureInput *captureInputFront;
@property (readwrite,retain) AVCaptureInput *captureInputAudio;
@property (readwrite,retain) AVCaptureOutput *captureOutput;
@property (readwrite,retain) AVCaptureVideoPreviewLayer *capturePreview;
@property (readwrite,assign) AVCaptureDevicePosition capturePosition;
@property (readwrite,assign) CCCaptureMode captureMode;
@property (readwrite,assign) CGFloat zoomScale;
@property (readwrite,assign) CGPoint interestPoint;
@property (readwrite,assign) CGFloat movieFPS;
@property (readwrite,retain) NSString *moviePreset;
@property (readwrite,assign,getter=isRecording) BOOL recording;
@property (readwrite,assign,getter=isTaking) BOOL taking;
@property (readwrite,assign,getter=isInflatingZoomedPhotos) BOOL inflateZoomedPhotos;
@property (readwrite,assign,getter=isFittingPreview) BOOL fitPreview;
@property (readwrite,assign) AVCaptureVideoOrientation currentVideoOrientation;
@property (readwrite,retain) NSTimer *triggerTimer;

+ (UIInterfaceOrientation) interfaceOrientationForVideoOrientation:(AVCaptureVideoOrientation)videoOrientation;
+ (AVCaptureVideoOrientation) videoOrientationForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (BOOL) isBusy;

// AVCaptureSessionPresetPhoto
// AVCaptureSessionPresetHigh
// AVCaptureSessionPresetMedium
// AVCaptureSessionPresetLow
// AVCaptureSessionPreset640x480
// AVCaptureSessionPreset1280x720
- (BOOL) setCapturePreset:(NSString*/*AVCaptureSessionPreset*/)preset;
- (BOOL) startCapturing;
- (BOOL) stopCapturing;

+ (NSArray*) camerasBearing;
+ (AVCaptureDevice*) getCamera:(AVCaptureDevicePosition)position;
+ (AVCaptureDevice*) getMicrophone;
- (AVCaptureDevice*) currentCamera;
- (BOOL) switchToCamera:(AVCaptureDevicePosition)position;

- (BOOL) lockForConfiguration:(AVCaptureDevice*)device;
- (void) unlockForConfiguration:(AVCaptureDevice*)device;

- (NSArray*) supportedTorchModes:(AVCaptureDevice*)device;
- (AVCaptureTorchMode) torchMode:(AVCaptureDevice*)device;
- (BOOL) setTorchMode:(AVCaptureTorchMode)mode forDevice:(AVCaptureDevice*)device;
- (BOOL) setTorchMode:(AVCaptureTorchMode)mode forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;

- (NSArray*) supportedFlashModes:(AVCaptureDevice*)device;
- (AVCaptureFlashMode) flashMode:(AVCaptureDevice*)device;
- (BOOL) setFlashMode:(AVCaptureFlashMode)mode forDevice:(AVCaptureDevice*)device;
- (BOOL) setFlashMode:(AVCaptureFlashMode)mode forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;

- (NSArray*) supportedFocusModes:(AVCaptureDevice*)device;
- (AVCaptureFocusMode) focusMode:(AVCaptureDevice*)device;
- (BOOL) setFocusMode:(AVCaptureFocusMode)mode forDevice:(AVCaptureDevice*)device;
- (BOOL) setFocusMode:(AVCaptureFocusMode)mode forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;

- (NSArray*) supportedExposureModes:(AVCaptureDevice*)device;
- (AVCaptureExposureMode) exposureMode:(AVCaptureDevice*)device;
- (BOOL) setExposureMode:(AVCaptureExposureMode)mode forDevice:(AVCaptureDevice*)device;
- (BOOL) setExposureMode:(AVCaptureExposureMode)mode forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;

- (NSArray*) supportedWhiteBalanceModes:(AVCaptureDevice*)device;
- (AVCaptureWhiteBalanceMode) whiteBalanceMode:(AVCaptureDevice*)device;
- (BOOL) setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)mode forDevice:(AVCaptureDevice*)device;
- (BOOL) setWhiteBalanceMode:(AVCaptureWhiteBalanceMode)mode forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;

- (CGPoint) focusPointOfInterest:(AVCaptureDevice*)device;
- (BOOL) setFocusPointOfInterest:(CGPoint)point forDevice:(AVCaptureDevice*)device;
- (BOOL) setFocusPointOfInterest:(CGPoint)point forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;

- (CGPoint) exposurePointOfInterest:(AVCaptureDevice*)device;
- (BOOL) setExposurePointOfInterest:(CGPoint)point forDevice:(AVCaptureDevice*)device;
- (BOOL) setExposurePointOfInterest:(CGPoint)point forDevice:(AVCaptureDevice*)device lock:(BOOL)lock;


- (void) cancel;
- (void) cancelAndRemoveDelegate;

- (BOOL) startImageTaking;
- (BOOL) startImageTakingWithDelay:(NSTimeInterval)delay;
- (void) cancelImageTaking;

- (BOOL) startVideoRecording;
- (BOOL) stopVideoRecording;

- (void) setVideoOrientationForCurrentOrientation;
- (void) setVideoOrientation:(AVCaptureVideoOrientation)orientation;

@end
#endif
