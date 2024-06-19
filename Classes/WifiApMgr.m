//
//  WifiApMgr.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import "AlertyDBMgr.h"
#import "WifiApMgr.h"
#import "NSExtensions.h"

@implementation WifiApMgr

+ (BOOL) isConnectedToWifiAP {
	return [WifiApMgr fetchBSSIDInfo] != nil;
}

+ (WifiAP *) currentWifiAp {
	WifiAP *wifiap = nil;
	NSString *bssid = [WifiApMgr fetchBSSIDInfo];
	if( bssid != nil ) {
		wifiap = [[AlertyDBMgr sharedAlertyDBMgr] getWifiApByBSSID:bssid];
	}
	return wifiap;
}

+ (NSString *) fetchBSSIDInfo
{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
//	cmdlogtext(@"%s: Supported interfaces: %@", __func__, ifs);
    NSString *bssid= nil;
    for (NSString *ifnam in ifs) {
        id info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
		bssid = info == nil ? nil : [[info valueForKey:@"BSSID"] stringValue];
		NSArray *bssidparts = [bssid componentsSeparatedByString:@":"];
		if ([bssidparts count]>=6) {
			bssid = [NSString stringWithFormat:@"%2s:%2s:%2s:%2s:%2s:%2s",
				 [[bssidparts objectAtIndex:0] cStringUsingEncoding:NSASCIIStringEncoding],
				 [[bssidparts objectAtIndex:1] cStringUsingEncoding:NSASCIIStringEncoding],
				 [[bssidparts objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding],
				 [[bssidparts objectAtIndex:3] cStringUsingEncoding:NSASCIIStringEncoding],
				 [[bssidparts objectAtIndex:4] cStringUsingEncoding:NSASCIIStringEncoding],
				 [[bssidparts objectAtIndex:5] cStringUsingEncoding:NSASCIIStringEncoding]
			];
			bssid = [NSString stringWithFormat:@"%@", [bssid stringByReplacingOccurrencesOfString:@" " withString:@"0"]];
		}
    }
    return bssid;
}

+ (NSString *) fetchSSIDInfo
{
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
//	cmdlogtext(@"%s: Supported interfaces: %@", __func__, ifs);
    NSString *bssid= nil;
    for (NSString *ifnam in ifs) {
        id info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
		bssid = info == nil ? nil : [NSString stringWithString:[info valueForKey:@"SSID"]];
//		cmdlogtext(@"%s: %@ => %@", __func__, ifnam, info);
    }
    return bssid;
}

@end
