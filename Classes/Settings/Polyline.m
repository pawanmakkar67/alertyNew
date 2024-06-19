//
//  Polyline.m
//  Alerty
//
//  Created by Viking on 2017. 03. 06..
//
//

#import "Polyline.h"

@implementation Polyline

/*+ (instancetype)polyline:(const MKMapPoint *)points count:(NSUInteger)count {
    Polyline* _Nonnull polyline = [Polyline polylineWithPoints:points count:count];
    return polyline;
}*/

- (MKMapRect)boundingMapRect {
    return MKMapRectWorld;
}


@end
