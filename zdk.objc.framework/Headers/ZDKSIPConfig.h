//
// ZDKSIPConfig.h
// ZDK
//

#ifndef ZDKSIPConfig_h
#define ZDKSIPConfig_h

#import <Foundation/Foundation.h>
#import "ZDKTransportType.h"
#import "ZDKRPortType.h"
#import "ZDKRTCPFeedbackType.h"
#import "ZDKStunConfig.h"
#import "ZDKMSRPConfig.h"
#import "ZDKZRTPConfig.h"
#import "ZDKPushConfig.h"
#import "ZDKHeaderField.h"
#import "ZDKRTPCollisionResolutionType.h"
#import "ZDKSessionTimerModeType.h"
#import "ZDKSIPConfig.h"
#import "ZDKZHandle.h"
#import "ZDKStunConfig.h"
@protocol ZDKStunConfig;
#import "ZDKMSRPConfig.h"
@protocol ZDKMSRPConfig;
#import "ZDKZRTPConfig.h"
@protocol ZDKZRTPConfig;
#import "ZDKPushConfig.h"
@protocol ZDKPushConfig;
#import "ZDKSIPConfig.h"
@protocol ZDKSIPConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief SIP specific account configuration
*/
@protocol ZDKSIPConfig <ZDKZHandle>

/** \brief Sets the user domain
*
*  This is the domain part of the address of record. It is a mandatory parameter and is used to construct the
*  account's AoR and also used by the SIP stack to detect server settings (DNS SRV).
*
*  \param[in] value  The user's SIP Domain to be used
*/
@property(nonatomic) NSString*  domain;

/** \brief Configures the use of SIP Outbound as described in RFC 5626
*
*  Enables or disables RFC 5626 for SIP users. The default setting for new SIP user account is "disabled".
*
*  The user MUST also have a configured Outbound Proxy.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  useOutboundProxy;

/** \brief Sets the SIP Outbound Proxy to be used
*
*  The outbound proxy is a normal SIP proxy. You configure your client, the phone or software, to use the proxy for
*  all SIP sessions, just like when you configure your Web browser to use a Web proxy for all Web transactions. In
*  some cases, the outbound proxy is placed alongside the firewall and is the only way to let SIP traffic pass from
*  the internal network to the Internet.
*
*  \param[in] value  The SIP Outbound Proxy to be used
*/
@property(nonatomic) NSString*  _Nullable outboundProxy;

/** \brief Configures RFC2141 URN for SIP registrations
*
*  Configures the SIP instance URN used for SIP outbound (RFC 5626). It MUST be a valid RFC 2141 URN and it SHOULD
*  be a valid RFC 4122 UUID URN in the format "urn:uuid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" where 'x' is a
* hexadecimal number. It can be optionally in angle brackets.
*
*  Other URN schemes can be used. The recommended one is urn:uuid but most servers will treat the string as a
*  sequence of bytes and will not care if the scheme is different.
*
*  Use userSipInstance() to create a random UUID. It will include the scheme prefix (urn:uuid:) and can be used
*  directly in this function. Other ways of generating/obtaining a URN/UUID are allowed but the URN prefix is
*  REQUIRED by the standard.
*
*  Global URN ZDKS applied for all SIP accounts. SIP Outbound MUST still be enabled individually for each account.
*
*  The URN SHOULD be stored locally and re-used after restarts. The API user has the responsibility of using the
*  same URN between restarts.
*
*  \param[in] value  The RFC 2141 URN to be used in RFC 5626 (SIP outbound)
*
*  \see userSipInstance()
*/
@property(nonatomic) NSString*  sipInstance;

/** \brief Selects the SIP transport to be used
*
*  \param[in] value The signalling protocol to select (UDP, TCP, TLS)
*
*  \see TransportType
*/
@property(nonatomic) ZDKTransportType  transport;

/** \brief Changes the user name used for SIP authentication
*
*  Changes the user name to be used when responding to a SIP authentication challenge.
*
*  The SIP user might be challenged on any SIP transaction (registration, call creation, etc). All authentication
*  is handled automatically.
*
*  \param[in] value The new user name to use for authentication
*/
@property(nonatomic) NSString*  _Nullable authUsername;

