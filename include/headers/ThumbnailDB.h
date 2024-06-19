//
//  ThumbnailDB.h
//
//  Created by Bence Balint on 10/14/13.
//  Copyright (c) 2013 viking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractSingleton.h"
#import "FMDatabaseQueue.h"


@interface ThumbnailDB : AbstractSingleton
{
	FMDatabaseQueue *_databaseQueue;
}

+ (ThumbnailDB*) instance;

// public methods

+ (FMDatabaseQueue*) databaseQueue;
+ (BOOL) resetDatabase;
+ (void) closeDatabase;

// 'thumbnails' table

+ (NSNumber*) insertThumbnail:(NSMutableDictionary*)info;										// row descriptor dictionary
+ (NSNumber*) insertThumbnailWithId:(NSNumber*)thumbnailId										// insert thumbnail
					 sizedThumbnail:(UIImage*)sizedThumbnail
						originalUrl:(NSString*)originalUrl
					  containerSize:(CGSize)containerSize
						contentMode:(UIViewContentMode)contentMode
				   snapshotPosition:(NSTimeInterval)snapshotPosition
						  otherInfo:(NSData*)otherInfo;

+ (BOOL) updateThumbnail:(NSMutableDictionary*)info;											// row descriptor dictionary
+ (BOOL) updateThumbnailWithId:(NSNumber*)thumbnailId											// update thumbnail
				sizedThumbnail:(UIImage*)sizedThumbnail
			   originalUrl:(NSString*)originalUrl
			 containerSize:(CGSize)containerSize
			   contentMode:(UIViewContentMode)contentMode
		  snapshotPosition:(NSTimeInterval)snapshotPosition
				 otherInfo:(NSData*)otherInfo;

+ (BOOL) saveThumbnail:(NSMutableDictionary*)info;												// row descriptor dictionary
+ (BOOL) saveThumbnailWithId:(NSNumber**)thumbnailId											// insert / update thumbnail
			  sizedThumbnail:(UIImage*)sizedThumbnail
			 originalUrl:(NSString*)originalUrl
		   containerSize:(CGSize)containerSize
			 contentMode:(UIViewContentMode)contentMode
		snapshotPosition:(NSTimeInterval)snapshotPosition
			   otherInfo:(NSData*)otherInfo;

+ (BOOL) deleteAllThumbnails;
+ (void) deleteOlderThan:(NSDate*)date byLastAccess:(BOOL)lastAccess;
+ (BOOL) deleteThumbnail:(NSMutableDictionary*)info;											// row descriptor dictionary
+ (BOOL) deleteThumbnailWithId:(NSNumber*)thumbnailId;											// delete thumbnail
+ (BOOL) deleteThumbnailWithOriginalUrl:(NSString*)originalUrl									// delete thumbnail
						  containerSize:(CGSize)containerSize
							contentMode:(UIViewContentMode)contentMode
					   snapshotPosition:(NSTimeInterval)snapshotPosition;

+ (NSMutableDictionary*) selectThumbnail:(NSMutableDictionary*)info;							// row descriptor dictionary
+ (NSMutableDictionary*) selectThumbnailWithId:(NSNumber*)thumbnailId;							// select thumbnail
+ (NSMutableDictionary*) selectThumbnailWithOriginalUrl:(NSString*)originalUrl					// select thumbnail
										  containerSize:(CGSize)containerSize
											contentMode:(UIViewContentMode)contentMode
									   snapshotPosition:(NSTimeInterval)snapshotPosition;

+ (UIImage*) thumbnailImage:(NSMutableDictionary*)info;											// row descriptor dictionary
+ (UIImage*) thumbnailImageWithId:(NSNumber*)thumbnailId;										// select thumbnail
+ (UIImage*) thumbnailImageWithOriginalUrl:(NSString*)originalUrl								// select thumbnail
							 containerSize:(CGSize)containerSize
							   contentMode:(UIViewContentMode)contentMode
						  snapshotPosition:(NSTimeInterval)snapshotPosition;

@end
