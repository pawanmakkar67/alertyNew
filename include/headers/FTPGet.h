//
//  FTPGet.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_FTP
#import <Foundation/Foundation.h>
#import "FTPMethod.h"


@interface FTPGet : FTPMethod <NSStreamDelegate>
{
	NSInputStream *_networkStream;
	NSOutputStream *_fileStream;
	uint8_t _buffer[kFTPBufferSize];
	size_t _bufferOffset;
	size_t _readSoFar;
}

@property (readwrite,assign) size_t readSoFar;

- (void) get:(NSString*)url file:(NSString*)file username:(NSString*)username password:(NSString*)password;

@end
#endif
