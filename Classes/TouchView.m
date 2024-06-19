//
//  TouchView.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

@synthesize delegate = _delegate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([self.delegate respondsToSelector:@selector(didTouchView:)]) {
		[self.delegate didTouchView:self];
	}
}

@end
