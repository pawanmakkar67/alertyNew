//
//  HeadsetTableViewCell.h
//  Alerty
//
//  Created by Gergely Meszaros-Komaromy on 02/07/16.
//
//

#import <UIKit/UIKit.h>

@interface HeadsetTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
