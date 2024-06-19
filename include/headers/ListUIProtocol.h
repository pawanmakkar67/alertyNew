//
//  ListViewProtocol.h
//
//  Created by Bence Balint on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ListUIProtocol <NSObject>
@required

@property (readwrite,assign,getter=isEditing) BOOL editing;

- (void) setEditing:(BOOL)editing animated:(BOOL)animated;
- (void) selectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void) deselectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (UITableViewCell *) dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void) reloadData;
- (void) reloadCellsAtIndexPaths:(NSArray *)indexPaths animated:(BOOL)animated;
- (UITableViewCell *) cellAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *) indexPathForCell:(UITableViewCell *)cell;
- (NSIndexPath *) indexPathForSelectedCell;

@end
