//
// ZDKCallStatus.h
// ZDK
//

#ifndef ZDKCallStatus_h
#define ZDKCallStatus_h

#import <Foundation/Foundation.h>
#import "ZDKOriginType.h"
#import "ZDKCallLineStatus.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Call's status information
*
*  Show the call's related status information
*
*  \see ZDKCall
*/
@protocol ZDKCallStatus <ZDKZHandle>

/** \brief Gets the call initiator
*
*  Indicates who initiated the call - incoming or outgoing one.
*
*  \return The calls direction
*
*  \see OriginType
*/
@property(nonatomic, readonly) ZDKOriginType  origin;

/** \brief Gets the current state of the call
*
*  \return The call's state
*
*  \see CallLineStatus
*/
@property(nonatomic, readonly) ZDKCallLineStatus  lineStatus;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
