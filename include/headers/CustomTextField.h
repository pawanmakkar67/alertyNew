//
//  CustomTextField.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CustomTextField : UITextField
{
	BOOL _disableDefaultActions;
}

@property (readwrite,assign) BOOL disableDefaultActions;

// customization method
@property (readwrite,retain) NSString *fontName;

@end


@interface CustomTextField ()
- (void) initInternals;
@end