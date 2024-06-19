//
//  IndoorLocationingViewController.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WifiApCell.h"
#import "WifiApInfoViewController.h"
#import "AlertyDBMgr.h"
#import "BaseViewController.h"

@interface IndoorLocationingViewController : BaseViewController <
									UITableViewDelegate,
									WifiApCellDelegate,
									UIAlertViewDelegate
									>
{
}

- (void)reloadWifiAps;
- (void) editWifiAp:(WifiAP *)wifiap;

@end
