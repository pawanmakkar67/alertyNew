//
// ZDKProxyManager.h
// ZDK
//

#ifndef ZDKProxyManager_h
#define ZDKProxyManager_h

#import <Foundation/Foundation.h>
#import "ZDKProxyProtocolType.h"
#import "ZDKProxyModeType.h"
#import "ZDKProxyConfig.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKProxyConfig.h"
@protocol ZDKProxyConfig;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Proxy Manager
*/
@protocol ZDKProxyManager <ZDKZHandle>

/** \brief Creates a new Proxy configuration with the given parameters
*
*  If mode is ZDK::ProxyModeType::Environemnt, the environment/system settings are used and arugments _hostname_ and _port_ are ignored.
*  If mode is ZDK::ProxyModeType::Custom, the provided _hostname_ and _port_ are used.
*
*  If set the _username_ and _password_ will be used to authenticate the proxy (works for both _Envirenment/System_ and _Custom_ proxies)
*
*  \param[in] protocol  The protocol whose settings to configure
*  \param[in] mode  Which settings to set
*  \param[in] hostname  The hostname of the configured proxy
*  \param[in] port  The port of the configured proxy
*  \param[in] username  The username to use when authenticating
*  \param[in] password  The password to use when authenticating
*
*  \return New proxy configuration
*
*  \see ZDKProxyConfig
*/
-(id<ZDKProxyConfig>)createProxyConfig:(ZDKProxyProtocolType)protocol mode:(ZDKProxyModeType)mode hostname:(NSString* _Nullable)hostname port:(unsigned int)port username:(NSString*)username password:(NSString*)password ;
/** \brief Sets the current proxy configuration
*
*  Changes the current proxy configuration to use for specified protocol requests.
*  If mode is ZDK::ProxyModeType::Environemnt, the environment/system settings are used and arugments _hostname_ and _port_ are ignored.
*  If mode is ZDK::ProxyModeType::Custom, the provided _hostname_ and _port_ are used.
*
*  \param[in] value  The configuration to set
*
*  \return Result of the setting
*
*  \see ZDKProxyConfig
*/
-(id<ZDKResult>)setProxyConfig:(id<ZDKProxyConfig>)value ;
/** \brief Gets the current proxy configuration
*
*  Gets the currently configured proxy for given protocol.
*  If mode is ZDK::ProxyModeType::Custom, the function gets the currently selected settings.
*  If mode is ZDK::ProxyModeType::Environemnt, the function gets the environment/system settings.
*
*  NOTE! Proxy authentication credentials (_username_ and _password_) will NOT be retrieved!
*
*  \param[in] protocol  The protocol whose settings to get
*  \param[in] mode  Which settings to get
*
*  \return The currently used proxy configuration if set, or nullptr otherwise.
*
*  \see ZDKProxyConfig
*/
-(id<ZDKProxyConfig>)getProxyConfig:(ZDKProxyProtocolType)protocol mode:(ZDKProxyModeType)mode ;
/** \brief Gets the current proxy configuration for the specified URL
*
*  \param[in] url  The URL to check against
*
*  \return The currently used proxy configuration if set, or nullptr otherwise.
*
*  \see ZDKProxyConfig
*/
-(id<ZDKProxyConfig>)getProxyConfigForURL:(NSString*)url ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
