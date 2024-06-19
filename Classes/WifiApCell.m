//
//  WifiApCell.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WifiApCell.h"
#import "config.h"

@implementation WifiApCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle =  UITableViewCellSelectionStyleNone;
		
		UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		deleteBtn.frame = CGRectMake(3.0, 7.0, 30.0, 30.0);
        [deleteBtn addTarget:self action:@selector(addOrDeleteFriend:) forControlEvents:UIControlEventTouchUpInside];
		deleteBtn.adjustsImageWhenHighlighted = NO;
		self.deleteButton = deleteBtn;
		[self.contentView addSubview:self.deleteButton];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel = label;
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
		self.titleLabel.opaque = NO;
		self.titleLabel.textColor = [UIColor blackColor];
		self.titleLabel.font = [UIFont systemFontOfSize:16.0];
		[self.contentView addSubview:self.titleLabel];
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.subtitleLabel = label;
		self.subtitleLabel.backgroundColor = [UIColor clearColor];
		self.subtitleLabel.opaque = NO;
		self.subtitleLabel.textColor = [UIColor blackColor];
		self.subtitleLabel.font = [UIFont italicSystemFontOfSize:14.0];
		[self.contentView addSubview:self.subtitleLabel];
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.creditLabel = label;
		self.creditLabel.backgroundColor = [UIColor clearColor];
		self.creditLabel.opaque = NO;
		self.creditLabel.textColor = [UIColor blackColor];
		self.creditLabel.font = [UIFont systemFontOfSize:16.0];
		[self.contentView addSubview:self.creditLabel];		        
    }
    return self;
}

- (void)setCellImage:(NSString *)imageName {
	[self.image setImage:[UIImage imageNamed:imageName]];
}	

- (void)layoutSubviews {
    
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	CGRect lFrame;
	
	if( !self.canInteract ) {
		[self.deleteButton setEnabled:NO];
	}
	else {
		[self.deleteButton setEnabled:YES];
	}
	
	if (self.deletable == NO) {
		if( self.canInteract ) {
			[self.deleteButton setImage:[UIImage imageNamed:@"btn_addfriend"] forState:UIControlStateNormal];
		}
		else {
			[self.deleteButton setImage:nil forState:UIControlStateNormal];
		}
		self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        lFrame.size.width = contentRect.size.width - 75.0;
		self.creditLabel.hidden = YES;
	}
	else {
        [self.deleteButton setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
		lFrame.size.width = contentRect.size.width - 75.0;
		self.creditLabel.hidden = YES;
	}
	
	lFrame.origin.x = 37.0;
	self.image.frame = CGRectMake(contentRect.size.width - 33.0, self.image.frame.origin.y, self.image.frame.size.width, self.image.frame.size.height);
	
    if ([self.subtitle length] > 0) {
		lFrame = CGRectMake(lFrame.origin.x, 3.0, lFrame.size.width, 22.0);
	}
	else {
		lFrame = CGRectMake(lFrame.origin.x, 12.0, lFrame.size.width, 22.0);
	}
	self.titleLabel.frame = lFrame;
	self.titleLabel.text = self.title;
	
	lFrame = CGRectMake(lFrame.origin.x, 26.0, contentRect.size.width - 75.0, 18.0);
	self.subtitleLabel.frame = lFrame;
	self.subtitleLabel.text = self.subtitle;
}

- (void) addOrDeleteFriend:(id)sender {
    if (self.deletable) {
        [self.cellDelegate deleteWifiAp:self.rowNumber];
    } else {
        [self.cellDelegate addWifiAp];
    }
}

@end
