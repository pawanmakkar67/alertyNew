//
// ZDKOSCallRepresentative.h
// ZDK
//

#ifndef ZDKOSCallRepresentative_h
#define ZDKOSCallRepresentative_h

#import <Foundation/Foundation.h>
#import "ZDKOSCallCordinatorEventsHandler.h"
#import "ZDKZHandle.h"
#import "ZDKOSCallCordinatorEventsHandler.h"
@protocol ZDKOSCallCordinatorEventsHandler;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKOSCallRepresentative <ZDKZHandle>

-(void)notifyCallActive;
-(void)notifyCallHeld;
-(void)notifyCallEnded;
-(void)setOSCallCoordinatorEventListener:(id<ZDKOSCallCordinatorEventsHandler>)value ;
-(void)dropOSCallCoordinatorEventListener:(id<ZDKOSCallCordinatorEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
