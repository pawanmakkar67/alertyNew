//
//  TinyURL.h
//  MeinQuartier
//
//  Created by Balint Bence on 5/3/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLFetcher.h"


@class TinyURL;

@protocol TinyURLDelegate <NSObject>
@optional
- (void) tinyURLDidSucceed:(TinyURL*)tinyURL;
- (void) tinyURLDidFail:(TinyURL*)tinyURL;
@end


@interface TinyURL : NSObject <URLFetcherDelegate>
{
	id<TinyURLDelegate> _delegate;
	NSString *_normalUlr;
	NSString *_tinyUlr;
	URLFetcher *_fetcher;
}

@property (readwrite,assign) id<TinyURLDelegate> delegate;
@property (readwrite,retain) NSString *normalUrl;
@property (readwrite,retain) NSString *tinyUrl;

+ (id) getTinyURL:(NSString*)url delegate:(id<TinyURLDelegate>)delegate;

- (void) cancel;
- (BOOL) isLoading;

// methods to override
- (NSString*) serviceUrl;
- (NSDictionary*) serviceParams;

@end
