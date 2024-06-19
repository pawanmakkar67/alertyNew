//
//  FTPMethod.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_FTP
#import <Foundation/Foundation.h>


#define kFTPBufferSize			32768


typedef enum {
	FTPStatusNone,
	FTPStatusClosed,
	FTPStatusOpened,
	FTPStatusPutting,
	FTPStatusGetting,
	FTPStatusListing,
	FTPStatusCancelled,
	FTPStatusError
} FTPStatus;


@class FTPMethod;

@protocol FTPMethodDelegate <NSObject>
@optional
- (void) ftpMethodDidSucceed:(FTPMethod*)method;
- (void) ftpMethodDidFail:(FTPMethod*)method;
@end


@interface FTPMethod : NSObject
{
	id<FTPMethodDelegate> _delegate;
	NSString *_username;
	NSString *_password;
	NSString *_file;
	NSString *_resource;
	NSString *_url;
	FTPStatus _status;
	NSError *_error;
}

@property (readwrite,assign) id<FTPMethodDelegate> delegate;
@property (readwrite,retain) NSString *username;
@property (readwrite,retain) NSString *password;
@property (readwrite,retain) NSString *file;
@property (readwrite,retain) NSString *resource;
@property (readwrite,retain) NSString *url;
@property (readwrite,assign) FTPStatus status;
@property (readwrite,retain) NSError *error;

+ (id) create:(NSString*)url username:(NSString*)username password:(NSString*)password delegate:(id<FTPMethodDelegate>)delegate;
+ (id) delete:(NSString*)url username:(NSString*)username password:(NSString*)password delegate:(id<FTPMethodDelegate>)delegate;
+ (id) get:(NSString*)url file:(NSString*)file username:(NSString*)username password:(NSString*)password delegate:(id<FTPMethodDelegate>)delegate;
+ (id) list:(NSString*)url username:(NSString*)username password:(NSString*)password delegate:(id<FTPMethodDelegate>)delegate;
+ (id) put:(NSString*)file url:(NSString*)url username:(NSString*)username password:(NSString*)password delegate:(id<FTPMethodDelegate>)delegate;

- (void) cancel;
- (BOOL) isWorking;

@end


@interface FTPMethod ()
- (void) finished;
- (void) start;
- (void) stop;
@end
#endif
