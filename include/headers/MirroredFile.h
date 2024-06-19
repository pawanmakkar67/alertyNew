//
//  MirroredFile.h
//
//  Created by Bence Balint on 10/03/13.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteObjectBase.h"
#import "FileDescriptor.h"


@interface MirroredFile : RemoteObjectBase <GWCallDelegate,
											FileDescriptorOwner>
{
	FileDescriptor *_fileDescriptor;
	BOOL _shouldUpdateInfoBeforeDownload;
	BOOL _shouldDownloadAfterInfoUpdate;
}

@property (readwrite,retain) FileDescriptor *fileDescriptor;

+ (id) mirrored:(id<RemoteObjectDelegate>)delegate url:(NSString*)url userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;
+ (id) mirrored:(id<RemoteObjectDelegate>)delegate url:(NSString*)url path:(NSString*)path userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;
+ (id) mirrored:(id<RemoteObjectDelegate>)delegate defaultFileDescriptor:(FileDescriptor*)defaultDescriptor userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;

- (void) switchToNextStatus;
- (void) fixFileDescriptor;
- (void) refreshFileDescriptor;

- (BOOL) dependsOnResource:(NSString*)path;

@end


@interface MirroredFile ()
- (void) setDefaultDescriptor:(FileDescriptor*)defaultDescriptor;
- (void) removeDownloadedFile;
@end
