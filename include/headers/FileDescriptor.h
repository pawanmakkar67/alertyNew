//
//  FileDescriptor.h
//
//  Created by Bence Balint on 10/03/13.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWCall.h"


@class FileDescriptor;

@protocol FileDescriptorOwner <NSObject>
@optional
- (void) fileDescriptorUpdateServerInfo:(FileDescriptor*)fileDescriptor;
- (void) fileDescriptorDidFinishServerInfoUpdate:(FileDescriptor*)fileDescriptor withError:(NSError*)error;
- (BOOL) fileDescriptorIsMirroredFileDownloading:(FileDescriptor*)fileDescriptor;
@end


typedef enum {
	DSNotInitiated,
	DSWaiting,
	DSDownloading,
	DSCompleted,
	DSPaused,
	DSFailed
} FDDownloadStatus;


extern NSString *const FDDownloadStatusKey;
extern NSString *const FDLastDownloadStatusKey;
extern NSString *const FDOriginalUrlKey;
extern NSString *const FDFilePathKey;
extern NSString *const FDTotalSizeKey;
extern NSString *const FDDownloadedSizeKey;
extern NSString *const FDDownloadPriorityKey;
extern NSString *const FDDownloadOrderKey;
extern NSString *const FDFetchingInfoKey;


@interface FileDescriptor : NSObject <GWCallDelegate>
{
	id<FileDescriptorOwner> _fileDescriptorOwner;
	NSMutableDictionary *_descriptor;
}

@property (readwrite,assign) id<FileDescriptorOwner> fileDescriptorOwner;
// shorthand properties
@property (readwrite,assign) FDDownloadStatus downloadStatus;
@property (readwrite,assign) FDDownloadStatus lastDownloadStatus;
@property (readwrite,retain) NSString *originalUrl;
@property (readwrite,retain) NSString *filePath;
@property (readwrite,assign) unsigned long long totalSize;
@property (readwrite,assign) unsigned long long downloadedSize;
@property (readwrite,assign) double downloadPriority;
@property (readwrite,assign) NSInteger downloadOrder;
@property (readwrite,assign,getter=isFetchingInfo) BOOL fetchingInfo;

+ (FileDescriptor*) fileDescriptorWithOwner:(id<FileDescriptorOwner>)owner;
+ (FileDescriptor*) fileDescriptorWithURL:(NSString*)url path:(NSString*)path owner:(id<FileDescriptorOwner>)owner;
+ (FileDescriptor*) fileDescriptorWithContentsOfFile:(NSString*)path owner:(id<FileDescriptorOwner>)owner;

- (BOOL) isCompleted;
- (double) progress;
- (BOOL) isEqualToFileDescriptor:(FileDescriptor*)fileDescriptor;
- (NSUInteger) count;
- (void) restoreLastDownloadStatus;
- (void) saveToFileAtPath:(NSString*)path;

- (BOOL) needRefreshServerInfo;

- (void) switchToNextStatus;
- (void) fixFileDescriptor;

+ (NSString*) fileDescriptorExtension;
+ (NSString*) fileDescriptorPath:(NSString*)file;
// mothods to override
- (void) loadFileDescriptor;
- (void) loadFileDescriptor:(NSString*)path;
- (void) saveFileDescriptor;
- (void) removeFileDescriptor;
- (void) reloadFileDescriptor;
- (void) refreshFileDescriptor;

@end


@interface FileDescriptor ()
@property (readwrite,retain) NSMutableDictionary *descriptor;
@end
