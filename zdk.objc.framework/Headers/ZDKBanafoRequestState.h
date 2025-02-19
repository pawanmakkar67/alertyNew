//
// ZDKBanafoRequestState.h
// ZDK
//

#ifndef ZDKBanafoRequestState_h
#define ZDKBanafoRequestState_h

#import <Foundation/Foundation.h>
#import "ZDKBanafoRequestStateType.h"
#import "ZDKUploadProgress.h"
#import "ZDKZHandle.h"
#import "ZDKUploadProgress.h"
@protocol ZDKUploadProgress;

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Request state
*
*  Describes the current full state of the Banafo Service request.
*/
@protocol ZDKBanafoRequestState <ZDKZHandle>

/** \brief The Banafo Service Request state
*
*  Indicates the new state in which the Banafo Service Request has transitioned into.
*
*  \return The new Banafo Service Request state
*
*  \see BanafoRequestStateType
*/
@property(nonatomic, readonly) ZDKBanafoRequestStateType  state;

/** \brief The network status code
*
*  Contains the network state code if the new state is BanafoRequeststateType::NetworkError or
*  BanafoRequeststateType::Finished. If the code is below 100 it is a CURL error code and its value can be checked
*  here https:
*
*  If the code is above 100 it is a HTTP error code.
*
*  \return The network status code
*
*  \see state()
*/
@property(nonatomic, readonly) int  networkStatusCode;

/** \brief HTTP failure reason.
*
*  Contains the HTTP failure reason.
*
*  \return The HTTP failure reason.
*/
@property(nonatomic, readonly) NSString*  _Nullable reason;

/** \brief The response data buffer
*
*  Contains the response data buffer if the state is BanafoRequestStateType::Finished.
*
*  \return The response data buffer
*/
@property(nonatomic, readonly) NSString*  _Nullable response;

/** \brief The upload progress
*
*  Contains the upload progress if the state is BanafoRequeststateType::InProgress.
*
*  \return The upload progress
*
*  \see ZDKUploadProgress, state()
*/
@property(nonatomic, readonly) id<ZDKUploadProgress>  _Nullable progress;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
