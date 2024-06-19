//
//  StripeCell.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ListBase;

@interface StripeCell : UITableViewCell
{
	ListBase *_owner;
	BOOL _odd;
	BOOL _unselectableForCGDrawing;
//	BOOL _shouldSelectByTouch;
}

@property (readwrite,assign) ListBase *owner;
@property (readwrite,assign,getter=isOdd) BOOL odd;
@property (readwrite,assign,getter=isUnselectableForCGDrawing) BOOL unselectableForCGDrawing;
//@property (readwrite,assign) BOOL shouldSelectByTouch;

+ (CGFloat) defaultWidth;
+ (CGFloat) defaultHeight;

@end
