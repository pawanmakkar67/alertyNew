//
// ZDKAudioEventsHandler.h
// ZDK
//

#ifndef ZDKAudioEventsHandler_h
#define ZDKAudioEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKAudioDevice.h"
#import "ZDKAudioDeviceState.h"
#import "ZDKEventHandle.h"
#import "ZDKAudioDevice.h"
@protocol ZDKAudioDevice;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKAudioEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify upon input volume level changed
*
*  This callback is fired when the audio subsystem detects a change in the input volume settings caused by external factors (for example the
*  user changing the input device volume from the system mixer).
*
*  The rate of this callback is controlled by the delta setting configured by zdkAudioEndpointControl::AudioDeltaLevel().
*
*  \param[in] audioDevice  The audio device
*  \param[in] level  Input level from 0.0 (silent) to 1.0 (full volume)
*
*  \see ZDKAudioDevice
*/
-(void)onInputLevelChange:(id<ZDKAudioDevice>)audioDevice level:(double)level ;
/** \brief Notify upon output volume level changed
*
*  This callback is fired when the audio subsystem detects a change in the output volume settings caused by external factors (for example the
*  user changing the output device volume from the system mixer).
*
*  The rate of this callback is controlled by the delta setting configured by zdkAudioEndpointControl::AudioDeltaLevel().
*
*  \param[in] audioDevice  The audio device
*  \param[in] level  Output level from 0.0 (silent) to 1.0 (full volume)
*
*  \see ZDKAudioDevice
*/
-(void)onOutputLevelChange:(id<ZDKAudioDevice>)audioDevice level:(double)level ;
/** \brief Notify upon Ringing volume level changed
*
*  This callback is fired when the audio subsystem detects a change in the Ringing volume settings caused by external factors (for example the
*  user changing the ring device volume from the system mixer).
*
*  The rate of this callback is controlled by the delta setting configured by zdkAudioEndpointControl::AudioDeltaLevel().
*
*  \param[in] audioDevice  The audio device
*  \param[in] level  Ringing level from 0.0 (silent) to 1.0 (full volume)
*
*  \see ZDKAudioDevice
*/
-(void)onRingLevelChange:(id<ZDKAudioDevice>)audioDevice level:(double)level ;
/** \brief Notify upon input/output sound energy level changed
*
*  This callback is fired when the audio subsystem detects a change in the sound energy levels for the input (microphone) and/or output (speaker)
*  measured in dBm0.
*
*  The sound energy density is measured one and only when there is opened audio device - e.g. during a call or while playing a sound!
*
*  \param[in] inLevel  Input/microphone energy level in dBm0
*  \param[in] outLevel  Output/speaker energy level in dBm0
*/
-(void)onEnergyLevelChange:(double)inLevel outLevel:(double)outLevel ;
/** \brief Notify upon audio device changed its state
*
*  \param[in] audioDevice  The audio device
*  \param[in] deviceState  Audio device state
*
*  \see ZDKAudioDevice, AudioDeviceState
*/
-(void)onDeviceStateChange:(id<ZDKAudioDevice>)audioDevice deviceState:(ZDKAudioDeviceState)deviceState ;
/** \brief An error occurred with an audio device
*
*  An error occurred, usually when attempting to open a device. This is an error coming from the OS API.
*  Audio configuration diagnostic or actual user action is recommended.
*
*  \param[in] audioDevice  The audio device
*  \param[in] deviceState  Audio device state
*
*  \see ZDKAudioDevice, AudioDeviceState
*/
-(void)onDeviceError:(id<ZDKAudioDevice>)audioDevice deviceState:(ZDKAudioDeviceState)deviceState ;
/** \brief An error occurred when trying to open an audio device
*
*  An error occurred when attempting to open an audio device or an internal processing stream. Audio configuration diagnostic or
*  actual user action is recommended.
*
*  \param[in] deviceList  A list of the devices which failed to open
*
*  \see ZDKAudioDevice
*/
-(void)onDeviceOpenError:(NSArray*)deviceList ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
