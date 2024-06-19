//
//  RouteAnnotation.m
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouteAnnotation.h"


@implementation RouteAnnotation

@synthesize coordinate, title = _title, subtitle = _subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
{
	if((self = [super init])){
		coordinate = coord;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate{
	return coordinate;
}


@end
