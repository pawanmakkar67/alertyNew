//
//  MirroredBundle.h
//
//  Created by Bence Balint on 10/03/13.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MirroredFile.h"
#import "FileDescriptor.h"


@interface MirroredBundle : MirroredFile <RemoteObjectDelegate,
										  FileDescriptorOwner>
{
	NSMutableArray *_bundleFiles;
	NSMutableArray *_currentlyActive;
	NSMutableArray *_updatingFiles;
	NSMutableArray *_currentlyUpdating;
	BOOL _forcedUpdate;
}

@property (readwrite,retain) FileDescriptor *fileDescriptor;

+ (id) bundle:(id<RemoteObjectDelegate>)delegate name:(NSString*)name urls:(NSArray*)urls userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;
+ (id) bundle:(id<RemoteObjectDelegate>)delegate name:(NSString*)name defaultFileDescriptors:(NSArray*)defaultDescriptors userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;

- (void) updateServerInfos:(BOOL)forced;

@end
