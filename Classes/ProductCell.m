//
//  ProductCell.m
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductCell.h"

#define kProductCellDisabledShade 0.5f

@interface ProductCell () {
	UIColor *_originalBGColor;
	UIColor *_disabledBGColor;
}

@property (nonatomic, strong) UIColor *originalBGColor;
@property (nonatomic, strong) UIColor *disabledBGColor;

@end

@implementation ProductCell

@synthesize title = _title;
@synthesize titleLabel = _titleLabel;
@synthesize buttonTitle = _buttonTitle;
@synthesize isProduct = _isProduct;
@synthesize buyButton = _buyButton;
@synthesize rowNumber = _rowNumber;
@synthesize buttonLabel = _buttonLabel;
@synthesize cellDelegate = _cellDelegate;
@synthesize productType = _productType;
@synthesize enabled = _enabled;

@synthesize originalBGColor = _originalBGColor;
@synthesize disabledBGColor = _disabledBGColor;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle =  UITableViewCellSelectionStyleNone;
		
		UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		buyBtn.frame = CGRectMake(225.0, 10.0, 70.0, 29.0);
		[buyBtn setBackgroundColor:[UIColor clearColor]];
		[buyBtn addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
		[buyBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_bg"] forState:UIControlStateNormal];
		self.buyButton = buyBtn;
		[self.contentView addSubview:self.buyButton];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel = label;
		self.titleLabel.backgroundColor = [UIColor clearColor];
		self.titleLabel.opaque = NO;
		self.titleLabel.textColor = [UIColor blackColor];
		self.titleLabel.font = [UIFont systemFontOfSize:16.0];
		[self.contentView addSubview:self.titleLabel];
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
        self.buttonLabel = label;
		self.buttonLabel.backgroundColor = [UIColor clearColor];
		self.buttonLabel.opaque = NO;
		self.buttonLabel.textColor = [UIColor blackColor];
		self.buttonLabel.font = [UIFont systemFontOfSize:14.0];
		self.buttonLabel.textAlignment = NSTextAlignmentCenter;
		[self.contentView addSubview:self.buttonLabel];
		
		self.originalBGColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.0f];
		self.disabledBGColor = [UIColor colorWithRed:kProductCellDisabledShade 
										  green:kProductCellDisabledShade 
										   blue:kProductCellDisabledShade 
										  alpha:1.0f
						   ];
			
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, 5.0, 40.0, 40.0)];
		[img setImage:[UIImage imageNamed:@"redbutton_small.png"]];
		[self.contentView addSubview:img];		
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	
	self.titleLabel.frame = CGRectMake(50.0, 15.0, contentRect.size.width - 125, 22.0);
	self.titleLabel.text = self.title;
	
	self.buttonLabel.text = self.buttonTitle;
	
	if( self.isProduct ) {
		self.buyButton.hidden = NO;
		self.buttonLabel.frame = CGRectMake(225.0, 10.0, 70.0, 29.0);
		self.titleLabel.font = [UIFont systemFontOfSize:16.0];
		self.buttonLabel.font = [UIFont systemFontOfSize:14.0];
		self.buttonLabel.textColor = [UIColor whiteColor];
	}
	else {
		self.buyButton.hidden = YES;
		self.buttonLabel.frame = CGRectMake(225.0, 15.0, 70.0, 22.0);
		self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
		self.buttonLabel.font = [UIFont boldSystemFontOfSize:16.0];
		self.buttonLabel.textColor = [UIColor blackColor];
		for (UIView *v in self.contentView.subviews) {
			if ([v isKindOfClass:[UIImageView class]]) {
				v.hidden = YES;
			}
		}
	}
	
	if( self.productType == 0 ) {
		self.titleLabel.frame = CGRectMake(50.0, 15.0, contentRect.size.width - 125, 22.0);
		for (UIView *v in self.contentView.subviews) {
			if ([v isKindOfClass:[UIImageView class]]) {
				v.hidden = NO;
			}
		}
	}
	else {
		self.titleLabel.frame = CGRectMake(10.0, 15.0, contentRect.size.width - 125, 22.0);
		for (UIView *v in self.contentView.subviews) {
			if ([v isKindOfClass:[UIImageView class]]) {
				v.hidden = YES;
			}
		}
	}
	
	self.buyButton.enabled = self.enabled;
	self.titleLabel.backgroundColor = self.enabled ? self.originalBGColor : self.disabledBGColor;
	self.backgroundColor = self.enabled ? self.originalBGColor : self.disabledBGColor;	
}

- (void)buyProduct:(id)sender
{
	UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Purchase Confirmation!", @"")
													 message:NSLocalizedString(@"Are you sure you want to buy credit(s)?", @"")
													delegate:self
										   cancelButtonTitle:NSLocalizedString(@"No", @"No")
										   otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
	[_alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) { // user pressed YES
		[self.cellDelegate buyProduct:self.rowNumber type:self.productType];
	}
}

- (void)setEnabled:(BOOL)enabled
{
	_enabled = enabled;
}


@end
