//
// ZDKActivationResult.h
// ZDK
//

#ifndef ZDKActivationResult_h
#define ZDKActivationResult_h

#import <Foundation/Foundation.h>
#import "ZDKActivationStatus.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Activation process result
*
*  This structior is filled and fired in ZDKContextEventsHandler onContextActivationCompleted() only if the activation
*  process has completed unambiguously. This means that we have reached the server successfully and got a proper
*  result, be it successful or not.
*
*  This means that in case of an error, it is a final error and not a temporary error. No timeouts or other temporary
*  errors will result in filling this structure and reception of onContextActivationCompleted(). Temporary errors will
*  lead to the library retrying gracefully until a unambiguous result is obtained.
*
*  The activation process will retry until it gets a proper response from the server.
*
*  The result from the server can be either "Success" followed by the rest fields filled in or any kind of error and
*  and reason() and all the rest fields being empty.
*
*  \see ZDKContextEventsHandler, onContextActivationCompleted()
*/
@protocol ZDKActivationResult <ZDKZHandle>

/** \brief Activation process status result
*
*  Represents the activation process starus result - "Success" or the type of failure.
*
*  \return The activation process status
*
*  \see ActivationStatus
*/
@property(nonatomic, readonly) ZDKActivationStatus  status;

/** \brief Text representation of the reason for the activation status
*
*  Explains the meaning of the activation status result.
*
*  \return Description of the activation process status result
*
*  \see status()
*/
@property(nonatomic, readonly) NSString*  reason;

/** \brief The certificate returned by the activation server in case of successful activation
*
*  In case of failure it can be either empty string or even null pointer!
*
*  \return The activation certificate
*/
@property(nonatomic, readonly) NSString*  _Nullable certificate;

/** \brief The build type returned by the activation server in case of successful activation
*
*  In case of failure it can be either empty string or even null pointer!
*
*  \return The activation build type
*/
@property(nonatomic, readonly) NSString*  _Nullable build;

/** \brief The HDD serial number associated with this activation returned by the activation server
*
*  In case of failure it can be either empty string or even null pointer!
*
*  \return The HDD serial number
*/
@property(nonatomic, readonly) NSString*  _Nullable hddSerial;

/** \brief The MAC address associated with this activation returned by the activation server
*
*  In case of failure it can be either empty string or even null pointer!
*
*  \return The MAC address
*/
@property(nonatomic, readonly) NSString*  _Nullable mac;

/** \brief The checksum of the ZDK library returned by the activation server
*
*  In case of failure it can be either empty string or even null pointer!
*
*  \return The ZDK's library checksum
*/
@property(nonatomic, readonly) NSString*  _Nullable checksum;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
