//
// ZDKVideoEndpointControl.h
// ZDK
//

#ifndef ZDKVideoEndpointControl_h
#define ZDKVideoEndpointControl_h

#import <Foundation/Foundation.h>
#import "ZDKResult.h"
#import "ZDKCameraSensorLocation.h"
#import "ZDKZHandle.h"
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Video endpoint's main entry point
*
*  Entry point for controlling the video endpoint
*/
@protocol ZDKVideoEndpointControl <ZDKZHandle>

/** \brief Configures the used video format
*
*  Configures the format used for negotiating video calls and actual camera capture/sending.
*
*  Most codecs have limitations regarding the frame dimensions. CIF formats are always supported.
*
*  When the format is negotiated with remote peer, the zdkCallEventsHandler.onVideoFormatSelected() callback will be
*  called.
*
*  \param[in] width  Width of the video frame in pixels
*  \param[in] height  Height of the video frame in pixels
*  \param[in] fps  Frames per second of the video stream
*
*  \return Result of the invocation
*
*  \see ZDKResult, setBitrate(), onVideoFormatSelected()
*/
-(id<ZDKResult>)setFormat:(int)width height:(int)height fps:(float)fps ;
/** \brief Configures the video encoder's bitrate
*
*  Configures the video encoder's output bitrate in bits per second. This function along with setFormat() will
*  affect all video calls. Because the frames come outside of this library if the frame rate is not as configured
*  the resulting bit rate can differ greatly. Example: if the library's video encoder is configured for 128000 bps
*  for a video format of 352x288 and 5 fps, but the frames actually come at 10fps the resulting bitrate will be
*  256000 bps.
*
*  \param[in] value  The bitrate of the encoder in bits per second
*
*  \return Result of the invocation
*
*  \see ZDKResult, setFormat()
*/
-(id<ZDKResult>)setBitrate:(int)value ;
/** \brief Starts the video capture
*
*  Not implemented!
*
*  \param[in] hwdAcceleration  Indicator whether the hardware accelerator to be used if available
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)startCapture:(BOOL)hwdAcceleration ;
/** \brief Stops the video capture
*
*  Not implemented!
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)stopCapture;
/** \brief Toggles the camera
*
*  Not implemented!
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)toggleCamera;
/** \brief Restarts the camera
*
*  Not implemented!
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)restartCamera;
/** \brief Gets the used camera location
*
*  Not implemented!
*
*  \return The camera location
*
*  \see CameraSensorLocation
*/
-(ZDKCameraSensorLocation)getCameraLocation;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
