//
// ZDKRingBackToneControl.h
// ZDK
//

#ifndef ZDKRingBackToneControl_h
#define ZDKRingBackToneControl_h

#import <Foundation/Foundation.h>
#import "ZDKSound.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKSound.h"
@protocol ZDKSound;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Ringback tone's main entry point
*
*  Entry point for controlling the ringback tone heard by the user when the remote peer starts ringing
*/
@protocol ZDKRingBackToneControl <ZDKZHandle>

/** \brief Gets the configured use of ringback tone
*
*  Whether ringback tones can be played or not.
*
*  ENABLED by default!
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enable;

/** \brief Sets the configured ringback sound
*
*  \param[in] value  The new ringback sound to be used
*
*  \see ZDKSound
*/
@property(nonatomic) id<ZDKSound>  ringBackSound;

/** \brief Starts the ringback tone playing
*
*  The ringback tone will be played only if it is not already running and enabled! Error will be returned otherwise.
*
*  \return Result of the invocation
*
*  \see ZDKResult, enable()
*/
-(id<ZDKResult>)play;
/** \brief Stops the playing of the ringback tone
*
*  The ringback tone will be stoped only if it is already running and enabled! Error will be returned otherwise.
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)stop;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
