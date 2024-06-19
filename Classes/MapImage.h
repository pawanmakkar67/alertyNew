//
//  MapImage.h
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 05/10/16.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class IndoorMap;
@class ProximiioFloor;

@interface MapImage : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D midCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayTopLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayTopRightCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayBottomLeftCoordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D overlayBottomRightCoordinate;

@property (nonatomic, readonly) MKMapRect overlayBoundingMapRect;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

- (instancetype)initOffice;
- (instancetype)initSheraton;
- (instancetype)initWithIndoorMap:(IndoorMap*)map;
- (instancetype)initWithProximiioFloor:(ProximiioFloor*)floor;

@end
