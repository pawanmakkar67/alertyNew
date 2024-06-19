//
//  MenuItem.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//
// e.g.
//
// ...
// {
//   "name" : "popup_block_route",
//   "id" : "5",
//   "icons" : [
//     "popup_block.png",
//     "popup_unblock.png"
//   ],
//   "titles" : {
//     "en" : [
//       "Block\nroute",
//       "Unblock\nroute"
//     ],
//     "de" : [
//       "Strecke\nsperren",
//       "Strecke\nfreigeben"
//     ]
//   }
// }
// ...
//


@interface MenuItem : UIButton
{
	NSDictionary *_descriptor;
	UILabel *title;
	UIImageView *icon;
	BOOL _plainItem;
	NSInteger _selected;
	NSArray *_titles;
	NSArray *_icons;
	NSInteger _itemId;
}

@property (nonatomic,retain) NSDictionary *descriptor;
@property (nonatomic,assign) BOOL plainItem;
@property (nonatomic,retain) IBOutlet UILabel *title;
@property (nonatomic,retain) IBOutlet UIImageView *icon;
@property (readwrite,assign) NSInteger selected;
@property (readonly,retain) NSArray *titles;
@property (readonly,retain) NSArray *icons;
@property (readonly,assign) NSInteger itemId;

+ (MenuItem*) menuItemWithDescriptor:(NSDictionary*)descriptor target:(id)target action:(SEL)action;
+ (MenuItem*) plainItemWithDescriptor:(NSDictionary*)descriptor target:(id)target action:(SEL)action;
- (void) setupWithDescriptor:(NSDictionary*)descriptor;
- (void) setSelected:(NSInteger)selected animated:(BOOL)animated;
- (void) selectNext:(BOOL)animated;
- (void) selectPrevious:(BOOL)animated;

// methods to override
- (Class) labelClass;

@end
