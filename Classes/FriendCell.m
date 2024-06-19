//
//  FriendCell.m
//  Alerty
//
//  Created by Moni on 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FriendCell.h"
#import "config.h"
#import <AddressBook/AddressBook.h>

@implementation FriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
		
		self.phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7.0, 7.0, 48.0, 48.0)];
        self.phoneIcon.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
        self.phoneIcon.layer.cornerRadius = 24.0;
        self.phoneIcon.clipsToBounds = YES;
        self.phoneIcon.contentMode = UIViewContentModeScaleAspectFill;
		[self.contentView addSubview:self.phoneIcon];
		
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
		self.titleLabel.opaque = NO;
		self.titleLabel.textColor = [UIColor blackColor];
		self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
		[self.contentView addSubview:self.titleLabel];
		
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.statusLabel.backgroundColor = [UIColor clearColor];
		self.statusLabel.opaque = NO;
		self.statusLabel.textColor = [UIColor blackColor];
		self.statusLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
		[self.contentView addSubview:self.statusLabel];
        
		self.image = [[UIImageView alloc] initWithFrame:CGRectMake(253.0, 17.0, 22.0, 22.0)];
        self.image.image = [UIImage imageNamed:@"contact_question"];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
		[self.contentView addSubview:self.image];		
    }
    return self;
}

- (void)setCellDelegate:(id<FriendCellDelegate>)cellDelegate {
    _cellDelegate = cellDelegate;
    if (cellDelegate) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAction:)];
        [self.contentView addGestureRecognizer:tapGestureRecognizer];
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
}

- (void) didTapAction:(id)sender {
	[self addOrDeleteFriend:sender];
}

- (void)setCellImage:(NSString *)imageName {
	[self.image setImage:[UIImage imageNamed:imageName]];
}	

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	CGRect lFrame;
	
/*	if (!self.canInteract && !self.callEnabled) {
		[self.deleteButton setEnabled:NO];
	}
	else {
		[self.deleteButton setEnabled:YES];
	}*/
	
	self.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
	lFrame.size.width = contentRect.size.width - 79.0;

	lFrame.origin.x = 64.0;
	lFrame.size.width -= 50.0;
	self.image.frame = CGRectMake(contentRect.size.width - 33.0, self.image.frame.origin.y, self.image.frame.size.width, self.image.frame.size.height);
	
    lFrame = CGRectMake(lFrame.origin.x, 18.0, lFrame.size.width, 22.0);
	self.titleLabel.frame = lFrame;
	self.titleLabel.text = self.title;
	
	lFrame = CGRectMake(lFrame.origin.x, 36.0, contentRect.size.width - 75.0 - 50.0, 18.0);
	self.statusLabel.frame = lFrame;
	self.statusLabel.text = self.status;
}

- (void) addOrDeleteFriend:(id)sender
{
	if (!self.canInteract && !self.callEnabled) return;
	
    if (self.deletable || self.callEnabled) {
//		if (![AlertySettingsMgr isBusinessVersion]) {
//        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
//                                                         message:NSLocalizedString(@"Do you really want to delete your friend?", @"")
//                                                        delegate:self
//                                               cancelButtonTitle:NSLocalizedString(@"No", @"No")
//                                               otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
//        [_alert show];
//        [_alert release];
//		}
//		else {
//        UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@""
//                                                         message:NSLocalizedString(@"Do you really want to remove this contact?", @"")
//                                                        delegate:self
//                                               cancelButtonTitle:NSLocalizedString(@"No", @"No")
//                                               otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
//        [_alert show];
//        [_alert release];      
//		}
		if ([self.cellDelegate respondsToSelector:@selector(showFriend:)]) {
            [self.cellDelegate showFriend:self.contact];
		}
    }
    else
    {
        [self.cellDelegate addFriend:self];
    }
}

@end
