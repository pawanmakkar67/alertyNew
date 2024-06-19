//
//  EAProtocolBase.h
//
//  Created by Balint Bence on 2/28/13.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_EXTERNAL_ACCESSORY
#import <ExternalAccessory/ExternalAccessory.h>


@interface EAProtocolBase : NSObject <EAAccessoryDelegate,
									  NSStreamDelegate>
{
	NSString *_protocolString;
	BOOL _autoConnect;
	EAAccessory *_accessory;
	EASession *_session;
}

@property (readonly,retain) NSString *protocolString;
@property (readwrite,assign) BOOL autoConnect;
@property (readwrite,retain) EAAccessory *accessory;
@property (readwrite,retain) EASession *session;

// designated initializer
- (id) initWithProtocolString:(NSString*)protocolString autoConnect:(BOOL)autoConnect;
// session handling
- (void) openSessionForProtocol:(NSString*)protocolString;
- (void) close;
- (void) terminate;
// methods to override (NSStreamDelegate)
//- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode

@end
#endif
