//
//  WifiApCell.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WifiApCellDelegate;

@interface WifiApCell : UITableViewCell {
	id<WifiApCellDelegate> __weak _cellDelegate;
    NSString *_title;
	NSString *_subtitle;
    NSString *_creditNr;	
	UILabel *_titleLabel;
	UILabel *_subtitleLabel;
	UILabel *_creditLabel;
	UIImageView *_image;
	UIButton *_deleteButton;
	BOOL _deletable;
	BOOL _canInteract;
	int _rowNumber;
}

@property (weak, readwrite) id<WifiApCellDelegate> cellDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) NSString *creditNr;
@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic) BOOL deletable;
@property (nonatomic) int rowNumber;
@property (nonatomic, assign) BOOL canInteract;

- (void)setCellImage:(NSString *)imageName;

@end

@protocol WifiApCellDelegate

@required
- (void) deleteWifiAp:(int)rowNumber;
- (void) addWifiAp;

@end

