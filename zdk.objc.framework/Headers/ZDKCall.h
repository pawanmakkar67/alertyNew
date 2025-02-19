//
// ZDKCall.h
// ZDK
//

#ifndef ZDKCall_h
#define ZDKCall_h

#import <Foundation/Foundation.h>
#import "ZDKBrandingInfo.h"
#import "ZDKCallStatus.h"
#import "ZDKAudioVideoCodecs.h"
#import "ZDKVideoCallInfo.h"
#import "ZDKAccount.h"
#import "ZDKCallEventsHandler.h"
#import "ZDKVideoRendererEventsHandler.h"
#import "ZDKCall.h"
#import "ZDKVideoFrameFormat.h"
#import "ZDKOriginType.h"
#import "ZDKDTMFCodes.h"
#import "ZDKAudioFileFormat.h"
#import "ZDKResult.h"
#import "ZDKCameraSensorLocation.h"
#import "ZDKZHandle.h"
#import "ZDKBrandingInfo.h"
@protocol ZDKBrandingInfo;
#import "ZDKCallStatus.h"
@protocol ZDKCallStatus;
#import "ZDKVideoCallInfo.h"
@protocol ZDKVideoCallInfo;
#import "ZDKAccount.h"
@protocol ZDKAccount;
#import "ZDKCallEventsHandler.h"
@protocol ZDKCallEventsHandler;
#import "ZDKVideoRendererEventsHandler.h"
@protocol ZDKVideoRendererEventsHandler;
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKCall <ZDKZHandle>

/** \brief Gets call handle
*
*  \return ZDKHandle object holding the handle
*/
@property(nonatomic, readonly) long int  callHandle;

@property(nonatomic) id<ZDKBrandingInfo>  _Nullable branding;

/** \brief Provides the Call's status information
*
*  \return The call status
*
*  \see ZDKCallStatus
*/
@property(nonatomic, readonly) id<ZDKCallStatus>  status;

/** \brief Provides the Callee number
*
*  \return String with the callee number
*/
@property(nonatomic, readonly) NSString*  calleeNumber;

/** \brief Provides the Callee name
*
*  \return String with the callee name
*/
@property(nonatomic, readonly) NSString*  calleeName;

/** \brief Provides the used codec
*
*  \return AudioVideoCodecs representing the used codec
*
*  \see AudioVideoCodecs
*/
@property(nonatomic, readonly) ZDKAudioVideoCodecs  codecInUse;

/** \brief Sets the speakers state
*
*  !!!NOTE!!! Only keeps track of the SPEAKER state. DOES NOT change the audio routing!!!
*  API user is responsible for changing the audio routing!!!
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  onSpeaker;

/** \brief Sets the hold state
*
*  \param[in] value
*  \li 0 - resume
*  \li 1 - hold
*/
@property(nonatomic) BOOL  held;

/** \brief Sets the Mute state of the local input device
*
*  Mutes/unmutes the local input device (microphone).
*
*  \param[in] value
*  \li 0 - unmute
*  \li 1 - mute
*/
@property(nonatomic) BOOL  muted;

/** \brief Gets Video call information
*
*  Gets if video is present, local or remote.
*
*  \return Video Call Information object
*
*  \see ZDKVideoCallInfo
*/
@property(nonatomic, readonly) id<ZDKVideoCallInfo>  _Nullable videoCallInfo;

@property(nonatomic, readonly) BOOL  isFirstClass;

/** \brief Returns the account owner
*
*  \return The account owner
*
*  \see ZDKAccount
*/
@property(nonatomic, readonly) id<ZDKAccount>  owner;

/** \brief Sets the record file name
*
*  \param[in] value  The name of the record file to be used
*/
@property(nonatomic) NSString*  recordFileName;

