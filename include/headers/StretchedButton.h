//
//  StretchedButton.h
//
//  Created by Bence Balint on 2010.12.07..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StretchedButton : UIButton
{
	BOOL _inited;
}

- (void) adjustImages;

@end


@interface StretchedButton ()
- (void) initInternals;
@end
