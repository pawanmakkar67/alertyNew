//
//  ListCell.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripeCell.h"
#import "ListItem.h"


@interface ListCell : StripeCell
{
	ListItem *_item;
}

@property (readwrite,retain) ListItem *item;

@end
