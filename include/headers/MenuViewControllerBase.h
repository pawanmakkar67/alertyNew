//
//  MenuViewControllerBase.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerBase.h"
#import "MenuItem.h"
#import "MenuView.h"


@interface MenuViewControllerBase : ViewControllerBase
{
}

@property (nonatomic,retain) IBOutlet MenuView *menuView;

// helper methods
+ (NSArray*) menuWithFile:(NSString*)path;
- (void) refreshMenu;
- (MenuItem*) menuItemByName:(NSString*)name;
- (void) selectMenuItemByName:(NSString*)name;
- (MenuItem*) menuItemAtIndex:(NSInteger)index;
- (MenuItem*) menuItemWithId:(NSInteger)itemId;
// methods to override
- (NSArray*) menuDescriptor;
- (void) didSelectMenuItem:(MenuItem*)menuItem;
- (BOOL) plainMenu;
- (CGFloat) iconDistance;
- (UIEdgeInsets) menuMargin;

@end


@interface MenuViewControllerBase ()
- (void) setupMenu:(NSArray*)menu;
@end
