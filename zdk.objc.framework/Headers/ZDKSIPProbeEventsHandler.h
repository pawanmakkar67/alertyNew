//
// ZDKSIPProbeEventsHandler.h
// ZDK
//

#ifndef ZDKSIPProbeEventsHandler_h
#define ZDKSIPProbeEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKAccount.h"
#import "ZDKProbeState.h"
#import "ZDKExtendedError.h"
#import "ZDKTransportType.h"
#import "ZDKEventHandle.h"
#import "ZDKAccount.h"
@protocol ZDKAccount;
#import "ZDKExtendedError.h"
@protocol ZDKExtendedError;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKSIPProbeEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify if Probe error occurs
*
*  An error occured during user probing. The process might
*  continue with a different protocol.
*
*  \param[in] account  The account
*  \param[in] curState  The state that generated the error.
*  \param[in] error  Code of the error
*
*  \see ZDKAccount, ProbeState, ZDKExtendedError
*/
-(void)onProbeError:(id<ZDKAccount>)account curState:(ZDKProbeState)curState error:(id<ZDKExtendedError>)error ;
/** \brief Notify if Probe change in state occurs
*
*  The probing process has entered another stage
*
*  \param[in] account  The account
*  \param[in] newState  The new state
*
*  \see ZDKAccount, ProbeState
*/
-(void)onProbeState:(id<ZDKAccount>)account newState:(ZDKProbeState)newState ;
/** \brief Notify if Probe was successful
*
*  The probing was successful. The process has ended.
*
*  \param[in] account  The account
*  \param[in] transport  The recommended transport
*
*  \see ZDKAccount, TransportType
*/
-(void)onProbeSuccess:(id<ZDKAccount>)account transport:(ZDKTransportType)transport ;
/** \brief Notify if Probe fails
*
*  The probing process was unsuccesful. The process has ended.
*
*  \param[in] account  The account
*  \param[in] error  The final error code
*
*  \see ZDKAccount, ZDKExtendedError
*/
-(void)onProbeFailed:(id<ZDKAccount>)account error:(id<ZDKExtendedError>)error ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
