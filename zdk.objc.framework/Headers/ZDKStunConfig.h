//
// ZDKStunConfig.h
// ZDK
//

#ifndef ZDKStunConfig_h
#define ZDKStunConfig_h

#import <Foundation/Foundation.h>
#import "ZDKStunConfig.h"
#import "ZDKZHandle.h"
#import "ZDKStunConfig.h"
@protocol ZDKStunConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief STUN specific account configuration
*
*  The STUN server allows clients to find out their public address, the type of NAT they are behind and the Internet
*  side port associated by the NAT with a particular local port. This information is used to set up  communication
*  between the client and the VoIP provider to establish a call. The STUN protocol is defined in RFC 3489.
*
*  STUN servers are usually contacted on UDP port 3478, however the server can hint clients to perform tests on
*  alternate IP and port number too (STUN servers can have multiple IP addresses).
*/
@protocol ZDKStunConfig <ZDKZHandle>

/** \brief Configures the use of STUN functionality as described in RFC 3489
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  stunEnabled;

/** \brief Configures the address of the STUN server
*
*  Configures the address (hostname) of the STUN server.
*
*  \param[in] value  Hostname of the server
*/
@property(nonatomic) NSString*  _Nullable stunServer;

/** \brief Configures the port of the STUN server
*
*  Specifies the port of the STUN server. The default port is 3478.
*
*  \param[in] value  The port of the server
*/
@property(nonatomic) int  stunPort;

/** \brief Configures the refresh period of the STUN server
*
*  Specifies how often to refresh the STUN server. The default is 30 seconds. The refresh can be used to keep the
*  NAT mapping alive.
*
*  \param[in] value  The refresh period in milliseconds (30000 default)
*
*  \see keepAlive()
*/
@property(nonatomic) int  stunRefresh;

/** \brief Configures the use of DNS SRV requests in a STUN server
*
*  Configures the use of DNS SRV requests to find the given STUN server's address. This is disabled by default and must be explicitly set to
*  non-zero for this to work.
*
*  If SRV requests are enabled, the STUN manager will use all results returned from the SRV query, should any actual STUN requests fail.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  useDnsSrvRequests;

/** \brief Configures whether a STUN server on PRIVATE IP address may be used
*
*  Configures whether to allow or not using STUN on PRIVATE address.
*
*  NOTE! It is not consider a failure to have configured or the resolved STUN server to be on PRIVATE address. In such a cases, the STUN is
*  silently disabled (like done behind SYMMETRIC NATs for example).
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  allowOnPrivateAddress;

/** \brief Configures whether a STUN may be used with SIP server on PRIVATE IP address
*
*  Configures whether to allow or not using STUN with SIP server on PRIVATE address.
*
*  NOTE! It is not consider a failure to have configured or the resolved SIP server to be on PRIVATE address. In such a cases, the STUN is
*  silently disabled (like done behind SYMMETRIC NATs for example).
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  allowWithPrivateSipServer;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  STUN configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKStunConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
