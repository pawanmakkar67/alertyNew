//
//  MyLocation.m
//  ShareRoutes
//
//  Created by alfa on 12/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyLocation.h"


@implementation MyLocation

@synthesize latitude = _latitude, longitude = _longitude, speed = _speed, altitude = _altitude;
@synthesize heading = _heading, accuracy = _accuracy, distance = _distance, duration = _duration, timestamp = _timestamp, sos = _sos;
@synthesize userAddress = _userAddress, userCity = _userCity, userCountry = _userCountry;
@synthesize verticalAccuracy = _verticalAccuracy;
@synthesize wifiapname = _wifiapname;
@synthesize wifiapbssid = _wifiapbssid;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate Speed:(int)speed Altitude:(int)altitude Heading:(int)heading 
			   Accuracy:(int)accuracy VerticalAccuracy:(int)verticalAccuracy Distance:(int)distance Duration:(int)duration 
			   Timestamp:(NSTimeInterval)timestamp SOS:(bool)sos;
{
	if (self = [super init]) {
		self.latitude = coordinate.latitude;
		self.longitude = coordinate.longitude;
		self.speed = speed < 0 ? 0 : speed;
		self.altitude = altitude;
		self.heading = heading;
		self.accuracy = accuracy;
		self.verticalAccuracy = verticalAccuracy;
		self.distance = distance;
		self.duration = duration;
		self.timestamp = timestamp;
		self.sos = sos;
	}
	return self;
}


@end
