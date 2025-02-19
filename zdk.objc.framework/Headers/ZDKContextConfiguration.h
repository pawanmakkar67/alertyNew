//
// ZDKContextConfiguration.h
// ZDK
//

#ifndef ZDKContextConfiguration_h
#define ZDKContextConfiguration_h

#import <Foundation/Foundation.h>
#import "ZDKIpVersionType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief General ZDK/Context configuration
*
*  The configuration is applied with startContext()! Any changes after startContext() has been invoked will not take
*  effect until a restart happens - stopContext() followed by startContext().
*/
@protocol ZDKContextConfiguration <ZDKZHandle>

/** \brief Sets the requested SIP UDP port to be used
*
*  In case the requested port was already taken the next available one will be opened. Default is 5060.
*
*  Use the value of 0 to use an OS-assigned random port.
*
*  \param[in] value  The requested local UDP port for SIP UDP to be used, or 0 for random port to be used
*
*  \see sipUdpPortInUse(), sipTcpPort(), sipTcpPortInUse(), sipTlsPort(), sipTlsPortInUse()
*/
@property(nonatomic) int  sipUdpPort;

/** \brief Gets the actually used SIP UDP port
*
*  In case the requested port was already taken the next available one will be opened. Default is the sipUdpPort.
*  !!! Works ONLY AFTER startContext() !!!
*
*  \return The local UDP port for SIP UDP. "-1" in case of not initialized or error!
*
*  \see sipUdpPort(), sipTcpPort(), sipTcpPortInUse(), sipTlsPort(), sipTlsPortInUse()
*/
@property(nonatomic, readonly) int  sipUdpPortInUse;

/** \brief Sets the requested SIP TCP port to be used
*
*  In case the requested port was already taken the next available one will be opened.
*
*  Use the value of -1 to try to open the same as UDP (default).
*  Use the value of 0 to use an OS-assigned random port.
*
*  \param[in] value  The requested local TCP port for SIP TCP to be used
*
*  \see sipUdpPort(), sipUdpPortInUse(), sipTcpPortInUse(), sipTlsPort(), sipTlsPortInUse()
*/
@property(nonatomic) int  sipTcpPort;

/** \brief Gets the actually used SIP TCP port
*
*  In case the requested port was already taken the next available one will be opened. Default is the sipUdpPort.
*  !!! Works ONLY AFTER startContext() !!!
*
*  \return The local TCP port for SIP TCP. "-1" in case of not initialized or error!
*
*  \see sipUdpPort(), sipUdpPortInUse(), sipTcpPort(), sipTlsPort(), sipTlsPortInUse()
*/
@property(nonatomic, readonly) int  sipTcpPortInUse;

/** \brief Sets the requested SIP TCP port to be used
*
*  In case the requested port was already taken the next available one will be opened.
*
*  Use the value of -1 to try to open the next available port after the TCP one (sipTcpPort+1) (default).
*  Use the value of 0 to use an OS-assigned random port.
*
*  \param[in] value  The requested local TCP port for SIP TLS to be used (not a mistake, TLS run on top of TCP)
*
*  \see sipUdpPort(), sipUdpPortInUse(), sipTcpPort(), sipTcpPortInUse(), sipTlsPortInUse()
*/
@property(nonatomic) int  sipTlsPort;

/** \brief Gets the actually used SIP TLS port
*
*  In case the requested port was already taken the next available one will be opened. Default is the sipTcpPort+1.
*  !!! Works ONLY AFTER startContext() !!!
*
*  \return The local TCP port for SIP TLS (not a mistake, TLS run on top of TCP). "-1" in case of not initialized or error!
*
*  \see sipUdpPort(), sipUdpPortInUse(), sipTcpPort(), sipTcpPortInUse(), sipTlsPort()
*/
@property(nonatomic, readonly) int  sipTlsPortInUse;

/** \brief Gets the actually used IAX UDP port
*
*  In case the requested port was already taken the next available one will be opened.
*  !!! Works ONLY AFTER zdkContext::AddProtocol() !!!
*
*  \return The local UDP port for IAX. "-1" in case of not initialized or error!
*/
@property(nonatomic, readonly) int  iaxUdpPortInUse;

