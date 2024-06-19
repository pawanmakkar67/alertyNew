//
//  MediaCapture.h
//
//  Created by Balint Bence on 6/21/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CAPTURE
#import <Foundation/Foundation.h>
#import "CameraInterface.h"
#import "CaptureView.h"
#import "CameraCapture.h"


@class MediaCapture;

@protocol MediaCaptureDelegate <NSObject>
@optional
- (void) mediaCapture:(MediaCapture*)mediaCapture didChooseImage:(UIImage*)image;
- (void) mediaCapture:(MediaCapture*)mediaCapture didChooseVideo:(NSString*)url;
- (void) mediaCaptureDidFinishImportingImage:(MediaCapture*)mediaCapture;
- (void) mediaCaptureDidFinishImportingVideo:(MediaCapture*)mediaCapture;
- (void) mediaCaptureWillDismiss:(MediaCapture*)mediaCapture;
- (void) mediaCaptureDidDismiss:(MediaCapture*)mediaCapture;
@end


@interface MediaCapture : NSObject <UINavigationControllerDelegate,
									CameraInterfaceDelegate
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
									, UIPopoverControllerDelegate
#endif
>
{
	id<MediaCaptureDelegate> _delegate;
	id _userInfo;
	UIViewController *_ownerViewController;
	CameraInterface *_camera;
	
	BOOL _captureVideo;
	
	BOOL _importVideos;
	NSString *_videoDirectory;
	NSString *_videoPreset;						// AVCaptureSessionPreset
	
	BOOL _importImages;
	NSString *_imageDirectory;
	CGSize _imageSize;
	
	NSDictionary *_lastImportedMediaDescriptor;
	AVCaptureVideoOrientation _currentVideoOrientation;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	UIPopoverController *_contentPopover;
#endif
	BOOL _dismissedByUserInteraction;
	BOOL _imageNormalizationDisabled;
	BOOL _autoDismissalDisabled;
}

@property (readwrite,assign) id<MediaCaptureDelegate> delegate;
@property (readwrite,retain) id userInfo;
@property (readwrite,assign) IBOutlet UIViewController *ownerViewController;
@property (readwrite,retain) CameraInterface *camera;
@property (readwrite,assign) BOOL captureVideo;
@property (readwrite,assign) BOOL importVideos;
@property (readwrite,retain) NSString *videoDirectory;
@property (readwrite,retain) NSString *videoPreset;
@property (readwrite,assign) BOOL importImages;
@property (readwrite,retain) NSString *imageDirectory;
@property (readwrite,assign) CGSize imageSize;
@property (readwrite,retain) NSDictionary *lastImportedMediaDescriptor;
@property (readwrite,assign) AVCaptureVideoOrientation currentVideoOrientation;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
@property (readwrite,retain) UIPopoverController *contentPopover;
#endif
@property (readwrite,assign,getter=isDismissedByUserInteraction) BOOL dismissedByUserInteraction;
@property (readwrite,assign,getter=isImageNormalizationDisabled) BOOL imageNormalizationDisabled;
@property (readwrite,assign,getter=isAutoDismissalDisabled) BOOL autoDismissalDisabled;

+ (id) captureVideoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaCaptureDelegate>)delegate preset:(NSString*/*AVCaptureSessionPreset*/)preset;
+ (id) importVideoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaCaptureDelegate>)delegate preset:(NSString*/*AVCaptureSessionPreset*/)preset directory:(NSString*)directory;

+ (id) takePhotoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaCaptureDelegate>)delegate;
+ (id) importPhotoFromCamera:(UIViewController*)ownerViewController delegate:(id<MediaCaptureDelegate>)delegate size:(CGSize)size directory:(NSString*)directory;


- (void) dismiss:(BOOL)animated;
- (void) cancelImportingAndUnregisterDelegate;

@end
#endif
