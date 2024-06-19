//
//  CaptureView.h
//
//  Created by Balint Bence on 6/14/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CAPTURE
#import <UIKit/UIKit.h>
#import "CameraCapture.h"


@interface CaptureView : UIView
{
	CameraCapture *_cameraCapture;
	AVCaptureVideoPreviewLayer *_previewLayer;
}

@property (readwrite,retain) CameraCapture *cameraCapture;

- (CGPoint) interestPoint;
- (BOOL) setInterestPoint:(CGPoint)interest;
- (CGFloat) zoomScale;
- (CGFloat) setZoomScale:(CGFloat)scale;

@end
#endif
