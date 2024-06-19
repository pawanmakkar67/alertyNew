//
//  UIViewAdditions.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "LibraryConfig.h"
#if HAVE_MAP_KIT
#import <MapKit/MapKit.h>
#import "NSHelpers.h"


@interface MKMapView (ExtendedMethods)

- (void) setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end


static inline MKCoordinateSpan CoordinateSpanForZoomLevel(NSUInteger zoomLevel, CLLocationCoordinate2D centerCoordinate, CGSize mapSize) {
	// maximum zoom level
	zoomLevel = MIN(100, zoomLevel);
	
	// convert center coordiate to pixel space
	double centerPixelX = LongitudeToPixelSpaceX(centerCoordinate.longitude);
	double centerPixelY = LatitudeToPixelSpaceY(centerCoordinate.latitude);
	
	// determine the scale value from the zoom level
	NSInteger zoomExponent = (20 - zoomLevel);
	double zoomScale = pow(2, zoomExponent);
	
	// scale the map’s size in pixel space
	double scaledMapWidth = (mapSize.width * zoomScale);
	double scaledMapHeight = (mapSize.height * zoomScale);
	
	// figure out the position of the top-left pixel
	double topLeftPixelX = (centerPixelX - (scaledMapWidth / 2.0));
	double topLeftPixelY = (centerPixelY - (scaledMapHeight / 2.0));
	
	// find delta between left and right longitudes
	CLLocationDegrees minLng = PixelSpaceXToLongitude(topLeftPixelX);
	CLLocationDegrees maxLng = PixelSpaceXToLongitude(topLeftPixelX + scaledMapWidth);
	CLLocationDegrees longitudeDelta = (maxLng - minLng);
	
	// find delta between top and bottom latitudes
	CLLocationDegrees minLat = PixelSpaceYToLatitude(topLeftPixelY);
	CLLocationDegrees maxLat = PixelSpaceYToLatitude(topLeftPixelY + scaledMapHeight);
	CLLocationDegrees latitudeDelta = (-1.0 * (maxLat - minLat));
	
	// create and return the lat/lng span
	MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
	return span;
}
#endif
