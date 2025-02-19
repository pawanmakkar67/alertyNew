//
// ZDKAccount.h
// ZDK
//

#ifndef ZDKAccount_h
#define ZDKAccount_h

#import <Foundation/Foundation.h>
#import "ZDKAccountConfig.h"
#import "ZDKAccountStatus.h"
#import "ZDKAudioVideoCodecs.h"
#import "ZDKAccountEventsHandler.h"
#import "ZDKMessageType.h"
#import "ZDKContactStateType.h"
#import "ZDKCall.h"
#import "ZDKSIPProbeEventsHandler.h"
#import "ZDKSecureUserConfigType.h"
#import "ZDKResult.h"
#import "ZDKMessage.h"
#import "ZDKZHandle.h"
#import "ZDKAccountConfig.h"
@protocol ZDKAccountConfig;
#import "ZDKAccountEventsHandler.h"
@protocol ZDKAccountEventsHandler;
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKSIPProbeEventsHandler.h"
@protocol ZDKSIPProbeEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;
#import "ZDKMessage.h"
@protocol ZDKMessage;

NS_ASSUME_NONNULL_BEGIN

/** \brief The main account class
*/
@protocol ZDKAccount <ZDKZHandle>

/** \brief Gets the underlying user handler ID
*
*  Internally assigned on successful createUser() invocation and invalidated on removeUser().
*
*  \return The underlying user handler ZDKD
*/
@property(nonatomic, readonly) long int  userHandle;

/** \brief Sets the account configuration
*
*  All changes checks and actions are taken automatically - e.g. reregister the account
*
*  \param[in] value  The account configuration
*
*  \see AccountConfig
*/
@property(nonatomic) id<ZDKAccountConfig>  configuration;

/** \brief Gets the ID of the account
*
*  \return The account's ZDKD
*/
@property(nonatomic, readonly) long int  accountID;

/** \brief Configures the account name
*
*  \param[in] value  The account's name
*/
@property(nonatomic) NSString*  _Nullable accountName;

/** \brief Gets the current account registration status
*
*  \return The account's registration status
*
*  \see ZDKAccountStatus
*/
@property(nonatomic, readonly) ZDKAccountStatus  registrationStatus;

/** \brief Configures the account's codecs allowed to be used
*
*  The order in which codecs are added is important. The codecs that are first in the list have greater priority.
*  To reorder the list re-add the codecs with the proper order.
*
*  \param[in] value  The full list with codecs to be used
*
*  \see AudioVideoCodecs
*/
@property(nonatomic) NSArray<NSNumber*>*  mediaCodecs;

@property(nonatomic, readonly) int  actualRegistrationExpiry;

