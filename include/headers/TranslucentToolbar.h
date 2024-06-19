//
//  TranslucentToolbar.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AlignmentButtonItem : UIBarButtonItem
@end


@interface MarginButtonItem : UIBarButtonItem
@end


@interface SpacingButtonItem : UIBarButtonItem
@end


@interface NormalButtonItem : UIBarButtonItem
@end


@interface TranslucentToolbar : UIToolbar
{
	CGFloat _toolbarHeight;
	BOOL _autoresizeWidth;
}

@property (readwrite,assign) CGFloat toolbarHeight;
@property (readwrite,assign) BOOL autoresizeWidth;

- (void) resizeContent;
- (CGFloat) widthThatFits;
- (void) widthToFit;

@end
