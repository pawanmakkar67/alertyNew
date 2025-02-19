//
// ZDKCallEventsHandler.h
// ZDK
//

#ifndef ZDKCallEventsHandler_h
#define ZDKCallEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKCall.h"
#import "ZDKCallStatus.h"
#import "ZDKExtendedError.h"
#import "ZDKNetworkStatistics.h"
#import "ZDKNetworkQualityLevel.h"
#import "ZDKCallMediaChannel.h"
#import "ZDKCallSecurityLevel.h"
#import "ZDKResult.h"
#import "ZDKDTMFCodes.h"
#import "ZDKZRTPSASEncoding.h"
#import "ZDKZRTPHashAlgorithm.h"
#import "ZDKZRTPCipherAlgorithm.h"
#import "ZDKZRTPAuthTag.h"
#import "ZDKZRTPKeyAgreement.h"
#import "ZDKHeaderField.h"
#import "ZDKOriginType.h"
#import "ZDKEventHandle.h"
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKCallStatus.h"
@protocol ZDKCallStatus;
#import "ZDKExtendedError.h"
@protocol ZDKExtendedError;
#import "ZDKNetworkStatistics.h"
@protocol ZDKNetworkStatistics;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKCallEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify upon Call's status change
*
*  Notify upon call's related status information is changed
*
*  \param[in] call  The call which status is changed
*  \param[in] status  What status the account is changed to
*
*  \see ZDKCall, ZDKCallStatus
*/
-(void)onCall:(id<ZDKCall>)call statuschanged:(id<ZDKCallStatus>)status ;
/** \brief Notify upon call extended error occurs
*
*  Event fired when extended error in call occurs, providing detailed information for the error in the
*  ExtendedError object.
*
*  \param[in] call  The call that received the error
*  \param[in] error  The error object that provides full information regarding the error
*
*  \see ZDKCall, ZDKExtendedError
*/
-(void)onCall:(id<ZDKCall>)call extendedError:(id<ZDKExtendedError>)error ;
/** \brief Event for network statistics update
*
*  The event provides call's network statistic information
*
*  \param[in] call  The call which network statics is provided
*  \param[in] networkStatistics  The network statistics object with full statistic information
*
*  \see ZDKCall, ZDKNetworkStatistics
*/
-(void)onCall:(id<ZDKCall>)call networkStatistics:(id<ZDKNetworkStatistics>)networkStatistics ;
/** \brief Notify upon network quality level change
*
*  The event notify when network quality level changes
*
*  \param[in] call  The call which network quality level is changed
*  \param[in] callChannel  The call's channel
*  \param[in] qualityLevel  The quality level value
*
*  \see ZDKCall, NetworkQualityLevelType
*/
-(void)onCall:(id<ZDKCall>)call networkQualityLevel:(int)callChannel qualityLevel:(ZDKNetworkQualityLevel)qualityLevel ;
/** \brief Notify upon network quality level change
*
*  The event notify when network quality level changes
*
*  \param[in] call  The call which network quality level is changed
*  \param[in] callChannel  The call's channel
*  \param[in] qualityLevel  The quality level value
*
*  \see ZDKCall
*/
-(void)onCall:(id<ZDKCall>)call securityLevelChanged:(ZDKCallMediaChannel)callChannel qualityLevel:(ZDKCallSecurityLevel)qualityLevel ;
/** \brief Notify upon DTMF call result
*
*  The event notify upon DTMF (Dual-Tone Multi-Frequency) result for the call is returned
*
*  \param[in] call  The call for which DTMF response is returned
*  \param[in] result  The result
*
*  \see ZDKCall
*/
-(void)onCall:(id<ZDKCall>)call dtmfResult:(id<ZDKResult>)result ;
/** \brief Notify upon reception of DTMF from the remote peer
*
*  The event notify upon DTMF (Dual-Tone Multi-Frequency) reception from the remote peer
*
*  \param[in] call  The call for which received a DTMF
*  \param[in] dtmf  The received DTMF
*
*  \see ZDKCall, DTMFCodes
*/
-(void)onCall:(id<ZDKCall>)call dtmfReceived:(ZDKDTMFCodes)dtmf ;
/** \brief Succesuful call transfer event
*
*  The event notify upon the call transfer has succeeded
*
*  \param[in] call  The call which was transfered
*
*  \see ZDKCall, onCallTransferStarted(), onCallTransferSucceeded()
*/
-(void)onCalltransferSucceeded:(id<ZDKCall>)call ;
/** \brief Failed call transfer event
*
*  The event notify that the call transfer failed, it also provides the reason for the failure
*
*  \param[in] call  The call which was transfered failed
*  \param[in] error  The reason why it failed
*
*  \see ZDKCall, onCallTransferStarted(), onCallTransferSucceeded()
*/
-(void)onCall:(id<ZDKCall>)call transferFailure:(id<ZDKExtendedError>)error ;
/** \brief Notify that call transfer is initiated
*
*  The event notify that the call transfer is initiated.The number to transfer to (and display name and optionally
*  an URI, depending on the protocol) is given for informational purposes (or to help make the decision to accept
*  or reject the transfer).
*
*  \param[in] call  The call on which the transfer request came
*  \param[in] name  The name of the transfer target
*  \param[in] number  The number of the transfer target
*  \param[in] uri  Optionally, protocol dependant URI of the transfer target
*
*  \see ZDKCall, onCallTransferStarted(), onCallTransferSucceeded()
*/
-(void)onCall:(id<ZDKCall>)call transferStarted:(NSString*)name number:(NSString*)number uri:(NSString*)uri ;
/** \brief ZRTP negotiation failed for a call
*
*  The ZRTP negotiation for a call has failed. Information about the failure can be found in the error parameter.
*
*  \param[in] call  The call on which ZRTP failed
*  \param[in] error  Information on why the ZRTP failed
*
*  \see ZDKCall, ZDKExtendedError
*/
-(void)onCall:(id<ZDKCall>)call zrtpFailed:(id<ZDKExtendedError>)error ;
/** \brief ZRTP negotiation succeeded for a call
*
*  The ZRTP negotiation for a call has succeeded. This does not always mean full
*  security yet, due to the nature of ZRTP. Even though at this stage there is
*  an active SRTP encryption, the keys used might be compromised.
*
*  To make sure the keys were safe the participants will need to do verbal
*  comparison of a short string derived from the same calculations.
*  In case the identify of the participants was confirmed by using secret
*  data from previous calls SAS verification is not required.
*
*  If the peer in this call was known (found in the cache) the \p knownPeer
*  parameter will be set to 1. If we meet this peer for the first time, the
*  parameter will be set to 0.
*
*  If the peer knows us, the \p peerKnowsUs parameter will be set to 1. If
*  the peer sees us for the first time, or they see some other problem with
*  our identity, this flag will be set to 0.
*
*  Note that this information comes over the encrypted channel protected by ZRTP
*  but there is a small chance the encryption was compromised (i.e. do not
*  completely trust this flag).
*
*  If the peer is known and we agree on the retained secrets in our caches
*  (both us and them), the cacheMismatch will be set to 0.
*
*  If the peer was known but we disagree on the retained secret there might
*  be a security problem or one of us might have a corrupted cache file. In
*  this case the cacheMismatch will be set to 1.
*
*  If the peer is not known, the \p cacheMismatch value is set to 1 to make it
*  easier to check if we need SAS comparison by only looking at one parameter
*  instead of making complex logic checks.
*
*  If the peer sent us an indication that they do not know us from previous
*  calls (\p peerKnowsUs set to 0), \p cacheMismatch will also be set to 1 to
*  force SAS verification.
*
*  The string that needs to be compared is called the Short Authentication String.
*  It is returned in the \p sas parameter. Although \p sas is based on a binary
*  hash, it is encoded in a human-readable form. The encoding type is returned
*  in the \p sasEncoding paramter.
*
*  The ZRTP RFC recommends using the following warning text if SAS comparison
*  is required for a known peer (i.e. when \p knownPeer is 1 but \p cacheMismatch
*  is also set to 1):
*
*  Long version:
*      We expected the other party to have a shared secret cached from a
*      previous call, but they don't have it.  This may mean your peer
*      simply lost their cache of shared secrets, but it could also mean
*      someone is trying to wiretap you.  To resolve this question you
*      must check the authentication string with your peer.  If it
*      doesn't match, it indicates the presence of a wiretapper.
*
*  Short version:
*      Something's wrong.  You must check the authentication string with
*      your peer.  If it doesn't match, it indicates the presence of a
*      wiretapper.
*
*  Even if \p knownPeer is 1 and \p cacheMismatch is 0 and \p peerKnowsUs is 1,
*  the SAS should be made available on demand from the user. If the user demands
*  SAS verification and it fails,the call will be treated as insecure
*  and the user will be alerted.
*
*  More information about the ZRTP negotiation is returned in the rest of the
*  parameters.
*
*  "cipher" and "authTag" are of interest as they'll be employed by the SRTP
*  encryption and it might be useful to display them somewhere.
*
*  "hash" and "keyAgreement" are the hash algorithm and the key agreement method
*  used in this call.
*
*  \param[in] call  The call
*  \param[in] zidHex  The peer's ZRTP ID (ZID) in HEX representation
*  \param[in] knownPeer  1 if the peer is known, 0 if we see them for the first time
*  \param[in] cacheMismatch  1 if the peer needs to be confirmed, 0 if the cache agrees
*  \param[in] peerKnowsUs  1 if the peer knows us, 0 if they see us for the first time or
*                         if they have encountered a cache mismatch of their own
*  \param[in] sasEncoding  The SAS encoding
*  \param[in] sas  The Short Authentication String to be confirmed if needed. The
*                 string is in human readable form in the encoding \p sasEncoding
*  \param[in] hash  The chosen Hash Algorithm
*  \param[in] cipher  The chosen Cipher Algorithm (used in SRTP)
*  \param[in] authTag  The chosen Authentication Tag type (used in SRTP)
*  \param[in] keyAgreement  The key agreement method used for the negotiation
*
*  \see ZDKCall, ZRTPSASEncoding, ZRTPHashAlgorithm, ZRTPCipherAlgorithm, ZRTPAuthTag, ZRTPKeyAgreement
*/
-(void)onCall:(id<ZDKCall>)call zrtpSuccess:(NSString*)zidHex knownPeer:(int)knownPeer cacheMismatch:(int)cacheMismatch peerKnowsUs:(int)peerKnowsUs sasEncoding:(ZDKZRTPSASEncoding)sasEncoding sas:(NSString*)sas hash:(ZDKZRTPHashAlgorithm)hash cipher:(ZDKZRTPCipherAlgorithm)cipher authTag:(ZDKZRTPAuthTag)authTag keyAgreement:(ZDKZRTPKeyAgreement)keyAgreement ;
/** \brief Secondary stream failed to negotiate ZRTP
*
*  Multistream ZRTP negotiation has failed for a secondary stream in a call.
*
*  ZRTP requires only the first RTP stream in a SIP call to be negotiated with
*  a full Diffie-Hellman key exchange.
*
*  Due to the nature of ZRTP the primary RTP stream is an audio stream (to allow
*  for voice confirmation of the SAS).
*
*  Subsequent streams in a call, like the video stream for example, will use
*  a shorter version of ZRTP called "Multistream ZRTP" to negotiate the keys.
*
*  In case a SIP call is configured with both ZRTP and Video, after the ZRTP
*  finishes securing the audio channel, the SIP call will automatically try to
*  secure the video channel. If this secondary negotiation fails this event will
*  be fired.
*
*  This error does NOT mean that the primary channel is suddenly broken. There
*  are no side effects from this failure. The remote end might have a different
*  opinion on the matter and might decide to close the call.
*
*  \param[in] call The call Id on which the secondary ZRTP negotiation failed
*  \param[in] callChannel The type of the secondary RTP stream (usually video)
*  \param[in] error Detailed error information about the failure
*
*  \see ZDKCall, ZDKExtendedError
*/
-(void)onCall:(id<ZDKCall>)call zrtpSecondaryError:(int)callChannel error:(id<ZDKExtendedError>)error ;
/** \brief SIP header dump for a SIP call
*
*  Dumps the header of a SIP message from a SIP call. For incoming calls, this is the header of the ZDKNVITE message.
*  For outgoing calls, this is the header of the 200 response.
*
*  Each header field from the SIP header is represented as an entry in \p headerFields.
*
*  Each header field can have one or more values associated with it in the \p Values array.
*
*  The header field \p Name and the \p Values are UTF-8 strings.
*
*  The structure is valid only for the duration of this callback.
*
*  To enable this callback, use zdksipConfig::HeaderDump().
*
*  \param[in] call  The call
*  \param[in] headerFields The header fields array
*
*  \see ZDKCall, ZDKHeaderFields
*/
-(void)onCall:(id<ZDKCall>)call sipHeaderFields:(NSArray*)headerFields ;
/** \brief Video offered for audio calls
*
*  The remote party has offered us video during a normal (audio) call.
*  Use acceptVideo() to accept or decline the video
*
*  \param[in] call  The call
*
*  \see ZDKCall
*/
-(void)onVideoOffered:(id<ZDKCall>)call ;
/** \brief Video started
*
*  The video has started.The call is ready to
*  encode and send frames over the network.  Use the sendVideoFrame()
*  function to send frames.
*
*  \param[in] call  The video call
*  \param[in] origin  The call initiator type (incoming, outgoing)
*
*  \see ZDKCall, OriginType
*/
-(void)onVideoStarted:(id<ZDKCall>)call origin:(ZDKOriginType)origin ;
/** \brief Video stopped
*
*  The Video has stopped.
*
*  \param[in] call  The video call
*  \param[in] origin  The call initiator type (incoming, outgoing)
*
*  \see ZDKCall, OriginType
*/
-(void)onVideoStopped:(id<ZDKCall>)call origin:(ZDKOriginType)origin ;
/** \brief Video camera changed
*
*  The Video cameras changed.
*
*  \param[in] call  The video call
*
*  \see ZDKCall
*/
-(void)onVideoCameraChanged:(id<ZDKCall>)call ;
/** \brief Video format selected
*
*  \param[in] call  The call for which the video format was selected
*  \param[in] dir  The direction
*  \param[in] width  Width in pixels
*  \param[in] height  Height in pixels
*  \param[in] fps  Frames per seconds
*
*  \see ZDKCall, OriginType
*/
-(void)onVideoFormatSelected:(id<ZDKCall>)call dir:(ZDKOriginType)dir width:(int)width height:(int)height fps:(float)fps ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
