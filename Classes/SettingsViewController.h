//
//  SettingsViewContoller.h
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SettingCell.h"
#import "MoreSettingCell.h"

@interface SettingsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
}

- (void)showIndoorLocation;

@end
