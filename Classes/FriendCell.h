//
//  FriendCell.h
//  Alerty
//
//  Created by Monion 3/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendCellDelegate;
@class Contact;
@interface FriendCell : UITableViewCell {
}

@property (weak, readwrite) id<FriendCellDelegate> cellDelegate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *phoneIcon;
@property (nonatomic) BOOL deletable;
@property (nonatomic) long rowNumber;
@property (nonatomic) long sectionNumber;
@property (nonatomic, assign) BOOL canInteract;
@property (nonatomic, assign) BOOL callEnabled;
@property (nonatomic, weak) id<FriendCellDelegate> delegate;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setCellImage:(NSString *)imageName;

@property (nonatomic, strong) Contact* contact;

@end

@protocol FriendCellDelegate <NSObject>
@required
- (void) addFriend:(FriendCell*)cell;
@optional
- (void) showFriend:(Contact*)contact;

@end