/** \brief Configures the Caller ID used as display name part in the address of record
*
*  \param[in] value  The CallerID to be used
*/
@property(nonatomic) NSString*  _Nullable callerID;

/** \brief Sets the use of rport for SIP users
*
*  Used to discover the public address and port in case there is a NAT between the user and the server. It also
*  helps for normal unfirewalled TCP and TLS connections (highly recommended for these two protocols).
*
*  If rport is enabled for UDP connects along with STUN, STUN will be preferred.
*
*  The default is to have rport disabled for UDP. A registration must be done to do a full discovery before making
*  any calls if they are to benefit from rport.
*
*  \param[in] value
*  \li No  Do not use rport.
*  \li Signaling  Enables usage of rport discovered public address for signaling negotiations.
*  \li Media  Enables usage of rport discovered public address for media negotiations - This option is NOT
*             recommended. Enable it only if you absolutely know what you're doing.
*  \li SignalingAndMedia  Enables usage of rport discovered public address for both signaling and media
*                         negotiations.
*
*  \see RPortType
*/
@property(nonatomic) ZDKRPortType  rPort;

/** \brief Sets the use of user's SRTP
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enableSRTP;

/** \brief Sets the use of call's preconditions framework as described in RFC 3312
*
*  The preconditions are used to negotiate network resources needed for a call before it starts ringing. The
*  negotiation is internal to the library without the need of special handling by the API user.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enablePreconditions;

/** \brief Sets video FMTP support
*
*  This will take effect in calls created/received after the setting has changed. Current calls will not be
*  affected.
*
*  Turned off by default.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  enableVideoFMTP;

/** \brief Sets the RTCP Feedback support
*
*  The purpose of RTCP Feedback is to provide quick inbound status reporting for media streams, error correction
*  and resilience against packet losses.
*
*  Currently only handling of packet loss is implemented (recovery from lost video configuration frames, resulting
*  into "black" time) - Full Intra Request (FIR) and  Picture Loss Indication (PLI).
*
*  \param[in] value
*  \li Off - Uses only AVP RTP Profile type - RTCP Feedbacks are OFF!
*  \li Compatibility - Use both AVP and AVPF RTP Profile types - RTCP Feedbacks are ON (media is duplicated in SDP)
*  \li On - Use only AVPF RTP Profile type - RTCP Feedbacks are ON (will establish media only if the remote peer
*           also supports AVPF!)
*
*  \see RTCPFeedbackType
*/
@property(nonatomic) ZDKRTCPFeedbackType  rtcpFeedback;

/** \brief Sets the STUN configuration
*
*  \param[in] value  STUN configuration
*
*  \see ZDKStunConfig
*/
@property(nonatomic) id<ZDKStunConfig>  _Nullable stun;

/** \brief Sets the MSRP configuration
*
*  \param[in] value  MSRP configuration
*
*  \see ZDKMSRPConfig
*/
@property(nonatomic) id<ZDKMSRPConfig>  _Nullable msrp;

/** \brief Sets the ZRTP configuration
*
*  \param[in] value  ZRTP configuration
*
*  \see ZDKZRTPConfig
*/
@property(nonatomic) id<ZDKZRTPConfig>  _Nullable zrtp;

/** \brief Sets the Push configuration
*
*  \param[in] value  Push configuration
*
*  \see ZDKPushConfig
*/
@property(nonatomic) id<ZDKPushConfig>  _Nullable push;

/** \brief Sets the use of Privacy mechanism as described in RFC 3323
*
*  Set whether the user's identity to be revealed in the SIP URIs or anonymous one to be used.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  enablePrivacy;

/** \brief Sets the keepalive interval for SIP accounts
*
*  The keepalive is a SIP packet sent over the signaling socket containing only a new line (CRLF). It is
*  automatically enabled for UDP sockets to keep alive any possible NAT mappings.  It has the same effect as
*  enabling STUN for this socket but unlike STUN it will always keep the connection alive.
*
*  Defaults (for -1) are 30 seconds for UDP and 180 seconds for TCP and TLS.
*  This setting will be applied to all subsequent SIP requests. For best effects set this before registering.
*
*  \param[in] value  Keepalive setting in seconds
*  \li -1 - Use the protocol's defaults
*  \li 0 - Disable any keepalives
*  \li \> 0 - Set the keepalive interval to that many seconds
*/
@property(nonatomic) int  keepAlive;

