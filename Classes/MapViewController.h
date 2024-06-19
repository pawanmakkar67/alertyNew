//
//  MapViewController.h
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VideoPlayerBaseViewController.h"

@interface MapViewController : VideoPlayerBaseViewController

@property (nonatomic, strong) NSDictionary		*bounds;
@property (nonatomic, strong) NSString			*polyline;
@property (nonatomic, strong) NSString			*startDate;
@property (nonatomic, strong) NSString			*cancelDate;
@property (nonatomic, strong) NSNumber			*startLatitude;
@property (nonatomic, strong) NSNumber			*startLongitude;
@property (nonatomic, strong) NSString			*tracking;
@property (nonatomic, assign) NSInteger         mapId;

@end
