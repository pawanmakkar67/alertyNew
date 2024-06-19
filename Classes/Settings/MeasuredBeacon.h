//
//  MeasuredBeacon.h
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 26/10/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MeasuredBeacon : NSObject

@property (strong, nonatomic) CLBeacon* beacon;
@property (assign, nonatomic) CLLocationAccuracy accuracy;

@end
