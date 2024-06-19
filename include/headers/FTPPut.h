//
//  FTPPut.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_FTP
#import <Foundation/Foundation.h>
#import "FTPMethod.h"


@interface FTPPut : FTPMethod <NSStreamDelegate>
{
	NSOutputStream *_networkStream;
	NSInputStream *_fileStream;
	uint8_t _buffer[kFTPBufferSize];
	size_t _bufferOffset;
	size_t _bufferLimit;
	size_t _writtenSoFar;
}

@property (readwrite,assign) size_t writtenSoFar;

- (void) put:(NSString*)file url:(NSString*)url username:(NSString*)username password:(NSString*)password;

@end
#endif
