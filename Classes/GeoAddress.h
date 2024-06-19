//
//  GeoAddress.h
//  Shareroutes
//
//  Created by moni on 1/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "JSON/JSON.h"
#import "HoshiTextField.h"

@class WifiApInfoViewController;

@interface GeoAddress : NSObject

@property (strong, nonatomic) HoshiTextField* delegate;

- (void) getGeoAddressByCoordinate:(CLLocationCoordinate2D)_coord;
- (void) evaluateJSONString:(NSDictionary *)_jsonString;

@end
