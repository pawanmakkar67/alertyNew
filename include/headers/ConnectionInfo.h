//
//  ConnectionInfo.h
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


// connection info
extern NSString *const CIParametersKey;
extern NSString *const CIResourceURLKey;
extern NSString *const CILocalPathKey;
extern NSString *const CIErrorKey;
extern NSString *const CIResponseHeadersKey;
extern NSString *const CIStatusCodeKey;
extern NSString *const CITotalSizeKey;
extern NSString *const CIStartOffsetKey;
extern NSString *const CIReceivedBytesKey;


@interface ConnectionInfo : NSObject
{
	NSMutableDictionary *_descriptor;
}

// shorthand properties
@property (readwrite,retain) NSDictionary *parameters;
@property (readwrite,retain) NSString *resourceURL;
@property (readwrite,retain) NSString *localPath;
@property (readwrite,retain) NSError *error;
@property (readwrite,retain) NSDictionary *responseHeaders;
@property (readwrite,assign) NSInteger statusCode;
@property (readwrite,assign) unsigned long long totalSize;
@property (readwrite,assign) unsigned long long startOffset;
@property (readwrite,assign) unsigned long long receivedSize;
// shorthand getters
@property (readonly,assign) unsigned long long downloadedSize;
@property (readonly,assign) double progress;

+ (ConnectionInfo*) connectionInfo;

- (void) importInfoFrom:(ConnectionInfo*)connectionInfo;

@end
