//
//  MapImageOverlay.m
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 05/10/16.
//
//

#import "MapImageOverlay.h"
#import "MapImage.h"


@interface MapImageOverlay()

@end

@implementation MapImageOverlay
@synthesize boundingMapRect = _boundingMapRect, coordinate = _coordinate, overlayImage = _overlayImage;


- (instancetype)initWithMapImage:(MapImage*)mapImage overlayImage:(UIImage *)overlayImage rotation:(CGFloat)rotation {
    self = [super init];
    if (self) {
        _boundingMapRect = mapImage.overlayBoundingMapRect;
        _coordinate = mapImage.midCoordinate;
        self.overlayImage = overlayImage;
        _rotation = rotation;
    }
    return self;
}

@end
