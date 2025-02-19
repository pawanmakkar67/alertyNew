//
// ZDKBanafoServiceState.h
// ZDK
//

#ifndef ZDKBanafoServiceState_h
#define ZDKBanafoServiceState_h

#import <Foundation/Foundation.h>
#import "ZDKBanafoServiceStateType.h"
#import "ZDKBanafoServiceErrorType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Service state
*
*  Describes the current full state of the Banafo Service.
*/
@protocol ZDKBanafoServiceState <ZDKZHandle>

/** \brief The Banafo Service state
*
*  Indicates the new state in which the Banafo Service has transitioned into.
*
*  \return The new Banafo Service state
*
*  \see BanafoServiceStateType
*/
@property(nonatomic, readonly) ZDKBanafoServiceStateType  state;

/** \brief The network error code
*
*  Contains the network error code if the new state is BanafoServicestateType::NetworkError.
*  If the code is below 100 it is a CURL error code and its value can be checked here
*  https:
*
*  If the error is above 100 it is a HTTP error code.
*
*  \return The network error code
*
*  \see state()
*/
@property(nonatomic, readonly) int  networkErrorCode;

/** \brief The Banafo Service error
*
*  Contains the Banafo error code if the new state is BanafoServicestateType::Error.
*
*  \return The Banafo Service error code
*
*  \see state()
*/
@property(nonatomic, readonly) ZDKBanafoServiceErrorType  serviceErrorType;

/** \brief HTTP failure reason.
*
*  Contains the HTTP failure reason.
*
*  \return The HTTP failure reason.
*/
@property(nonatomic, readonly) NSString*  _Nullable reason;

/** \brief The new Banafo Service Access Token
*
*  Contains the new access token that is going to be used for requests if the new state is BanafoServicestateType::Authorized.
*
*  \return The new Banafo Service Access Token
*
*  \see state()
*/
@property(nonatomic, readonly) NSString*  _Nullable accessToken;

/** \brief The new Banafo Service Refresh Token
*
*  Contains the new refresh token that is going to be used for requests if the new state is
*  BanafoServicestateType::Authorized. The user may save this token to avoid new authorization upon restart.
*
*  \return The new Banafo Service Refresh Token
*
*  \see state()
*/
@property(nonatomic, readonly) NSString*  _Nullable refreshToken;

/** \brief The user code for Authorizing the Banafo Service verification
*
*  Contains the new user code that has to be displayed to the end user if the new state is
*  BanafoServicestateType::VerifyingAuthorizing.
*
*  \return The user code for Authorizing the Banafo Service verification
*
*  \see state()
*/
@property(nonatomic, readonly) NSString*  _Nullable userCode;

/** \brief The URI for verifying the new device
*
*  Contains the URI where the end user have to visit to be able to verify the new device if
*  the new state is BanafoServicestateType::VerifyingAuthorizing.
*
*  \return The URI for verifying the new device
*
*  \see state()
*/
@property(nonatomic, readonly) NSString*  _Nullable verificationURI;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
