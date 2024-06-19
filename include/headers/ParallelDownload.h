//
//  ParallelDownload.h
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
#import <UIKit/UIKit.h>
#import "URLFetcher.h"


@class ParallelDownload;

@protocol ParallelDownloadDelegate <NSObject>
@required
- (void) pdSuccess:(ParallelDownload*)download;
- (void) pdFail:(ParallelDownload*)download;
@end


@interface ParallelDownload : NSObject <URLFetcherDelegate> {
	id<ParallelDownloadDelegate> _delegate;
	URLFetcher *_fetcher;
	NSString *_url;
	id _userInfo;
	NSMutableData *_data;
	NSError *_error;
}

+ (id) download:(NSString*)url delegate:(id<ParallelDownloadDelegate>)delegate userInfo:(id)userInfo;
- (void) cancel;
- (NSString*) url;
- (id<ParallelDownloadDelegate>) delegate;
- (id) userInfo;
- (NSError*) downloadError;
- (NSData*) dataResponse;
- (NSString*) stringResponse;
- (UIImage*) imageResponse;

@end


@interface ParallelDownload ()
@property (readwrite,assign) id<ParallelDownloadDelegate> delegate;
@property (readwrite,retain) URLFetcher *fetcher;
@property (readwrite,retain) NSString *url;
@property (readwrite,retain) id userInfo;
@property (readwrite,retain) NSMutableData *data;
@property (readwrite,retain) NSError *error;
- (id) initAndStartDownload:(NSString*)url delegate:(id<ParallelDownloadDelegate>)delegate userInfo:(id)userInfo;
- (void) startDownload;
- (void) cancelButDontRemove;
@end
