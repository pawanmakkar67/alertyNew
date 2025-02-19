//
// ZDKAccountEventsHandler.h
// ZDK
//

#ifndef ZDKAccountEventsHandler_h
#define ZDKAccountEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKAccount.h"
#import "ZDKAccountStatus.h"
#import "ZDKCall.h"
#import "ZDKExtendedError.h"
#import "ZDKOwnershipChange.h"
#import "ZDKHeaderField.h"
#import "ZDKNetworkType.h"
#import "ZDKEventHandle.h"
#import "ZDKAccount.h"
@protocol ZDKAccount;
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKExtendedError.h"
@protocol ZDKExtendedError;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKAccountEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify upon Account status is changed
*
*  Notify upon Account status is changed, provide which account and the status it is changed to.
*
*  \param[in] account  The account which status is changed
*  \param[in] status  What status the account is changed to
*  \param[in] statusCode  The status representation as integer
*
*  \see ZDKAccount, ZDKAccountStatus
*/
-(void)onAccount:(id<ZDKAccount>)account status:(ZDKAccountStatus)status changed:(int)statusCode ;
/** \brief Notify upon Account is retrying registration
*
*  Registration or unregistration is going to be retried automatically
*
*  \param[in] account  Account object of the account which registration is retrying
*  \param[in] isRetrying  Gives information if the event is register or unregister 1 = registering, 0 = unregistering
*  \param[in] inSeconds The (un)registration will be retried in this many seconds
*             approximately (the event could have been in the queue for unknown period already)
*
*  \see ZDKAccount
*/
-(void)onAccount:(id<ZDKAccount>)account retryingRegistration:(int)isRetrying inSeconds:(int)inSeconds ;
/** \brief Notify upon Incoming Call
*
*  Notification for incoming call
*
*  \param[in] account  Account that receives the call
*  \param[in] call  The call object holding handle to the incoming call
*
*  \see ZDKAccount, ZDKCall
*/
-(void)onAccount:(id<ZDKAccount>)account incomingCall:(id<ZDKCall>)call ;
/** \brief Notify upon Chat message was received
*
*  Notify upon Chat message was received , provides the sender and the content of the message
*
*  \param[in] account  Account that receives the message
*  \param[in] pPeer  The message sender
*  \param[in] pContent  Contents of the message
*
*  \see ZDKAccount
*/
-(void)onAccount:(id<ZDKAccount>)account chatMessageReceived:(NSString*)pPeer pContent:(NSString*)pContent ;
/** \brief Notify upon account extended error occurs
*
*  Event fired when extended error in account occurs, providing detailed information for the error in the
*  ExtendedError object.
*
*  \param[in] account  Account that received the error
*  \param[in] error  The error object that provides full information regarding the error
*
*  \see ZDKAccount, ZDKExtendedError
*/
-(void)onAccount:(id<ZDKAccount>)account extendedError:(id<ZDKExtendedError>)error ;
/** \brief Warning for missing SIP Outbound support at the server
*
*
*  Happens when there is a SIP account with SIP Outbound enabled but the
*  server rejects the registrations with the error code 439, usually with
*  the text "First Hop Lacks Outbound Support".
*
*  The full error information is passed in the registration error failure
*  as usual. This event is pushed immediately after the registration failure event.
*
*  The library will NOT alter its configuration automatically but if this
*  behavior is desired the API user can just do the needed reconfiguration
*  in this callback and issue a new registerUser() request
*  afterwards for immediate retry.
*
*  \param[in] account  The user which got the registration error
*
*  \see ZDKAccount, ZDKExtendedError
*/
-(void)onAccountuserSipOutboundMissing:(id<ZDKAccount>)account ;
/** \brief Notify upon call ownership changed
*
*  Providing information upon call ownership change.
*
*  The OwnershipChange objects holds the information if the call is Relieved or Acquired.
*
*  \param[in] account  Account whose call ownership is changed
*  \param[in] call  The call which ownership is changed
*  \param[in] action  The type of change that is happend (Relieve, Acquired or NA)
*
*  \see ZDKAccount, ZDKCall, OwnershipChange
*/
-(void)onAccount:(id<ZDKAccount>)account call:(id<ZDKCall>)call ownershipChanged:(ZDKOwnershipChange)action ;
/** \brief SIP header dump for a user registration
*
*  Dumps the header of a SIP message from a SIP registration. This is the header of the 200 response to the REGISTER request.
*
*  Each header field from the SIP header is represented as an entry in \p headerFields.
*
*  Each header field can have one or more values associated with it in the \p Values array.
*
*  The header field \p Name and the \p Values are UTF-8 strings.
*
*  The structure is valid only for the duration of this callback.
*
*  To enable this callback, use zdksipConfig::HeaderDump().
*
*  \param[in] account  The account which got the registration response
*  \param[in] headerFields The header fields array
*
*  \see ZDKHeaderField
*/
-(void)onAccount:(id<ZDKAccount>)account sipHeaderFields:(NSArray*)headerFields ;
/** \brief Notify upon STUN discovered network type
*
*  \param[in] account  The account which status is changed
*  \param[in] networkType  The discovered network type
*
*  \see ZDKAccount, NetworkType
*/
-(void)onStunNetworkDiscovered:(id<ZDKAccount>)account networkType:(ZDKNetworkType)networkType ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