/** \brief Sets the base port to be used for RTP streams
*
*  Set the base UDP port to use for RTP streams. Default is 8000.
*
*  Each call uses two UDP ports, one for the actual audio stream and another one for the control (RTCP) packets.
*
*  A free port will be searched for from that base upwards for each call. When the call is finished the port will be reused in the future.
*
*  Use the value of 0 to use an OS-assigned random port.
*
*  \param[in] value  The RTP port base, or 0 for random port to be used
*/
@property(nonatomic) int  rtpPort;

/** \brief Sets the global use of ZDKPv6 support
*
*  Globally enable ZDKPv6 support. Once enabled all networking will still try to go through ZDKPv4 first, if possible,
*  before trying ZDKPv6. The ZDKPv6 will be used as a backup in case ZDKPv4 is either not available or inaccessible.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enableIPv6;

/** \brief Selects the preferred IP version
*
*  Selects which IP version to prefer when resolving DNS.
*
*  If ZDKPv6 is selected, but not available/enabled, will fallback to the default "Automatic".
*
*  \param[in] value  The desired preference
*
*  \see IpVersionType
*/
@property(nonatomic) ZDKIpVersionType  ipVersionPreference;

/** \brief Generate a random UUID to be used for SIP user instance
*
*  Generates a valid RFC 4122 (RFC 2141) UUID URN that can be used for RFC 5626 (SIP Outbound).
*
*  The result is a string in the format "urn:uuid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx". The prefix is there for
*  easier use of sipInstance().
*
*  \return Generated UUID URN
*
*  \see sipInstance()
*/
@property(nonatomic, readonly) NSString*  _Nullable userSipInstance;

/** \brief Sets the global usage of reliable provisional as described in RFC 3262
*
*  The reliability mechanism works by mirroring the current reliability mechanisms for 2xx final responses to
*  ZDKNVITE. The PRACK request plays the same role as ACK, but for provisional responses. There is an important
*  difference, however. PRACK is a normal SIP message, like BYE.  As such, its own reliability is ensured
*  hop-by-hop through each stateful proxy. Also like BYE, but unlike ACK, PRACK has its own response.
*
*  Extending the Session Initiation Protocol (SIP) - RFC 3262.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enableSIPReliableProvisioning;

/** \brief Sets the ZDK's user agent
*
*  Used in SIP messages mainly. (User-Agent header field).
*
*  \param[in] value UTF-8 encoded user agent
*/
@property(nonatomic) NSString*  _Nullable userAgent;

/** \brief Configures the DSCP for the media streams
*
*  This will affect the RTP, SRTP and ZDKAX2 sockets. Might require administrative privileges.
*
*  \param[in] value  The DiffServ Code Point
*
*  \see signalDSCP()
*/
@property(nonatomic) int  mediaDSCP;

/** \brief Configures the DSCP for the signaling streams
*
*  This will affect the SIP sockets (UDP, TCP and TLS).
*
*  \param[in] value  The DiffServ Code Point
*
*  \see mediaDSCP()
*/
@property(nonatomic) int  signalDSCP;

/** \brief Configures the RTP session name for the SDP
*
*  Sets the RTP session name for the SDP offers/answers. The name should not contain spaces.
*
*  \param[in] value RTP session name
*
*  \see rtpPort(), rtpUsername(), rtpUrl(), rtpEmail()
*/
@property(nonatomic) NSString*  _Nullable rtpSessionName;

/** \brief Configures the RTP user name for the SDP
*
*  Sets the RTP user name for the SDP offers/answers. The user name should not contain spaces.
*
*  \param[in] value  RTP user name
*
*  \see rtpPort(), rtpSessionName(), rtpUrl(), rtpEmail()
*/
@property(nonatomic) NSString*  _Nullable rtpUsername;

/** \brief Configures the URL for SDP
*
*  Sets the URL for the SDP offers/answers. This is optional.
*
*  \param[in] value  The URL
*
*  \see rtpPort(), rtpSessionName(), rtpUsername(), rtpEmail()
*/
@property(nonatomic) NSString*  _Nullable rtpUrl;

/** \brief Configures the e-mail address for SDP
*
*  Sets the email address to put in SDP offers/answers. This is optional.
*
*  \param[in] value  The e-mail address
*
*  \see rtpPort(), rtpSessionName(), rtpUsername(), rtpUrl()
*/
@property(nonatomic) NSString*  _Nullable rtpEmail;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
