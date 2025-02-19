//
// ZDKAudioDevice.h
// ZDK
//

#ifndef ZDKAudioDevice_h
#define ZDKAudioDevice_h

#import <Foundation/Foundation.h>
#import "ZDKAudioDeviceType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Audio device description
*/
@protocol ZDKAudioDevice <ZDKZHandle>

/** \brief Gets the name of the audio device
*
*  \return The name of the audio device
*/
@property(nonatomic, readonly) NSString*  _Nullable name;

/** \brief Gets the type of the audio device
*
*  \return The type of the audio device
*
*  \see AudioDeviceType
*/
@property(nonatomic, readonly) ZDKAudioDeviceType  type;

/** \brief Gets the number of input channels the audio device supports
*
*  \return The number of input channels
*/
@property(nonatomic, readonly) int  maxInputChannels;

/** \brief Gets the number of output channels the audio device supports
*
*  \return The number of output channels
*/
@property(nonatomic, readonly) int  maxOutputChannels;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
