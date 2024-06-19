//
//  URLShortener.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLShortenerDelegate
- (void) didFailToReceiveURL;
- (void) didReceiveShortURL:(NSString *)shortURL;
@end

@interface URLShortener : NSObject <UIWebViewDelegate> {
	id<URLShortenerDelegate> __weak _delegate;
}

@property (nonatomic, weak) id delegate;

- (id)initWithDelegate:(id<URLShortenerDelegate>)delegate;
- (void) createURL:(NSString *)fromURL withURLShortenerURL:(NSString *)urlShortenerURL;

@end
