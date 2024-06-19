//
//  ListItem.h
//
//  Created by Bence Balint on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ListItem;

@protocol ListItemDelegate <NSObject>
@optional
- (void) itemUpdateDidSucceed:(ListItem*)item;
- (void) itemUpdateDidFail:(ListItem*)item;
@end


@interface ListItem : NSObject
{
	id<ListItemDelegate> _delegate;
	id _item;
}

@property (readwrite,assign) id<ListItemDelegate> delegate;
@property (readwrite,retain) id item;

+ (id) itemWithDelegate:(id<ListItemDelegate>)delegate item:(id)item;

@end
