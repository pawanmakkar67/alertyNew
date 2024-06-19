//
//  ThumbnailCache.h
//
//  Created by Bence Balint on 2010.12.29..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define THUMBNAIL_CACHE_USE_SQLITE_DB				0
#define THUMBNAIL_CACHE_USE_SQLITE_STORE			1

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if THUMBNAIL_CACHE_USE_SQLITE_DB
#import "AbstractSingleton.h"
#elif THUMBNAIL_CACHE_USE_SQLITE_STORE
#import "ThumbnailStore.h"
#else
#import "MWStores.h"
#endif
#import "NSMutableArrayAdditions.h"
#import "AsyncObjects.h"


typedef enum {
	TCTypeImage,
	TCTypeVideo,
	TCTypeAudio,
	TCTypeUnknown
} TCThumbnailType;


@protocol ThumbnailCacheDelegate <NSObject>
@optional
- (void) thumbnailCacheReady:(NSDictionary*)info;
- (void) thumbnailCacheFailure:(NSDictionary*)info;
@end


#if THUMBNAIL_CACHE_USE_SQLITE_DB
@interface ThumbnailCache : AbstractSingleton <RemoteObjectDelegate>
#elif THUMBNAIL_CACHE_USE_SQLITE_STORE
@interface ThumbnailCache : ThumbnailStore <RemoteObjectDelegate>
#else
@interface ThumbnailCache : MWImageStore <RemoteObjectDelegate>
#endif
{
	NSMutableArray *_delegatePointers;
	NSMutableDictionary *_keyInfos;
	
#if !(THUMBNAIL_CACHE_USE_SQLITE_STORE || THUMBNAIL_CACHE_USE_SQLITE_DB)
	BOOL _useOnlyFilenameAsKey;								// use the whole path or just the filename as store-key
#endif
	UIImage *defaultImageForImage;
	UIImage *defaultImageForVideo;
	UIImage *defaultImageForAudio;
	UIImage *defaultImageForUnknown;
	UIImage *overlayImageForImage;
	UIImage *overlayImageForVideo;
	UIImage *overlayImageForAudio;
	UIImage *overlayImageForUnknown;
	
	NSMutableArray *_asyncObjects;
}

#if !(THUMBNAIL_CACHE_USE_SQLITE_STORE || THUMBNAIL_CACHE_USE_SQLITE_DB)
@property (readwrite,assign) BOOL useOnlyFilenameAsKey;
#endif
@property (readwrite,retain) UIImage *defaultImageForImage;
@property (readwrite,retain) UIImage *defaultImageForVideo;
@property (readwrite,retain) UIImage *defaultImageForAudio;
@property (readwrite,retain) UIImage *defaultImageForUnknown;
@property (readwrite,retain) UIImage *overlayImageForImage;
@property (readwrite,retain) UIImage *overlayImageForVideo;
@property (readwrite,retain) UIImage *overlayImageForAudio;
@property (readwrite,retain) UIImage *overlayImageForUnknown;

+ (TCThumbnailType) typeOf:(NSString*)fileName;				// may be called on Background Thread
+ (BOOL) canCreateThumbnailOf:(NSString*)fileName;			// called on Main Thread
+ (UIImage*) defaultImageOf:(NSString*)fileName;			// called on Main Thread
+ (UIImage*) overlayImageOf:(NSString*)fileName;			// primarily called on Background Thread
+ (UIImage*) makeThumbnailImageOf:(NSString*)filePath containerSize:(CGSize)containerSize contentMode:(UIViewContentMode)contentMode snapshotPosition:(NSTimeInterval)snapshotPosition;		// primarily called on Background Thread
+ (UIImage*) makeThumbnailOf:(UIImage*)loadedImage containerSize:(CGSize)containerSize contentMode:(UIViewContentMode)contentMode;															// primarily called on Background Thread

+ (UIImage*) thumbnailOf:(NSString*)filePath containerSize:(CGSize)containerSize contentMode:(UIViewContentMode)contentMode snapshotPosition:(NSTimeInterval)snapshotPosition;
+ (UIImage*) asyncThumbnailOf:(NSString*)url delegate:(id<ThumbnailCacheDelegate>)delegate containerSize:(CGSize)containerSize contentMode:(UIViewContentMode)contentMode snapshotPosition:(NSTimeInterval)snapshotPosition;
+ (void) removeThumbnailOf:(NSString*)url containerSize:(CGSize)containerSize contentMode:(UIViewContentMode)contentMode snapshotPosition:(NSTimeInterval)snapshotPosition;
+ (void) removeAllThumbnails;
+ (void) removeUnusedThumbnails:(NSDate*)date;
+ (void) removeDelegate:(id<ThumbnailCacheDelegate>)delegate;

@end
