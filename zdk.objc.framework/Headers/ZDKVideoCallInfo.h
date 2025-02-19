//
// ZDKVideoCallInfo.h
// ZDK
//

#ifndef ZDKVideoCallInfo_h
#define ZDKVideoCallInfo_h

#import <Foundation/Foundation.h>
#import "ZDKAudioVideoCodecs.h"
#import "ZDKOriginType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKVideoCallInfo <ZDKZHandle>

/** \brief Sets the thread id for the video call
*
*  \param[in] value  The ZDK handle
*/
@property(nonatomic) long int  threadID;

/** \brief Sets the codec used in the video call
*
*  \param[in] value  The video codec
*/
@property(nonatomic) ZDKAudioVideoCodecs  codec;

/** \brief Sets the direction of the video call
*
*  \param[in] value  The direction
*/
@property(nonatomic) ZDKOriginType  dir;

/** \brief Sets the width of the frame
*
*  \param[in] value  The width
*/
@property(nonatomic) int  width;

/** \brief Sets the height of the frame
*
*  \param[in] value  The height
*/
@property(nonatomic) int  height;

/** \brief Sets the frames per second
*
*  \param[in] value  The Frames Per Second
*/
@property(nonatomic) float  fps;

/** \brief Get the state of the outgoing video
*
*  The function get the state of the outgoing video. The state is changed via start().
*
*  \return The state of the outgoing video
*
*  \see start()
*/
@property(nonatomic, readonly) BOOL  outStarted;

/** \brief Get the state of the incoming video
*
*  The function get the state of the outgoing video.The state is changed via start().
*
*  \return The state of the incoming video
*
*  \see start()
*/
@property(nonatomic, readonly) BOOL  incStarted;

/** \brief Get the state of the both direction of video
*
*  The function the state of the both direction of video.The state is changed via start().
*
*  \return The state of the both direction of video
*
*  \see start()
*/
@property(nonatomic, readonly) BOOL  anyStarted;

/** \brief Sets the state of the hang up request
*
*  \param[in] value The state of the hang up request
*/
@property(nonatomic) BOOL  hangUpRequested;

/** \brief Sets the state of the hardware acceleration
*
*  \param[in] value The state of the hardware acceleration
*/
@property(nonatomic) BOOL  hwdAccelerated;

/** \brief Sets the state of answer with video
*
*  \param[in] value The state of answer with video
*/
@property(nonatomic) BOOL  answerWithVideo;

/** \brief Sets the state of the video in both directions
*
*  \param[in] dir  The direction
*  \param[in] value  The state of the video
*/
-(void)start:(ZDKOriginType)dir value:(BOOL)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
