//
//  MoreSettingCell.h
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 07..
//

#import <UIKit/UIKit.h>
#import "AlertyAppDelegate.h"
#import "SettingsViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface MoreSettingCell : UITableViewCell

@property (weak,nonatomic) UIViewController* alertDelegate;

@property (weak, nonatomic) IBOutlet UIView *seperator;
@property (weak, nonatomic) IBOutlet UILabel *labelTxt;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

- (void)setCell:(NSInteger)row title:(NSString*) title;



@end

NS_ASSUME_NONNULL_END
