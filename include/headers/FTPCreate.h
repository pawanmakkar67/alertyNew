//
//  FTPCreate.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_FTP
#import <Foundation/Foundation.h>
#import "FTPMethod.h"


@interface FTPCreate : FTPMethod <NSStreamDelegate>
{
	NSOutputStream *_networkStream;
}

- (void) create:(NSString*)url username:(NSString*)username password:(NSString*)password;

@end
#endif
