//
//  ListCellCGDraw.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripeCellCGDraw.h"
#import "ListItem.h"


@interface ListCellCGDraw : StripeCellCGDraw
{
	ListItem *_item;
}

@property (readwrite,retain) ListItem *item;

@end
