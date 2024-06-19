//
//  WifiApMgr.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertyDBMgr.h"

@interface WifiApMgr : NSObject

+ (BOOL) isConnectedToWifiAP;
+ (WifiAP *) currentWifiAp;
+ (NSString *) fetchSSIDInfo;
+ (NSString *) fetchBSSIDInfo;

@end