/** \brief Sets Call status listener
*
*  \param[in] value  The call events handler
*
*  \see ZDKCallEventsHandler
*/
-(void)setCallStatusListener:(id<ZDKCallEventsHandler>)value ;
/** \brief Drops Call status listener
*
*  \param[in] value  The call events handler to drop
*
*  \see ZDKCallEventsHandler
*/
-(void)dropCallStatusListener:(id<ZDKCallEventsHandler>)value ;
/** \brief Drops all event listeners
*/
-(void)dropAllEventListeners;
-(void)setVideoRendererNotificationsListener:(id<ZDKVideoRendererEventsHandler>)value ;
/** \brief Notifies the remote party that we are ringing (incoming calls)
*
*  Sends a ringing notification to the remote party for an incoming call.
*  The call must not be accepted yet.
*
*  \return The result of the ringing notification
*
*  \see ZDKResult
*/
-(id<ZDKResult>)ringing;
/** \brief Accepts an incoming call
*
*  Accepts an incoming call and opens audio and video channels for communication.
*
*  \return The result of accepting call up
*
*  \see ZDKResult
*/
-(id<ZDKResult>)acceptCall;
/** \brief Hang up the call
*
*  \return The result of hanging up
*
*  \see ZDKResult
*/
-(id<ZDKResult>)hangUp;
/** \brief Accept a call transfer request
*
*  Accept a call transfer request and creates a new outgoing call to the transfer target.
*
*  The notification listeners will be coppied to the newly created call!
*
*  The new call will get all the relevant callbacks as if it was normally created outgoing call.
*
*  The old call will be hung up only after the new call is succesful.
*
*  \return The newly created transferring call or NULL in case of transfer failure
*
*  \see ZDKCall
*/
-(id<ZDKCall>)acceptCallTransfer;
/** \brief Rejects a call transfer request
*
*  Rejects a call transfer request.For SIP, the call will continue as usual.
*
*  \return The result of rejecting the call transfer
*
*  \see ZDKResult
*/
-(id<ZDKResult>)rejectCallTransfer;
/** \brief Initiates an attended call transfer
*
*  Initiates an attended call transfer.  There have to be two calls using
*  the same user account (call direction doesn't matter).  The calls
*  must have been accepted.  They can be currently on hold.
*  The library will put the calls on hold if they already weren't. If
*  the transfer fails the first call will be retrieved back.
*
*  For SIP calls the REFER message will be sent to the first call.
*
*  \param[in] transferee  The call to which the current call to be transfered to
*
*  \return The result of the attended transfer
*
*  \see ZDKResult
*/
-(id<ZDKResult>)attendedTransfer:(id<ZDKCall>)transferee ;
/** \brief Initiates an unattended call transfer
*
*  Initiates an unattended transfer (also called blind transfer).  This function
*  can be used for incoming SIP calls to redirect them.  Incoming ZDKAX2 calls
*  cannot be redirected.
*
*  Calls that were answered (incoming or outgoing) can be transferred using
*  this function (both SIP and ZDKAX2).
*
*  The function returns immediately.  If there is no error the process of
*  unattended transfer will start.
*
*  \param[in] transferee  The name of the Peer to which the current call to be transfered to
*
*  \return The result of the unattended transfer
*
*  \see ZDKResult
*/
-(id<ZDKResult>)blindTransfer:(NSString*)transferee ;
/** \brief Accepts an incoming offer for video
*
*  \param[in] accept  Flag indicating whether to accept or reject the offered video
*
*  \return The result of accepted video
*
*  \see ZDKResult
*/
-(id<ZDKResult>)acceptVideo:(BOOL)accept ;
/** \brief Offers Video
*
*  Offers video to the remote party during a normal (audio) call.
*
*  \return The result of the video offer
*
*  \see ZDKResult
*/
-(id<ZDKResult>)offerVideo;
/** \brief Send a video frame over the network
*
*  Send an arbitrary-format frame to the remote party
*
*  The function will copy the buffer into its internal structures and schedule
*  it for encoding and transmitting over the video call.  It will return
*  immediately.
*
*  \param[in] bytes  The buffer that holds the bytes
*  \param[in] byteCount  The buffer size in number of bytes
*  \param[in] type  The format of the frame we are sending
*
*  \see VideoFrameFormat
*/
-(void)sendVideoFrame:(unsigned char*)bytes byteCount:(int)byteCount type:(ZDKVideoFrameFormat)type ;
/** \brief Toggles the camera
*
*  \return The result of toggling the camera
*
*  \see ZDKResult
*/
-(id<ZDKResult>)videoToggleCamera;
/** \brief Provides Camera location
*
*  Provides Camera location ( Front, Back, NA )
*
*  \return The camera seonsor object that holds the camera location information
*
*  \see CameraSensorLocation
*
*/
-(ZDKCameraSensorLocation)videoGetCameraLocation;
/** \brief Restart Video capture
*
*  \return Result of the restarting video capture
*
*  \see ZDKResult
*/
-(id<ZDKResult>)restartVideoCapture;
/** \brief Gets if video is present
*
*  Gets if video is present, local or remote.
*
*  \param[in] origin  The side that we want to check if video is present (local or remote)
*
*  \return bool with the result of the state
*
*  \see OriginType
*/
-(BOOL)hasVideo:(ZDKOriginType)origin ;
/** \brief Stops handling Call events
*/
-(void)stopHandlingVoipPhoneCallEvents;
/** \brief Start handling Call events
*/
-(void)startHandlingVoipPhoneCallEvents;
/** \brief Notify upon Account ownership changes
*
*  \return result of notification
*
*  \see ZDKResult
*/
-(id<ZDKResult>)notifyAccountOfOwnershipChange;
/** \brief Sends a DTMF signal over a call
*
*  Sends a DTMF signal over a call. The BS (backspace) key is only supported by SIP/KPML. To select the DTMF type use zdkAccountConfig::DTMFBand().
*
*  The function returns immediately. If there is no immediate error the function will return OK and the actual status of the DTMF send operation
*  will be delivered via a callback.
*
*  By default The ZDK will not produce an audible local signal to reflect the DTMF transmission. You can configure the ZDK to produce an audible
*  signal by using zdkAccountConfig::DTMFAutoplay().
*
*  \param[in] dtmf  The DTMF you want to send
*
*  \return result of sending DTMF
*
*  \see ZDKAccountConfig, ZDKResult, DTMFCodes
*/
-(id<ZDKResult>)sendDTMF:(ZDKDTMFCodes)dtmf ;
/** \brief Start recording call
*
*  \return Result of StartRecoding
*
*  \see ZDKResult
*/
-(id<ZDKResult>)startRecording;
/** \brief Stop recording
*
*  \return Result of StopRecoding
*
*  \see ZDKResult
*/
-(id<ZDKResult>)stopRecording;
/** \brief Enables ZRTP
*
*  \param[in] enabled
*  \li 0 - disabled
*  \li 1 - enabled
*
*  \return Result of enabling zrtp
*
*  \see ZDKResult
*/
-(id<ZDKResult>)enableZrtp:(BOOL)enabled ;
/** \brief Enables ZRTP
*
*  \param[in] confirmed
*  \li 0 - disabled
*  \li 1 - enabled
*
*  \return Result of enabling zrtp
*
*  \see ZDKResult
*/
-(id<ZDKResult>)confirmZrtpSas:(BOOL)confirmed ;
/** \brief Configures a call recording's encoding format and its specific settings.
*
*  \param[in] format  The format in which the call recording to be stored
*
*  \return Result of enabling configuring the call record format
*
*  \see ZDKResult, AudioFileFormat
*/
-(id<ZDKResult>)configureCallRecordFormat:(ZDKAudioFileFormat)format ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
