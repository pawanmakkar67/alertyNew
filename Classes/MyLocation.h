//
//  MyLocation.h
//  ShareRoutes
//
//  Created by alfa on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject {

	Float64 _latitude;
	Float64 _longitude;
	NSInteger _speed;
	NSInteger _altitude;
	NSInteger _heading;   // haladasi irany (course a people tablaban)
	NSInteger _accuracy;
	NSInteger _verticalAccutacy;
	NSTimeInterval _timestamp;
	NSInteger _distance;
	NSInteger _duration;
	bool _sos;
	NSString *_userAddress;
	NSString *_userCity;
	NSString *_userCountry;
	
	NSString *_wifiapname;
	NSString *_wifiapbssid;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate Speed:(int)speed Altitude:(int)altitude Heading:(int)heading 
			   Accuracy:(int)accuracy VerticalAccuracy:(int)verticalAccuracy Distance:(int)distance Duration:(int)duration 
			   Timestamp:(NSTimeInterval)timestamp SOS:(bool)sos;

@property (nonatomic) Float64 latitude;
@property (nonatomic) Float64 longitude;
@property (nonatomic) NSInteger speed;
@property (nonatomic) NSInteger altitude;
@property (nonatomic) NSInteger heading;
@property (nonatomic) NSInteger accuracy;
@property (nonatomic) NSInteger verticalAccuracy;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic) NSInteger distance;
@property (nonatomic) NSInteger duration;
@property (nonatomic) bool sos;
@property (nonatomic, copy) NSString *userAddress;
@property (nonatomic, copy) NSString *userCity;
@property (nonatomic, copy) NSString *userCountry;
@property (nonatomic, copy) NSString *wifiapname;
@property (nonatomic, copy) NSString *wifiapbssid;
@property (nonatomic, strong) NSNumber* mapId;

@end
