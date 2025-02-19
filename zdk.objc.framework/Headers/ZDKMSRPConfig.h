//
// ZDKMSRPConfig.h
// ZDK
//

#ifndef ZDKMSRPConfig_h
#define ZDKMSRPConfig_h

#import <Foundation/Foundation.h>
#import "ZDKMSRPConfig.h"
#import "ZDKZHandle.h"
#import "ZDKMSRPConfig.h"
@protocol ZDKMSRPConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief MSRP (Message Session Relay Protocol) specific account configuration
*/
@protocol ZDKMSRPConfig <ZDKZHandle>

/** \brief Sets the use of MSRP functionality as described in RFC 4975
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enableMSRP;

/** \brief Configures the use of MSRP chat functionality for the user
*
*  MSRP chat is done through the messaging class and API - ZDKMessage and sendMessage()
*
*  All messages are sent over SIP SIMPLE while an MSRP session is not active. The ZDK will attempt to establish the
*  session automatically but will also use a graylist in case the remote end does not support MSRP.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*
*  \see ZDKMessage, sendMessage()
*/
@property(nonatomic) BOOL  enableMSRPChat;

/** \brief Configures file transfer feature for the user
*
*  The default is "disabled".
*
*  If the file transfer functionality is not enabled for a user all incoming file transfer will be automatically
*  rejected. initiateTransfer() will return -1 (L_FAIL) immediately and onFileTransferRequest() will never arrive.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*
*  \see onFileTransferRequest(), initiateTransfer()
*/
@property(nonatomic) BOOL  enableMSRPFileTransfer;

/** \brief Configures the use of MSRP relay functionality as described in RFC 4976
*
*  Routes all MSRP requests through the MSRP relay configured with msrpRelayURL().
*
*  MSRP relays are almost always needed for MSRP to work for clients behind NATs.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*
*  \see msrpRelayURL()
*/
@property(nonatomic) BOOL  useMSRPRelay;

/** \brief Configures the MSRP relay URI
*
*  The use of MSRP relay must be enabled through useMSRPRelay().
*
*  Configures the MSRP relay URI to use for MSRP sessions done with the same user and on behalf of contacts linked
*  to the same user.
*
*  The URI can be partial (just a hostname or an IP address), can contain a port (host:port or ip:port) and can be
*  a full msrp or msrps URI (msrps:
*
*  Certain other configuration parameters may override the URI parameters.
*
*  \param[in] value  MSRP relay URI
*
*  \see useMSRPRelay(), msrpRelayUserName(), msrpRelayPassword()
*/
@property(nonatomic) NSString*  _Nullable msrpRelayURL;

/** \brief Configures MSRP relay authentication username for the user
*
*  Configures the authentication username to be used when authenticating to a MSRP relay. It overrides the default
*  which is to use the SIP authentication username if available, or the SIP username itself as a last resort.
*
*  The username is treated as nul-terminated string, UTF-8 (due to the fact that it is sent in the MSRP header).
*
*  \param[in] value  The MSRP relay authentication username
*
*  \see msrpRelayURL(), msrpRelayPassword()
*/
@property(nonatomic) NSString*  _Nullable msrpRelayUserName;

/** \brief Configures MSRP relay password for the user
*
*  Configures the password to be used when authenticating to a MSRP relay.
*
*  Unlike the MSRP authentication username the password has NO fallback. Its default is the empty string (a valid
*  password for the authentication algorithm).
*
*  The password is treated as nul-terminated string, disregarding encoding. It does not appear verbatim anywhere
*  and is used as a binary string during hash calculation.
*
*  \param[in] value  The MSRP relay password
*
*  \see msrpRelayURL(), msrpRelayUserName()
*/
@property(nonatomic) NSString*  _Nullable msrpRelayPassword;

/** \brief Configures the main MSRP TCP port
*
*  Configures the main TCP port for MSRP. This port is used to listen on all local interfaces for incoming MSRP connections.
*
*  The default MSRP port is 2855 as described in RFC4975.
*
*  \param[in] value  The MSRP TCP port
*/
@property(nonatomic) int  msrpTcpPort;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  SIP configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKMSRPConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