/** \brief Registers the user to the configured service
*
*  Starts the user's registration process. If the registration process was started the function returns Ok. The
*  result of the process will be delivered by a callback.
*
*  \return Result of the invocation
*
*  \see zdkAccountEventsHandler(), ZDKResult
*/
-(id<ZDKResult>)registerAccount;
/** \brief Cancels registration and/or unregisters the user
*
*  If the user account is in the process of registration this function will cancel it. If the user was already
*  registered an unregistration process will start. If there is no error the function will return immediately and
*  the final result will be delivered via a callback.
*
*  \return Result of the invocation
*
*  \see zdkAccountEventsHandler(), ZDKResult
*/
-(id<ZDKResult>)unRegister;
/** \brief Creates a new user account
*
*  Creates a new protocol user, based on the assigned configuration, that can be used to register on a server for
*  incoming calls, create outgoing calls, subscribe for presence, etc. This is a mandatory operation before using
*  most of the ZDK's functions.
*
*  \return Result of the creation
*
*  \see ZDKResult, configuration(), removeUser()
*/
-(id<ZDKResult>)createUser;
/** \brief Destroys an user account object
*
*  Destroys an user account object and all related structures. Automatically unregisters the account from the
*  server.
*
*  Fails if the user has active calls.
*
*  \return Result of the removal
*
*  \see ZDKResult, createUser()
*/
-(id<ZDKResult>)removeUser;
/** \brief Clears the account's codec list
*
*  Equivalent to providing an empty list to mediaCodecs().
*
*  \see AudioVideoCodecs, mediaCodecs()
*/
-(void)clearMediaCodecs;
/** \brief Adds a new account event listener
*
*  All added listeners will be notified for each event.
*
*  \param[in] value  The account event listener to be added
*
*  \see ZDKAccountEventsHandler, dropStatusEventListener()
*/
-(void)setStatusEventListener:(id<ZDKAccountEventsHandler>)value ;
/** \brief Removes a specific already added account event listener
*
*  All added/left listeners will be notified for each event.
*
*  \param[in] value  The account event listener to be removed
*
*  \see ZDKAccountEventsHandler, setStatusEventListener()
*/
-(void)dropStatusEventListener:(id<ZDKAccountEventsHandler>)value ;
/** \brief Creates and starts an outgoing call
*
*  Creates a call originating from the specified user and starts it.
*  If there is no error the function will return immediately. Updates on the call status will come via callbacks.
*
*  \param[in] calleeNumber  The number/user to call. The actual address is created from this ID and the account's
*             configued domain.
*  \param[in] handlingVoipPhoneCallEvents  Indicator whether to handle/receive call specific events
*  \param[in] video  Indicator whether to initiate a video call, if supported
*
*  \return The newly created call
*
*  \see ZDKCall, ZDKCallEventsHandler
*/
-(id<ZDKCall> _Nullable)createCall:(NSString*)calleeNumber handlingVoipPhoneCallEvents:(BOOL)handlingVoipPhoneCallEvents video:(BOOL)video ;
/** \brief Gets a list with all account's active/ongoing calls
*
*  \return The list with all account's active/ongoing calls
*
*  \see ZDKCall
*/
-(NSArray*)getActiveCalls;
/** \brief Creates a new EMPTY chat message with the given type
*
*  Creates and returns a new empty chat message from the given type that has to be filled in and then sent!
*
*  \param[in] type  The type of message to be created
*
*  \return The newly created empty message
*
*  \see ZDKMessage, MessageType
*/
-(id<ZDKMessage>)createMessage:(ZDKMessageType)type ;
/** \brief End a chat session
*
*  NOT ZDKMPLEMENTED!
*
*  \param[in] pPeer  The Peer with whom to terminate the chat session
*
*  \return Result of the ending
*
*  \see ZDKResult
*/
-(id<ZDKResult>)chatSessionEnd:(NSString*)pPeer ;
/** \brief Start a presence publication for the user
*
*  Use this function to publish the user's status on the server (if the server supports it). Use this function
*  again at any time to change the account's status.
*
*  \param[in] status  Status of the user
*  \param[in] message  If not NULLor empty, this will be published in the PIDF
*
*  \return Result of the set
*
*  \see ZDKResult
*/
-(id<ZDKResult>)setPresenceStatus:(ZDKContactStateType)status message:(NSString* _Nullable)message ;
-(id<ZDKResult>)stopPushAndUnregister:(BOOL)shouldRegister ;
-(id<ZDKResult>)relinquishCallownership:(id<ZDKCall>)call ;
/** \brief Generate a random UUID
*
*  Generates a valid RFC 4122 (RFC 2141) UUID URN that can be used for RFC 5626 (SIP Outbound).
*
*  The result is a string in the format
*
*  "urn:uuid:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
*
*  or the format
*
*  "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
*
*  depending on the "noPrefix" parameter. The prefix is there for easier use of ZDKSIPConfig's sipInstance().
*
*  In case the "urn:uuid:" prefix is not desired, put 1 to the "noPrefix" parameter. The resulting string will be
*  shorter and will contain only the random part.
*
*  If "noPrefix" is set to 0, the resulting string can be given directly to ZDKSIPConfig's sipInstance().
*
*  \param[in] noPrefix  Set to 0 for full URN, 1 for a UUID without prefix
*  \param[in] bufLen  Available bytes in the buffer (64 bytes or more are sufficient)
*
*  \return The generated UUID string
*/
-(NSString*)generateUUID:(BOOL)noPrefix bufLen:(int)bufLen ;
/** \brief Replace user registration
*
*  For protocols such as ZDKAX2 there is no "binding" and this operation does not apply. For those types of protocols
*  the function will internally call registerUser() and then return its status.
*
*  This function will first try to cleanly remove any active bindings on the registrar server that were put by this
*  instance of the library.
*
*  Then it will try to create a new registration binding on the server.
*
*  This is mostly useful when switching network types and an IP address change has been detected. This function
*  will try to remove the old (stale) binding that is currently active on the server and replace it with a "fresh"
*  one done from the new IP address.
*
*  !NOTE! Network changed handling MUST be done with ZDKContext's networkChanged()!
*
*  A better approach might be to use SIP Outbound (RFC 5626) but that requires server support.
*
*  \return Result of the invocation
*
*  \see ZDKResult, registerAccount(), unRegister()
*/
-(id<ZDKResult>)replaceUserRegistration;
/** \brief Adds a new SIP probe event listener
*
*  All added listeners will be notified for each event.
*
*  \param[in] value  The SIP probe event listener to be added
*
*  \see ZDKSIPProbeEventsHandler, dropProbeEventListener()
*/
-(void)setProbeEventListener:(id<ZDKSIPProbeEventsHandler>)value ;
/** \brief Removes a specific already added SIP probe event listener
*
*  All added/left listeners will be notified for each event.
*
*  \param[in] value  The SIP probe event listener to be removed
*
*  \see ZDKSIPProbeEventsHandler, setProbeEventListener()
*/
-(void)dropProbeEventListener:(id<ZDKSIPProbeEventsHandler>)value ;
/** \brief Probes for available transports for the given SIP settings
*
*  Probes consecutively for transport availability over SIP with the given account settings.
*
*  The tests are done via SIP REGISTER requests with the given settings. The actual account's configuration will be
*  used for this. No user-specific callbacks will be fired for this process.
*
*  This might be useful during the creation/configuration of the user account in order to notify the user for the
*  supported transports and/or misconfiguration of either server or credentials.
*
*  During the TLS checks a Certificate-related callback can be fired which will usually result in TLS being
*  rejected as a viable transport and the probing will continue with TCP.
*
*  If the TLS settings are changed the probing can be restarted.
*
*  The profile generated for the TLS test will benefit from any certificates that were added for a SIP user with
*  the same configuration.
*
*  STUN and rport will not be used or tested. This may cause the probing to fail because of NAT issues.
*
*  The transports are checked in this order:
*  1. TLS
*  2. TCP
*  3. UDP
*
*  Each test will generate an informative callback. The process will be considered successful after the first
*  successful REGISTER. The newly created binding on the server will be removed (the temporary profile will be
*  unregistered).
*
*  \param[in] domain  Domain (SIP user creation: realm entry)
*  \param[in] outboundProxy  Outbound proxy (SIP user creation: server entry)
*  \param[in] username  Username
*  \param[in] authUsername  Authentication username
*  \param[in] password  Authentication password
*
*  \return Result of the invocation
*
*  \see ZDKSIPProbeEventsHandler, ZDKResult
*/
-(id<ZDKResult>)probeSipTransport:(NSString*)domain outboundProxy:(NSString*)outboundProxy username:(NSString*)username authUsername:(NSString*)authUsername password:(NSString*)password ;
/** \brief Terminates user's TCP-based connection
*
*  Destroys the currently used TCP-based connection. That triggers re-registration of EVERY already registered user
*  using this socket/connection.
*
*  Very handy when PUSH is used for example, where it is nearly certain the connection is stale/half-opened.
*
*  \return Result of the invocation - ResultCode::InvalidArgument error in cases where the given connection is not TCP-based!
*/
-(id<ZDKResult>)terminateConnection;
/** \brief Configure TLS for a user
*
*  Not only configuring a certificates for TLS is needed but also to run without one or to assign the user to a
*  global TLS transport.
*
*  Although this function is meant to be used for different protocols, currently it only supports SIP.
*
*  \param[in] userConf  The TLS server mode setting:
*  \li ClientOnly - This setting switches the user to a certificate-less operation.
*                   This mode is used by the majority of TLS client applciations and should be the default setting.
*                   This mode ignores \p fileName and \p passPhrase.
*                   For SIP, rport is almost certainly required for this to work properly before we add support for
*                   RFC 5626 (SIP Outbound). This will try to force any requests over TLS to come back over our
*                   outbound TLS connection as we won't have a working TLS server for this user.
*  \li Common - In case ZDK was configured to accept incoming TLS connections, there is a global TLS server object
*               which can be shared between the users of the same protocol (SIP only for now).
*               This mode ignores \p fileName and \p passPhrase.
*               For SIP, rport is highly recommended but not required for this mode because we can receive incoming
*               TLS connections unless a firewall interferes with our traffic.
*  \li Dedicated - This mode is available in case the TLS server requires user certificates. The user certificate
*                  must be provided in \p fileName and if the key along with the certificate is encrypted, the
*                  encryption passphrase must be provided in \p passPhrase.
*                  The format for the key+cert combination is either PEM or PKCS#12.
*                  Additional certificates in case the format is PKCS#12 are added to the trusted root certificate
*                  authorities list.
*                  For SIP, rport is highly recommended. See Common's notes on rport above.
*  \li Generated - This mode will generate a self-signed certificate with the protocol-level URI as certificate
*                  subject (this is the SIP URI for SIP users). It will then create a dedicated TLS server transport
*                  and bind it to the generated certificate.
*                  This mode ignores \p fileName and \p passPhrase.
*                  NOT RECOMMENDED.
*  \param[in] fileName  Used to point to a PEM or PKCS#12 certificate to load for this user, depending on \p userConf.
*  \param[in] passPhrase  Used to provide the encryption pass phrase in case a certificate is being loaded
*
*  \return Result of the set
*
*  \see verifyUserCertificate()
*/
-(id<ZDKResult>)setTlsConfig:(ZDKSecureUserConfigType)userConf fileName:(NSString*)fileName passPhrase:(NSString* _Nullable)passPhrase ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
