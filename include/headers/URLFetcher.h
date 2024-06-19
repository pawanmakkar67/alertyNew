//
//  URLFetcher.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "URLConnectionBase.h"


@class URLFetcher;

@protocol URLFetcherDelegate <NSObject>
@required
- (void) urlFetcherDidSucceed:(URLFetcher*)uf;
- (void) urlFetcherDidFail:(URLFetcher*)uf error:(NSError*)error;
@optional
- (void) urlFetcherDidStart:(URLFetcher*)uf;
- (void) urlFetcherProgress:(URLFetcher*)uf progress:(double)progress;
@end


@interface URLFetcher : URLConnectionBase
{
	id<URLFetcherDelegate> _delegate;
	NSMutableData *_response;
	unsigned long long _lastProgressCall;
}

@property (readwrite,assign) id<URLFetcherDelegate> delegate;		// weak reference
@property (readwrite,retain) NSMutableData *response;

// shorthand methods
+ (URLFetcher*) fetch:(id<URLFetcherDelegate>)delegate
				  url:(NSString*)url
			urlMethod:(URLMethod)urlMethod
			getParams:(NSDictionary*)getParams						// for URLPostNoPost
		   postParams:(NSDictionary*)postParams						// for URLPostURLEncode
		   formParams:(NSArray*)formParams							// for URLPostFormData
			documents:(NSArray*)documents							// for URLPostFormData
			filenames:(NSArray*)filenames							// for URLPostFormData
		 rawPostParam:(NSData*)rawPostParam							// for URLMethodRawPOST
		 headerFields:(NSDictionary*)headerFields					// for external HTTP header fields
	   downloadOffset:(unsigned long long)offset					// offset for file download
			 userInfo:(id)userInfo;
+ (URLFetcher*) head:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get userInfo:(id)userInfo;
+ (URLFetcher*) head:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get headerFields:(NSDictionary*)headerFields userInfo:(id)userInfo;
+ (URLFetcher*) get:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get userInfo:(id)userInfo;
+ (URLFetcher*) get:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get headerFields:(NSDictionary*)headerFields userInfo:(id)userInfo;
+ (URLFetcher*) postURLEncode:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get post:(NSDictionary*)post userInfo:(id)userInfo;
+ (URLFetcher*) postURLEncode:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get post:(NSDictionary*)post headerFields:(NSDictionary*)headerFields userInfo:(id)userInfo;
+ (URLFetcher*) postFormData:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get forms:(NSArray*)forms documents:(NSArray*)documents filenames:(NSArray*)filenames userInfo:(id)userInfo;
+ (URLFetcher*) postFormData:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get forms:(NSArray*)forms documents:(NSArray*)documents filenames:(NSArray*)filenames headerFields:(NSDictionary*)headerFields userInfo:(id)userInfo;
+ (URLFetcher*) postRaw:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get post:(NSData*)post userInfo:(id)userInfo;
+ (URLFetcher*) postRaw:(id<URLFetcherDelegate>)delegate url:(NSString*)url get:(NSDictionary*)get post:(NSData*)post headerFields:(NSDictionary*)headerFields userInfo:(id)userInfo;

@end
