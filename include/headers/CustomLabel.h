//
//  CustomLabel.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CustomLabel : UILabel
{
	NSString *_fontName;
}

// customization method
@property (readwrite,retain) NSString *fontName;

@end


@interface CustomLabel ()
- (void) initInternals;
@end
