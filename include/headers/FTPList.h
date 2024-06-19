//
//  FTPList.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_FTP
#import <Foundation/Foundation.h>
#import "FTPMethod.h"


@interface FTPList : FTPMethod <NSStreamDelegate>
{
	NSInputStream *_networkStream;
	NSMutableData *_listData;
	NSMutableArray *_listEntries;		// dictionaries as returned by CFFTPCreateParsedResourceListing
	uint8_t _buffer[kFTPBufferSize];
}

- (void) list:(NSString*)url username:(NSString*)username password:(NSString*)password;
- (NSArray*) list;

@end
#endif
