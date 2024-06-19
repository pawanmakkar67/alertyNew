//
//  VideoCell.h
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoCell : UITableViewCell {
    NSString *_videoTitle;
	NSString *_value;
	UILabel *_titleLabel;
	UILabel *_valueLabel;
}
@property (nonatomic, strong) NSString *videoTitle;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) UILabel *valueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;


@end
