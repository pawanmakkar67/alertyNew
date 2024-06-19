//
//  SettingCell.m
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 07..
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCell:(NSInteger)row datasource:(NSDictionary*) datasource {

    NSString *rowTitle = [[datasource allKeys] firstObject];
    NSString *imgName = [[datasource allValues] firstObject];
    self.labelTxt.text = rowTitle;
    self.iconImg.image = [UIImage imageNamed:imgName];


    if(row == 4){
        [self.separator setHidden:YES];
    }
}

@end
