//
//  FTPManager.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_FTP
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractSingleton.h"
#import "FTPMethod.h"
#import "FTPCreate.h"
#import "FTPDelete.h"
#import "FTPGet.h"
#import "FTPList.h"
#import "FTPPut.h"


@interface FTPManager : AbstractSingleton <FTPMethodDelegate>
{
	NSMutableArray *_methods;
	UIAlertView *_lastAlert;
}

+ (FTPManager*) instance;

+ (void) registerMethod:(FTPMethod*)ftpMethod;
+ (void) reset;

+ (NSError*) errorFromStreamError:(CFStreamError)error;

@end
#endif


// 
// Common FTP Error Codes
// 
// ------------------------------------------------------------------------------------------------------------------------------------
// 100 Codes	The requested action is being taken. Expect a reply before proceeding with a new command.
// ------------------------------------------------------------------------------------------------------------------------------------
// 110	Restart marker reply.
// 120	Service ready in (n) minutes.
// 125	Data connection already open, transfer starting.
// 150	File status okay, about to open data connection.
// ------------------------------------------------------------------------------------------------------------------------------------
// 200 Codes	The requested action has been successfully completed.
// ------------------------------------------------------------------------------------------------------------------------------------
// 200	Command okay.
// 202	Command not implemented
// 211	System status, or system help reply.
// 212	Directory status.
// 213	File status.
// 214	Help message.
// 215	NAME system type. (NAME is an official system name from the list in the Assigned Numbers document.)
// 220	Service ready for new user.
// 221	Service closing control connection. (Logged out if appropriate.)
// 225	Data connection open, no transfer in progress.
// 226	Closing data connection. Requested file action successful (file transfer, abort, etc.).
// 227	Entering Passive Mode
// 230	User logged in, proceed.
// 250	Requested file action okay, completed.
// 257	"PATHNAME" created.
// ------------------------------------------------------------------------------------------------------------------------------------
// 300 Codes	The command has been accepted, but the requested action is being held pending receipt of further information.
// ------------------------------------------------------------------------------------------------------------------------------------
// 331	User name okay, need password.
// 332	Need account for login.
// 350	Requested file action pending further information.
// ------------------------------------------------------------------------------------------------------------------------------------
// 400 Codes	The command was not accepted and the requested action did not take place. 
//				The error condition is temporary, however, and the action may be requested again.
// ------------------------------------------------------------------------------------------------------------------------------------
// 421	Service not available, closing control connection. (May be a reply to any command if the service knows it must shut down.)
// 425	Can't open data connection.
// 426	Connection closed, transfer aborted.
// 450	Requested file action not taken. File unavailable (e.g., file busy).
// 451	Requested action aborted, local error in processing.
// 452	Requested action not taken. Insufficient storage space in system.
// ------------------------------------------------------------------------------------------------------------------------------------
// 500 Codes	The command was not accepted and the requested action did not take place.
// ------------------------------------------------------------------------------------------------------------------------------------
// 500	Syntax error, command unrecognized. This may include errors such as command line too long.
// 501	Syntax error in parameters or arguments.
// 502	Command not implemented.
// 503	Bad sequence of commands.
// 504	Command not implemented for that parameter.
// 530	User not logged in.
// 532	Need account for storing files.
// 550	Requested action not taken. File unavailable (e.g., file not found, no access).
// 552	Requested file action aborted, storage allocation exceeded
// 553	Requested action not taken. Illegal file name.
// ------------------------------------------------------------------------------------------------------------------------------------
// 

