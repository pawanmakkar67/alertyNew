//
//  WifiAP.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WifiAP : NSManagedObject

@property (nonatomic, strong) NSString * bssid;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSNumber * locationLat;
@property (nonatomic, strong) NSNumber * locationLon;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * row;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * map;

@end