/** \brief Sets the use of SIP Header dumps for SIP Calls and Registration event
*
*  Enable or disable the SIP header fields dump for SIP calls and registration events for the specified user.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  headerDump;

/** \brief Sets a list with SIP Header fields to be added to a set of SIP Request Methods
*
*  Adds a list of header fields with its value to the list of custom headers to be added to each SIP request specified
*  in \p ZDKHeaderField::Method, made by this SIP user.
*
*  This could break the SIP request to the point that we will not even attempt to send it. Use with great care.
*
*  This function will automatically reject to touch the following header fields: Via, Contact, From, To, CallID, CSeq
*
*  \param[in] value  The list with additional SIP headers
*
*  \see ZDKHeaderField
*/
@property(nonatomic) NSArray<id<ZDKHeaderField>>*  _Nullable additionalHeaders;

/** \brief Sets the auto reject timeout for incoming calls
*
*  Configures the auto reject timeout for incoming calls in case no action is applied to them (either answer or reject).
*  Only works for calls started after calling this function.
*
*  \param[in] value  The timeout in seconds. 0 turns this feature off (default: 120 seconds)
*/
@property(nonatomic) int  callAutoRejectTimeout;

/** \brief Configures connection persistence for a user
*
*  Enables or disables the connection persistence option for a user (ENABLED by default).
*
*  Connection persistence refers to the outbound TCP or TLS connection for signaling.
*
*  This option has no effect in some configurations:
*
*  1. For SIP accounts with rport, it is always on.
*  2. For SIP accounts with SIP outbound, it is always on.
*  3. For accounts not using connection-oriented transports (SIP/UDP for example) it is always off.
*
*  This is useful for TCP or TLS SIP users that have rport disabled, don't use SIP outbound but desire a connection to be kept alive
*  and the server to be updated when the port changes (it will most probably be different on each connection).
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  connectionPersistence;

/** \brief Sets the desired RTP collision resolution
*
*  \param[in] value  The desired collision resolution (default: RTPCollisionResolutionType::Moderate)
*
*  \see RTPCollisionResolutionType
*/
@property(nonatomic) ZDKRTPCollisionResolutionType  rtpCollisionResolution;

/** \brief Changes the session timers setting according to RFC 4028.
*
*  The RFC describes two general modes when session timers are not disabled: UAC and UAS.
*
*  UAC means that the one who makes the call (the client or caller) will try to refresh the session periodically to
*  make sure it is still alive.
*
*  UAS means that the one who receives the call (the server or callee) will try to refresh the session.
*
*  We have two more settings, "local" and "remote". When "local" is selected, we'll try to be the ones to do the
*  refreshes. This means that we will use the "UAC" setting for outgoing calls and will prefer the "UAS" setting
*  for incoming calls.
*
*  The "remote" mode will do the opposite of the "local" mode. It will try to force the other end of the call to do
*  the refreshes.
*
*  The final decision is always at the one who provides the answer which does not always means this will be the
*  callee (especially when the SIP call was done using the ZDKNVITE-no-offer mode).
*
*  If the session timers are enabled we will always have a periodic refresh attempts, no matter if the remote end
*  supports this feature. This is according to RFC 4028.
*
*  If a re-ZDKNVITE (a refresh) fails the call is considered broken and will be closed with an error. The error can be
*  modified by any proxies in between.
*
*  \param[in] value  The desired Session Timer Mode (default: SessionTimerModeType::Disabled)
*
*  \see SessionTimerModeType, sessionTimerExpiry()
*/
@property(nonatomic) ZDKSessionTimerModeType  sessionTimerMode;

/** \brief Changes the session timer expiry according to RFC 4028.
*
*  Specifies the desired session expiration in seconds.
*
*  \param[in] value  Session expiration in seconds, if sessionTimerMode is not sessionTimerModeType::Disabled. Must be \>= 90s.
*
*  \see sessionTimerModeType, sessionTimerMode()
*/
@property(nonatomic) int  sessionTimerExpiry;

/** \brief Sets whether always to force the use of the mediasec
*
*  Require the use of the "mediasec" draft specification.
*  This will always send client-initiated "Security-Client" headers with "mediasec". Will fail in the case where SRTP is not enabled.
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enableMediasec;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  SIP configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKSIPConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
