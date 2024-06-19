//
//  HeadsetTableViewCell.m
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 02/07/16.
//
//

#import "HeadsetTableViewCell.h"

@implementation HeadsetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)prepareForReuse {
    self.titleLabel.text = @"";
    self.subtitleLabel.text = @"";
    self.statusLabel.text = @"";
}

@end
