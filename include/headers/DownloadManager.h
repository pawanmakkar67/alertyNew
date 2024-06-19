//
//  DownloadManager.h
//  PanoSphere
//
//  Created by Balint Bence on 2/16/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractSingleton.h"
#import "FileDescriptor.h"
#import "MirroredFile.h"
#import "MirroredBundle.h"


@interface DownloadManager : AbstractSingleton <RemoteObjectDelegate>
{
	BOOL _useOnlyFilenameAsKey;
	NSMutableArray *_managedItems;
	NSMutableArray *_currentlyActive;
}

@property (readwrite,assign) BOOL useOnlyFilenameAsKey;

+ (DownloadManager*) instance;

+ (void) reset;
+ (void) cleanup;

+ (void) deleteSpareFiles;
+ (void) fixFileDescriptors;

+ (void) importURL:(NSString*)url userInfo:(id)userInfo;
+ (void) importURLs:(NSArray*)urls;
+ (void) importBundle:(NSArray*)urls name:(NSString*)name userInfo:(id)userInfo;
+ (void) importBundles:(NSArray*)bundles;

+ (void) addDownloadFile:(MirroredFile*)downloadFile;
+ (void) removeDownloadFile:(MirroredFile*)downloadFile;
+ (NSMutableArray*) managedItems;

+ (NSString*) downloadPathFor:(NSString*)url;
+ (NSString*) relativeDownloadPathFor:(NSString*)url;
+ (NSString*) downloadPathForRelativePath:(NSString*)relative;

+ (void) switchToNextStatus:(MirroredFile*)file;

+ (void) downloadNext;
+ (void) stopDownload;
+ (BOOL) isDownloading;

@end


@interface DownloadManager (DownloadManagerLookupHelpers)
+ (MirroredFile*) lookupMirroredFileIn:(NSArray*)mirroredFiles forMaximalDownloadPriorityWithStatus:(FDDownloadStatus)downloadStatus;
+ (MirroredFile*) lookupMirroredFileIn:(NSArray*)mirroredFiles forNextOrderedDownloadWithStatus:(FDDownloadStatus)downloadStatus;
@end
