//
//  URLShortener.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "URLShortener.h"

@interface URLShortener () {
	NSMutableData	*_responseData;
	NSURLConnection *_createRequestURLConnection;
}

@property (nonatomic, strong) NSMutableData	*responseData;
@property (nonatomic, strong) NSURLConnection *createRequestURLConnection;

@end

@implementation URLShortener

@synthesize delegate = _delegate;
@synthesize responseData = _responseData;
@synthesize createRequestURLConnection = _createRequestURLConnection;


- (id)init {
    self = [super init];
    if (self) {
        self.responseData = [NSMutableData data];
    }
    return self;
}

- (id)initWithDelegate:(id<URLShortenerDelegate>)delegate
{
    self = [super init];
    if (self) {
		self.responseData = [NSMutableData data];
        self.delegate = delegate;
    }
    return self;
}

- (void) createURL:(NSString *)fromURL withURLShortenerURL:(NSString *)urlShortenerURL
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:urlShortenerURL, fromURL]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	self.createRequestURLConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if( connection == self.createRequestURLConnection ) {
		self.createRequestURLConnection = nil;
	}
	
	if( self.delegate && [self.delegate respondsToSelector:@selector(didFailToReceiveURL)] ) {
		[self.delegate didFailToReceiveURL];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSASCIIStringEncoding];
	
	if( connection == self.createRequestURLConnection ) {
		self.createRequestURLConnection = nil;
	}

	if( self.delegate && [self.delegate respondsToSelector:@selector(didReceiveShortURL:)] ) {
		[self.delegate didReceiveShortURL:responseString];
	}
	
}

@end
