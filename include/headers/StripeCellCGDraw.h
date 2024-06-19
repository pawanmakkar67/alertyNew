//
//  StripeCellCGDraw.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripeCell.h"


@interface StripeCellCGDraw : StripeCell
{
}

- (void) drawBackgroundStripe:(CGRect)frame;
- (void) drawOverlayStripe:(CGRect)frame;
- (void) drawBackgroundHighligth:(CGRect)frame;
- (void) drawOverlayHighligth:(CGRect)frame;
- (void) drawSeparator:(CGRect)frame;

@end
