//
// ZDKOSCallCordinatorEventsHandler.h
// ZDK
//

#ifndef ZDKOSCallCordinatorEventsHandler_h
#define ZDKOSCallCordinatorEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKOSCallCoordinator.h"
#import "ZDKCallMediaChannel.h"
#import "ZDKOSCallRejectionReason.h"
#import "ZDKOriginType.h"
#import "ZDKEventHandle.h"
#import "ZDKOSCallCoordinator.h"
@protocol ZDKOSCallCoordinator;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKOSCallCordinatorEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify upon Accept Call request occurs
*
*  \param[in] coordinator  The cordinator
*  \param[in] acceptedMedia  The type of media ( audio or video )
*
*  \see ZDKOSCallCoordinator, ZDKCallMediaChannel
*
*/
-(void)onAcceptCallRequest:(id<ZDKOSCallCoordinator>)coordinator acceptedMedia:(ZDKCallMediaChannel)acceptedMedia ;
/** \brief Notify upon Call Reject request occurs
*
*  \param[in] coordinator  The cordinator
*  \param[in] rejectionReason  The rejection reason
*
*  \see ZDKOSCallCoordinator, ZDKOSCallRejectionReason
*
*/
-(void)onRejectCallRequest:(id<ZDKOSCallCoordinator>)coordinator rejectionReason:(ZDKOSCallRejectionReason)rejectionReason ;
/** \brief Notify upon Hold Call request occurs
*
*  \param[in] coordinator  The cordinator
*  \param[in] origin  The origin of the request
*
*  \see ZDKOSCallCoordinator, ZDKOriginType
*
*/
-(void)onHoldCallRequest:(id<ZDKOSCallCoordinator>)coordinator origin:(ZDKOriginType)origin ;
/** \brief Notify upon Resume Call request occurs
*
*  \param[in] coordinator  The cordinator
*  \param[in] origin  The origin of the request
*
*  \see ZDKOSCallCoordinator, ZDKOriginType
*
*/
-(void)onResumeCallRequest:(id<ZDKOSCallCoordinator>)coordinator origin:(ZDKOriginType)origin ;
/** \brief Notify upon End Call request occurs
*
*  \param[in] coordinator  The cordinator
*  \param[in] origin  The origin of the request
*
*  \see ZDKOSCallCoordinator, ZDKOriginType
*
*/
-(void)onEndCallRequest:(id<ZDKOSCallCoordinator>)coordinator origin:(ZDKOriginType)origin ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
