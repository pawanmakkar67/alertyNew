//
//  SettingCell.h
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 07..
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTxt;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIView *separator;

- (void)setCell:(NSInteger)row datasource:(NSDictionary*) datasource;

@end

NS_ASSUME_NONNULL_END
