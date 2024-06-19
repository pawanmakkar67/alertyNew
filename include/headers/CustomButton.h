//
//  CustomButton.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StretchedButton.h"


@interface CustomButton : StretchedButton
{
}

// customization method
@property (readwrite,retain) NSString *fontName;

@end


@interface CustomButton ()
- (void) initInternals;
@end
