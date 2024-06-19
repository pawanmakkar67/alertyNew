//
//  IsGdURLShortener.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IsGdURLShortener.h"

@implementation IsGdURLShortener

- (void) createURL:(NSString *)fromURL
{
	NSString* url = [fromURL stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	[super createURL:url withURLShortenerURL:@"http://is.gd/create.php?format=simple&url=%@"];
}

@end
