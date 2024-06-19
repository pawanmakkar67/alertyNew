//
//  MapImageOverlayView.m
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 05/10/16.
//
//

#import "MapImageOverlayView.h"

@interface MapImageOverlayView()

@property (nonatomic, strong) UIImage *overlayImage;
@property (nonatomic, assign) CGFloat rotation;

@end

@implementation MapImageOverlayView

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage rotation:(CGFloat)rotation {
    self = [super initWithOverlay:overlay];
    if (self) {
        self.overlayImage = overlayImage;
        self.rotation = rotation;
    }
    
    return self;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    return YES;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    CGImageRef imageReference = self.overlayImage.CGImage;
    
    MKMapRect theMapRect = self.overlay.boundingMapRect;
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextTranslateCTM(context, 0.0, -theRect.size.height);
    // Translate to center of image. This is done to rotate around the center,
    // rather than the edge of the picture
    CGContextTranslateCTM(context, theRect.size.width / 2, theRect.size.height / 2);
    
    // _rotation is the angle from the kml-file, converted to radians.
    CGContextRotateCTM(context, self.rotation);
    
    // Translate back after the rotation.
    CGContextTranslateCTM(context, -theRect.size.width / 2, -theRect.size.height / 2);
    
    CGContextDrawImage(context, theRect, imageReference);
}


@end
