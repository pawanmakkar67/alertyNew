//
//  WifiApInfoViewController.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "AlertyDBMgr.h"
#import "BaseViewController.h"

@interface WifiApInfoViewController : BaseViewController

@property (nonatomic, strong) WifiAP *wifiAp;
@property (nonatomic, strong) NSString* beaconId;
@property (nonatomic, assign) BOOL isNew;

/*- (IBAction) setEditable:(id)sender;
- (IBAction) closeView:(id)sender;
- (IBAction) deleteWifiAp:(id)sender;
- (void) addWifiAp:(BOOL)company;
- (void) addWifiApToServer:(BOOL)addToCompany;
- (void) storeWifiAp;
- (void) reloadWifiInfo;*/

@end
