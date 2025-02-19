//
// ZDKProxyConfig.h
// ZDK
//

#ifndef ZDKProxyConfig_h
#define ZDKProxyConfig_h

#import <Foundation/Foundation.h>
#import "ZDKProxyProtocolType.h"
#import "ZDKProxyModeType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Proxy configuration
*
*  Configuration for usage of proxy for all outgoing requests over the supported protocols.
*
*  \see ProxyModeType, ProxyProtocolType
*/
@protocol ZDKProxyConfig <ZDKZHandle>

/** \brief The protocol whose the settings belong
*
*  \return The protocol
*
*  \see ProxyProtocolType
*/
@property(nonatomic, readonly) ZDKProxyProtocolType  protocol;

/** \brief The proxy mode whose the settings belong
*
*  \return The proxy mode
*
*  \see ProxyModeType
*/
@property(nonatomic, readonly) ZDKProxyModeType  mode;

/** \brief The proxy hostname
*
*  \return The proxy hostname
*/
@property(nonatomic, readonly) NSString*  _Nullable hostname;

/** \brief The proxy port
*
*  \return The proxy port
*/
@property(nonatomic, readonly) unsigned int  port;

/** \brief The username to use when authenticating
*
*  \return The username to use when authenticating
*/
@property(nonatomic, readonly) NSString*  _Nullable username;

/** \brief The password to use when authenticating
*
*  \return The password to use when authenticating
*/
@property(nonatomic, readonly) NSString*  _Nullable password;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
