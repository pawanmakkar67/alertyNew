//
// ZDKVideoSinkEventsHandler.h
// ZDK
//

#ifndef ZDKVideoSinkEventsHandler_h
#define ZDKVideoSinkEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKEventHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKVideoSinkEventsHandler <ZDKEventHandle>

@optional

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
