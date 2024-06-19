//
//  ICEContactCell.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ICEContactCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NSHelpers.h"

@implementation ICEContactCell

@synthesize contactRowID;
@synthesize contactRelation;
@synthesize contactName;
@synthesize contactPhone;
@synthesize contactView;
@synthesize contactAddView;


- (void)layoutSubviews
{
	[super layoutSubviews];
	cmdlog
}
	
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	cmdlog
    // Configure the view for the selected state
}

@end
