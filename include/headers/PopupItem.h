//
//  PopupItem.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PopupItem : UIButton
{
	id _userInfo;
	NSDictionary *_descriptor;
	NSInteger _selected;
	NSArray *_titles;
	NSArray *_icons;
	NSInteger _itemId;
}

@property (nonatomic,retain) IBOutlet UILabel *title;
@property (nonatomic,retain) IBOutlet UIImageView *icon;
@property (nonatomic,retain) id userInfo;
@property (nonatomic,retain) NSDictionary *descriptor;
@property (readwrite,assign) NSInteger selected;
@property (readonly,retain) NSArray *titles;
@property (readonly,retain) NSArray *icons;
@property (readonly,assign) NSInteger itemId;

+ (PopupItem*) popupItemWithDescriptor:(NSDictionary*)descriptor;

- (void) setSelected:(NSInteger)selected animated:(BOOL)animated;
- (void) selectNext:(BOOL)animated;
- (void) selectPrevious:(BOOL)animated;

// methods to override
- (Class) labelClass;

@end
