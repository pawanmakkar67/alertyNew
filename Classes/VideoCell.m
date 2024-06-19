//
//  VideoCell.m
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoCell.h"


@implementation VideoCell

@synthesize videoTitle = _videoTitle;
@synthesize titleLabel = _titleLabel;
@synthesize value = _value;
@synthesize valueLabel = _valueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle =  UITableViewCellSelectionStyleNone;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel = label;
		self.titleLabel.backgroundColor = [UIColor clearColor];
		self.titleLabel.opaque = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
		self.titleLabel.textColor = [UIColor grayColor];
		self.titleLabel.numberOfLines = 0;
		
		[self.contentView addSubview:self.titleLabel];
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.valueLabel = label;
		self.valueLabel.backgroundColor = [UIColor clearColor];
		self.valueLabel.opaque = NO;
		self.valueLabel.textColor = [UIColor grayColor];
		self.valueLabel.font = [UIFont systemFontOfSize:15.0];
		self.valueLabel.textAlignment = NSTextAlignmentRight;
		self.valueLabel.numberOfLines = 0;
        self.valueLabel.autoresizingMask = UIViewAutoresizingNone;
        
		[self.contentView addSubview:self.valueLabel];		
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	
	self.titleLabel.frame = CGRectMake(20.0, 6.0, 120.0, 20.0);
	self.titleLabel.text = self.videoTitle;
	
	self.valueLabel.frame = CGRectMake(130.0, 6.0, contentRect.size.width - 170.0, 20.0);
	self.valueLabel.text = self.value;
	
	[self.valueLabel sizeToFit];
	[self.titleLabel sizeToFit];
	
	self.valueLabel.frame = CGRectMake(contentRect.size.width-self.valueLabel.frame.size.width-20, self.valueLabel.frame.origin.y, self.valueLabel.frame.size.width, self.valueLabel.frame.size.height);
}


@end
