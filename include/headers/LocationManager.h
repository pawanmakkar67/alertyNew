//
//  LocationManager.h
//
//  Created by Bence Balint on 19/03/14.
//  Copyright (c) 2014 Bence Balint. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LibraryConfig.h"
#if HAVE_CORE_LOCATION
#import <CoreLocation/CoreLocation.h>
#if HAVE_MAP_KIT
#import <MapKit/MapKit.h>
#endif
#import "AbstractSingleton.h"


@interface LocationManager : AbstractSingleton <CLLocationManagerDelegate>
{
	CLLocationManager *_locationManager;
	NSMutableArray *_locationUpdateIdentifiers;
	NSMutableArray *_headingUpdateIdentifiers;
	BOOL _updatingLocation;
	BOOL _updatingHeading;
	CLLocation *_currentLocation;
	CLLocation *_lastLocation;
	CLHeading *_currentHeading;
	CLHeading *_lastHeading;
	NSUInteger _searchCounter;
	NSUInteger _geocodeCounter;
	NSUInteger _reverseCounter;
}

+ (LocationManager*) instance;

+ (BOOL) areLocationServicesEnabled;

+ (void) startUpdatingLocation:(id)identifier;
+ (void) stopUpdatingLocation:(id)identifier;
+ (void) startUpdatingHeading:(id)identifier;
+ (void) stopUpdatingHeading:(id)identifier;

+ (CLLocation*) currentLocation;
+ (CLLocation*) lastLocation;
+ (CLHeading*) currentHeading;
+ (CLHeading*) lastHeading;

#if HAVE_MAP_KIT
+ (void) search:(NSString*)query completion:(void (^/*MKLocalSearchCompletionHandler*/)(MKLocalSearchResponse *response, NSError *error))completion;
+ (void) search:(NSString*)query region:(MKCoordinateRegion)region completion:(void (^/*MKLocalSearchCompletionHandler*/)(MKLocalSearchResponse *response, NSError *error))completion;
#endif
+ (void) geocode:(NSString*)address completion:(void (^/*CLGeocodeCompletionHandler*/)(NSArray *placemarks, NSError *error))completion;
+ (void) geocode:(NSString*)address region:(CLRegion*)region completion:(void (^/*CLGeocodeCompletionHandler*/)(NSArray *placemarks, NSError *error))completion;
+ (void) reverse:(CLLocation*)location completion:(void (^/*CLGeocodeCompletionHandler*/)(NSArray *placemarks, NSError *error))completion;

@end


static inline CLLocationCoordinate2D CoordinateForBudapest() {
	return CLLocationCoordinate2DMake(47.48259466, 19.12954250);
}

#if HAVE_MAP_KIT
static inline MKCoordinateSpan SpanForBudapest() {
	return MKCoordinateSpanMake(0.26186100, 0.40874700);
}

static inline MKCoordinateRegion RegionForBudapest() {
	CLLocationCoordinate2D center = CoordinateForBudapest();
	MKCoordinateSpan span = SpanForBudapest();
	return MKCoordinateRegionMake(center, span);
}
#endif
#endif
