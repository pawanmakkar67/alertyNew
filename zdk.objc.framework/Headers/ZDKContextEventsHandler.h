//
// ZDKContextEventsHandler.h
// ZDK
//

#ifndef ZDKContextEventsHandler_h
#define ZDKContextEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKContext.h"
#import "ZDKSecureCertData.h"
#import "ZDKActivationResult.h"
#import "ZDKEventHandle.h"
#import "ZDKContext.h"
@protocol ZDKContext;
#import "ZDKSecureCertData.h"
@protocol ZDKSecureCertData;
#import "ZDKActivationResult.h"
@protocol ZDKActivationResult;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKContextEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify upon Secure certificate status
*
*  Notify upon Secure certificate status when being used (usually on creating a new secure connection)
*
*  \param[in] context  The context in which the error occurs
*  \param[in] secureCert  The certificate data object that holds the status information
*
*  \see ZDKContext, ZDKSecureCertData
*/
-(void)onContext:(id<ZDKContext>)context secureCertstatus:(id<ZDKSecureCertData>)secureCert ;
/** \brief Notify upon user activation occurs
*
*  Notify upon user activation occurs, for the a particular context
*
*  \param[in] context  The context in which the error occurs
*  \param[in] activationResult  The activation object that holds the response information for the activation
*
*  \see ZDKContext, ZDKActivationResult
*
*/
-(void)onContext:(id<ZDKContext>)context activationCompleted:(id<ZDKActivationResult>)activationResult ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
