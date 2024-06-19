//
//  SelectViewController.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerBase.h"


extern NSString *const SVSelectionValueKey;
extern NSString *const SVSelectionDidChangeEvent;
extern NSString *const SVSelectionWillShowNotification;
extern NSString *const SVSelectionWillHideNotification;


@interface SelectViewController : ViewControllerBase <UITableViewDelegate,
													  UITableViewDataSource>
{
	id _userInfo;
	NSArray *_items;
	NSInteger _selected;
}

@property (retain,nonatomic) IBOutlet UITableView *tableView;
@property (readwrite,retain) id userInfo;
@property (readwrite,retain) NSArray *items;
@property (readwrite,assign) NSInteger selected;

+ (id) selectWithItems:(NSArray*)items selected:(NSUInteger)selected nibName:(NSString*)nibName;
- (BOOL) isShown;
- (BOOL) isModal;
- (void) show:(BOOL)show inController:(id)controller animated:(BOOL)animated modal:(BOOL)modal;
// methods to override
- (Class) cellClass:(NSIndexPath*)indexPath;
- (void) configureCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

@end
