//
//  RouteAnnotation.h
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *_title;
	NSString *_subtitle;
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;

- (CLLocationCoordinate2D)coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
