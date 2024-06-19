//
//  MapImageOverlayView.h
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 05/10/16.
//
//

#import <MapKit/MapKit.h>

@interface MapImageOverlayView : MKOverlayRenderer

- (instancetype)initWithOverlay:(id<MKOverlay>)overlay overlayImage:(UIImage *)overlayImage rotation:(CGFloat)rotation;

@end
