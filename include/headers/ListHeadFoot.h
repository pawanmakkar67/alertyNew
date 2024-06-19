//
//  ListHeadFoot.h
//  SectionedListTest
//
//  Created by Balint Bence on 3/28/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListHeadFoot : UIView
{
	id _item;
}

@property (readwrite,retain) id item;

+ (CGFloat) defaultHeight;

@end
