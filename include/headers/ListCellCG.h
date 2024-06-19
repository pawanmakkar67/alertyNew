//
//  ListCellCG.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCell.h"


@class ListCellCG;

@interface InternalContentListView : UIView
{
	ListCellCG *_owner;
}

@property (readwrite,assign) ListCellCG *owner;

@end


@interface ListCellCG : ListCell
{
	UIView *_cgContentView;
}

- (void) drawContentInRect:(CGRect)rect;

@end
