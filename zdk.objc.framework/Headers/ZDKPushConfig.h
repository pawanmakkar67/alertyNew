//
// ZDKPushConfig.h
// ZDK
//

#ifndef ZDKPushConfig_h
#define ZDKPushConfig_h

#import <Foundation/Foundation.h>
#import "ZDKTransportType.h"
#import "ZDKPushConfig.h"
#import "ZDKZHandle.h"
#import "ZDKPushConfig.h"
@protocol ZDKPushConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief Push notification specific configuration
*
*  Mobile platforms only (Android and iOS)!
*/
@protocol ZDKPushConfig <ZDKZHandle>

/** \brief Sets the use of push notifications
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enabled;

/** \brief Sets the use of the push notifications proxy also acting as media proxy
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  rtpMediaProxy;

/** \brief Selects the transport to be used to reach the push proxy
*
*  \param[in] value  The transport to be used
*
*  \see TransportType
*/
@property(nonatomic) ZDKTransportType  transport;

/** \brief Sets the URI part of the "pn-uri" parameter used for registering a device at the Push Proxy
*
*  \param[in] value The URI part of the "pn-uri" parameter
*/
@property(nonatomic) NSString*  _Nullable uri;

/** \brief Sets the Push Device TOKEN part of the "pn-uri" parameter used for registering a device at the Push Proxy
*
*  \param[in] value  The Push Device TOKEN part of the "pn-uri" parameter
*/
@property(nonatomic) NSString*  _Nullable token;

/** \brief Sets the Push TYPE ("pn-type" parameter) used for registering a device at the Push Proxy
*
*  \param[in] value  The Push Type ("pn-type" parameter)
*/
@property(nonatomic) NSString*  _Nullable type;

/** \brief Sets the Push ID ("pn-cid" parameter) used for registering a device at the Push Proxy
*
*  \param[in] value  The Push ID ("pn-cid" parameter)
*/
@property(nonatomic) NSString*  _Nullable cid;

/** \brief Sets the Push Proxy address all SIP messages go through
*
*  The Push Proxy is used as SIP Outbound Proxy.
*
*  \param[in] value  The Push Proxy
*/
@property(nonatomic) NSString*  _Nullable proxy;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  Push configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKPushConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
