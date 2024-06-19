//
//  MapImage.m
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 05/10/16.
//
//

#import "MapImage.h"
#import "IndoorMap.h"
@import Proximiio;

@implementation MapImage

- (instancetype)initOffice {
    self = [super init];
    if (self) {
        
        /*_overlayTopLeftCoordinate = CLLocationCoordinate2DMake(47.5388019, 19.0646764);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(47.53882, 19.0658083);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(47.5384325, 19.0644806);*/
        
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(57.6706, 11.87870);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(57.6706, 11.8795);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(57.670270, 11.87870);
        
        _midCoordinate = CLLocationCoordinate2DMake((_overlayTopLeftCoordinate.latitude + _overlayBottomLeftCoordinate.latitude) / 2, (_overlayTopLeftCoordinate.longitude + _overlayTopRightCoordinate.longitude) / 2 );

        _rotation = -0.8;
    }
    
    return self;
}

- (instancetype)initSheraton {
    self = [super init];
    if (self) {
        /*_overlayTopLeftCoordinate = CLLocationCoordinate2DMake(59.32967, 18.06095);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(59.32967, 18.06202);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(59.3292, 18.06095);*/

        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(59.32967, 18.06092);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(59.32967, 18.06199);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(59.329185, 18.06092);

        _midCoordinate = CLLocationCoordinate2DMake((_overlayTopLeftCoordinate.latitude + _overlayBottomLeftCoordinate.latitude) / 2, (_overlayTopLeftCoordinate.longitude + _overlayTopRightCoordinate.longitude) / 2 );

        _rotation = -1.13;
    }
    return self;
}

- (instancetype)initWithIndoorMap:(IndoorMap *)map {
    self = [super init];
    if (self) {
        //_overlayTopLeftCoordinate = CLLocationCoordinate2DMake(map.top.doubleValue + 0.000018, map.left.doubleValue - 0.000054);
        //_overlayTopRightCoordinate = CLLocationCoordinate2DMake(map.top.doubleValue + 0.000018, map.right.doubleValue - 0.000054);
        //_overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(map.bottom.doubleValue + 0.000018, map.left.doubleValue - 0.000054);
        
        _overlayTopLeftCoordinate = CLLocationCoordinate2DMake(map.top.doubleValue + 0.0, map.left.doubleValue - 0.0);
        _overlayTopRightCoordinate = CLLocationCoordinate2DMake(map.top.doubleValue + 0.0, map.right.doubleValue - 0.0);
        _overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(map.bottom.doubleValue + 0.0, map.left.doubleValue - 0.0);
        _midCoordinate = CLLocationCoordinate2DMake((_overlayTopLeftCoordinate.latitude + _overlayBottomLeftCoordinate.latitude) / 2, (_overlayTopLeftCoordinate.longitude + _overlayTopRightCoordinate.longitude) / 2 );
        
        _rotation = map.rotation.doubleValue;
    }
    return self;
}

- (instancetype)initWithProximiioFloor:(ProximiioFloor *)floor {
    self = [super init];
    if (self) {
        
        self.rotation = -floor.floorPlanHeading /** 3.1415 / 180.0*/;
        ProximiioLocation* pivot = floor.anchors.firstObject;
        _midCoordinate = pivot.coordinate;
        
        _width = floor.floorPlanSideWidth;
        _height = floor.floorPlanSideHeight;
        
        //NSArray<ProximiioLocation*>* anchors = floor.anchors;
        //ProximiioLocation* location = anchors.firstObject;

    }
    return self;
}


- (CLLocationCoordinate2D)overlayBottomRightCoordinate {
    return CLLocationCoordinate2DMake(self.overlayBottomLeftCoordinate.latitude, self.overlayTopRightCoordinate.longitude);
}

- (MKMapRect)overlayBoundingMapRect {
    
    if (_width != 0.0 || _height != 0.0) {
        MKMapPoint center = MKMapPointForCoordinate(self.midCoordinate);
        CLLocationDistance distance = MKMetersPerMapPointAtLatitude(self.midCoordinate.latitude);
        double width = _width / distance;
        double height = _height / distance;
        return MKMapRectMake(center.x - width/2, center.y - height/2, width, height);
    } else {
        MKMapPoint topLeft = MKMapPointForCoordinate(self.overlayTopLeftCoordinate);
        MKMapPoint topRight = MKMapPointForCoordinate(self.overlayTopRightCoordinate);
        MKMapPoint bottomLeft = MKMapPointForCoordinate(self.overlayBottomLeftCoordinate);
        
        return MKMapRectMake(topLeft.x,
                             topLeft.y,
                             fabs(topLeft.x - topRight.x),
                             fabs(topLeft.y - bottomLeft.y));
    }
}

@end
