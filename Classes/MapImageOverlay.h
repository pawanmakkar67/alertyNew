//
//  MapImageOverlay.h
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 05/10/16.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class MapImage;
@interface MapImageOverlay : NSObject<MKOverlay>

@property (strong, nonatomic) UIImage* overlayImage;
@property (assign, nonatomic) CGFloat rotation;

- (instancetype)initWithMapImage:(MapImage*)mapImage overlayImage:(UIImage *)overlayImage rotation:(CGFloat)rotation;

@end
