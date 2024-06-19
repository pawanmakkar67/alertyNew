//
//  ProductCell.h
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductCellDelegate;

@interface ProductCell : UITableViewCell {
	id<ProductCellDelegate> __weak _cellDelegate;
    NSString *_title;
	NSString *_buttonTitle;
	UILabel *_titleLabel;
	UILabel *_buttonLabel;
	UIButton *_buyButton;
	BOOL _isProduct;
	long _rowNumber;
	
	int _productType;
	
	BOOL _enabled;
}

@property (weak, readwrite) id<ProductCellDelegate> cellDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *buttonTitle;
@property (nonatomic, strong) UILabel *buttonLabel;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic) BOOL isProduct;
@property (nonatomic) long rowNumber;
@property (nonatomic, assign) int productType;
@property (nonatomic, assign) BOOL enabled;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

@protocol ProductCellDelegate

@required
- (void) buyProduct:(long)rowNumber type:(int)productType;

@end
