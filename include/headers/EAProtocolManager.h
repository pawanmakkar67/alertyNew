//
//  EAProtocolManager.h
//
//  Created by Balint Bence on 2/28/13.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_EXTERNAL_ACCESSORY
#import "AbstractSingleton.h"
#import "EAProtocolBase.h"


@interface EAProtocolManager : AbstractSingleton
{
	NSMutableDictionary *_protocols;
}

+ (EAProtocolManager*) instance;

// reset manager
+ (void) reset;

+ (void) setProtocol:(EAProtocolBase*)protocol;
+ (void) removeProtocolForString:(NSString*)protocolString;

@end
#endif
