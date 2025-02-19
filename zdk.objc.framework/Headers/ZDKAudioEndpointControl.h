//
// ZDKAudioEndpointControl.h
// ZDK
//

#ifndef ZDKAudioEndpointControl_h
#define ZDKAudioEndpointControl_h

#import <Foundation/Foundation.h>
#import "ZDKAudioRoutingEndpoint.h"
#import "ZDKEchoCancellationType.h"
#import "ZDKAudioSourcePresetType.h"
#import "ZDKAudioDevice.h"
#import "ZDKAutomaticGainControlType.h"
#import "ZDKHostAPI.h"
#import "ZDKAudioResampler.h"
#import "ZDKAudioFileFormat.h"
#import "ZDKSound.h"
#import "ZDKAudioOutputDeviceType.h"
#import "ZDKAudioEventsHandler.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKAudioDevice.h"
@protocol ZDKAudioDevice;
#import "ZDKSound.h"
@protocol ZDKSound;
#import "ZDKAudioEventsHandler.h"
@protocol ZDKAudioEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Audio endpoint's main entry point
*
*  Entry point for controlling the audio endpoint
*/
@protocol ZDKAudioEndpointControl <ZDKZHandle>

/** \brief Configures the audio routing endpoint to be used
*
* !!!NOT ZDKMPLEMENTED!!! The ZDK does not provide a mean for controlling the audio routing!
*
*  \param[in] value  The audio routing endpoint
*
*  \see AudioRoutingEndpoint
*/
@property(nonatomic) ZDKAudioRoutingEndpoint  audioEndpoint;

/** \brief Configures the audio input/microphone level
*
*  The volume setting for the input device. Values are between 0.0 (muted) and 1.0 (maximum volume).
*
*  \param[in] value  The volume setting for the input device between 0.0 and 1.0
*
*  \see outputLevel(), ringLevel()
*/
@property(nonatomic) double  micLevel;

/** \brief Configures the audio output level
*
*  The volume setting for the input device. Values are between 0.0 (muted) and 1.0 (maximum volume).
*
*  In many cases the ringing device and the output device are the same, so chaning one level will also change and
*  the other.
*
*  \param[in] value  The volume setting for the output device between 0.0 and 1.0
*
*  \see micLevel(), ringLevel()
*/
@property(nonatomic) double  outputLevel;

/** \brief Configures the audio ringing level
*
*  The volume setting for the ringing device. Values are between 0.0 (muted) and 1.0 (maximum volume).
*
*  In many cases the ringing device and the output device are the same, so chaning one level will also change and
*  the other.
*
*  \param[in] value  The volume setting for the ringing device between 0.0 and 1.0
*
*  \see micLevel(), outputLevel()
*/
@property(nonatomic) double  ringLevel;

/** \brief Configures the acoustic echo cancellation working mode
*
*  Default is enabled in software mode.
*
*  \param[in] value  The acoustic echo cancellation mode
*
*  \see EchoCancellationType
*/
@property(nonatomic) ZDKEchoCancellationType  echoCancellation;

/** \brief Controls the High Pass filter
*
*  Enables or disables the High Pass filter.
*  Works on all platforms.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  highPassFilter;

/** \brief Controls the Pre Amplifier
*
*  Enables or disables the Pre Amplifier which amplifies the input signal before any other porcessing occurs.
*  Works on all platforms.
*
*  The amount of the fixed gain done by the pre amplifier. The gain value is a positive value between 1.f (does
*  nothing) and 49.f db. This value is interpreted as a negative value.
*
*  Disabled by default - less than 1.f!
*
*  \param[in] value  The amount of the fixed gain done by the pre amplifier.
*/
@property(nonatomic) float  preAmplifier;

/** \brief Controls the Noise Suppression filter
*
*  Enables or disables the Noise Suppression filter. Enabled by default.
*  Works on all platforms.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  noiseSuppression;

/** \brief Configures the Audio Source Recorder Preset
*
*  Currently used only for Android's OpenSLES, but this can change in the future.
*
*  \param[in] value  The audio source preset
*
*  \see AudioSourcePresetType
*/
@property(nonatomic) ZDKAudioSourcePresetType  audioSourcePreset;

/** \brief Gets a list with all available audio devices
*
*  \return List with all available audio devices
*
*  \see ZDKAudioDevice
*/
@property(nonatomic, readonly) NSArray<id<ZDKAudioDevice>>*  audioDevices;

/** \brief Controls the microphone boost option
*
*  Enables or disables the microphone boost. On some platforms the boost option is controlled via a text field and
*  this might not work properly.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*/
@property(nonatomic) BOOL  micBoost;

/** \brief Enables or disables the fixed gain on the audio output
*
*  Enable or disable the fixed speaker gain confgured by setfixedSpeakerGain(). By default, the gain is not applied.
*
*  The filter that applies the gain is using a fixed point calculation (multiplication + shift + saturation checks).
*  It should be very fast but you should not enable the gain unless you have set it to something different than 0.0.
*
*  The effect will be immediate. You can call this function at any time after initialization. This means you can
*  enable/disable the gain during a call.
*
*  \param[in] value
*  \li 0 - disable
*  \li 1 - enable
*
*  \see fixedSpeakerGain()
*/
@property(nonatomic) BOOL  enableFixedSpeakerGain;

/** \brief Configures the fixed gain on the audio output
*
*  Configures the gain to be applied when the gain filter is enabled by enableFixedSpeakerGain().
*
*  The gain is expressed in decibels (dB). It can be anything but some values will produce very distorted and loud
*  noise, while others will effectively mute the audio.
*
*  Here are some example values, but please do tests and choose what best suits your case. The precision of the
*  fixed-point calculation is 0.001.
*
*  +20.0 dB: Huge audio boost. Almost certain to produce loud noise unless the input is very quiet. Don't use values above this.
*   +6.0 dB: Moderate boost
*   +2.0 dB: Small boost
*    0.0 dB: No boost
*   -6.0 dB: Moderate decrease in volume. Better use the hardware volume controls.
*   -100 dB: Almost always will produce complete silence.
*
*  If you are familiar with how the audio is processed, here is the filter formula:
*
*  gain(s) = s * 10 ^ ( db / 20.0 )
*
*  Here gain is the gain filter, s is the sample being processed, db is the gain value in dB. We're using the
*  amplitude forumla because of the way PCM is representing the audio.
*
*  As with enableFixedSpeakerGain(), you can call this function at any time after initialization.
*
*  \param[in] value  Gain in dB
*
*  \see enableFixedSpeakerGain()
*/
@property(nonatomic) double  fixedSpeakerGain;

/** \brief Gets the configured Automatic Gain Control (AGC) filter working mode
*
*  Works on all platforms. For Desktop platforms the AGC includes both analog and digital adaptive control by
*  controlling the analog gain for the microphone device. For mobile platforms only an adaptive digital gain is
*  applied to the audio coming from the microphone.
*
*  The GUI is advised to bar the user from manipulating the hardware gain of the microphone. The GUI can also poll
*  the audio input level via micLevel() once or twice a second.
*
*  \return The AGC mode
*
*  \see getAutomaticGainControlGain(), setAutomaticGainControlMode(), AutomaticGainControlType
*/
-(ZDKAutomaticGainControlType)getAutomaticGainControlMode;
/** \brief Gets the configured Automatic Gain Control (AGC) fixed gain
*
*  The additional fixed gain (defaults to 0.f) added when using SoftwareDigitalV2 or SoftwareHybrid mode. It can
*  have values between 0.f and 49.f db. The value is positive but it is interpreted as negative.
*
*  \return The AGC additional fixed gain
*
*  \see getAutomaticGainControlMode(), setAutomaticGainControlMode()
*/
-(float)getAutomaticGainControlGain;
/** \brief Configures the Automatic Gain Control (AGC) filter working mode
*
*  Works on all platforms. For Desktop platforms the AGC includes both analog and digital adaptive control by
*  controlling the analog gain for the microphone device. For mobile platforms only an adaptive digital gain is
*  applied to the audio coming from the microphone.
*
*  The GUI is advised to bar the user from manipulating the hardware gain of the microphone. The GUI can also poll
*  the audio input level via micLevel() once or twice a second.
*
*  \param[in] type  The AGC mode
*  \param[in] gain  The additional fixed gain added when using SoftwareDigitalV2 or SoftwareHybrid mode. It can have
*                   values between 0.f and 49.f db. The value is positive but it is interpreted as negative.
*
*  \return Result of the invocation
*
*  \see getAutomaticGainControlMode(), getAutomaticGainControlGain(), ZDKResult, AutomaticGainControlType
*/
-(id<ZDKResult>)setAutomaticGainControlMode:(ZDKAutomaticGainControlType)type gain:(float)gain ;
/** \brief Configures the audio host API to be used
*
*  \param[in] value  The host API
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)hostApi:(ZDKHostAPI)value ;
/** \brief Configures the audio resampler to be used
*
*  Selects the resampler to be used by the audio engine. In most cases the native sampling rate of the audio
*  hardware will not match the sampling rate of the active VoIP call. In this case a resampler is employed to do
*  sample rate conversion. Different methods produce different quality and use algorithms of different complexity
*  resulting in different CPU usage. In some cases the resampler cannot be selected.
*
*  The default behavior is the audio driver select the reampler.
*
*  \param[in] value  The audio resampler type
*
*  \return Result of the invocation
*
*  \see AudioResampler, ZDKResult
*/
-(id<ZDKResult>)resampler:(ZDKAudioResampler)value ;
/** \brief Gets an audio device with the given name if exists, otherwise - nullptr
*
*  \param[in] name  The name of the audio device to be retrieved
*
*  \return The audio device with the specified name
*
*  \see ZDKAudioDevice
*/
-(id<ZDKAudioDevice> _Nullable)getDeviceByName:(NSString*)name ;
/** \brief Gets the selected input audio device
*
*  \return The currently selected input audio device
*
*  \see ZDKAudioDevice
*/
-(id<ZDKAudioDevice> _Nullable)getCurrentInputDevice;
/** \brief Select the input audio device
*
*  \param[in] device  The input device to be selected
*  \return Result of the selection
*
*  \see ZDKAudioDevice, ZDKResult
*/
-(id<ZDKResult>)setCurrentInputDevice:(id<ZDKAudioDevice>)device ;
/** \brief Gets the selected output audio device
*
*  \return The currently selected output audio device
*
*  \see ZDKAudioDevice
*/
-(id<ZDKAudioDevice> _Nullable)getCurrentOutputDevice;
/** \brief Select the output audio device
*
*  \param[in] device  The output device to be selected
*  \return Result of the selection
*
*  \see ZDKAudioDevice, ZDKResult
*/
-(id<ZDKResult>)setCurrentOutputDevice:(id<ZDKAudioDevice>)device ;
/** \brief Gets the selected ringing audio device
*
*  \return The currently selected ringing audio device
*
*  \see ZDKAudioDevice
*/
-(id<ZDKAudioDevice> _Nullable)getCurrentRingDevice;
/** \brief Select the ringing audio device
*
*  \param[in] device  The ringing device to be selected
*  \return Result of the selection
*
*  \see ZDKAudioDevice, ZDKResult
*/
-(id<ZDKResult>)setCurrentRingDevice:(id<ZDKAudioDevice>)device ;
/** \brief Load a sound from a memory buffer
*
*  Creates a sound structure and copies the provided samples into its buffers.
*
*  While playing the resulting sound through startSound() or startPlayback() it can undergo resampling (to match frequencies) or remixing (to
*  match the channels) based on the current audio settings.
*
*  \param[in] data  The samples to copy
*  \param[in] length  Size of the data to be coppied in bytes
*  \param[in] sampleLen  Size of a sample in bytes (must be 2)
*  \param[in] frequency  Frequency of the sound in Hz (must be 8000)
*  \param[in] repeat  1/TRUE if the sound should be looped when played
*  \param[in] pauseMs  If the sound is to be looped, the amount of silence in milliseconds between each loop
*
*  \return The newly loaded sound or NULL in case of error
*
*  \see ZDKSound, AudioFileFormat, addSoundFromFile()
*/
-(id<ZDKSound> _Nullable)addSoundFromMemory:(unsigned char*)data length:(int)length sampleLen:(int)sampleLen frequency:(int)frequency repeat:(BOOL)repeat pauseMs:(int)pauseMs ;
/** \brief Load a sound from a file
*
*  Loads a sound from a file. The sound will inherit the file's format with the only exception that 8-bit, 24-bit and 32-bit PCM samples will be
*  automatically converted to 16-bit while the sound is being loaded.
*
*  The frequency and channel count will be left unchanged.
*
*  While playing the resulting sound through startSound() or startPlayback() it can undergo resampling (to match frequencies) or remixing (to
*  match the channels) based on the current audio settings.
*
*  \param[in] filePath  Name of the file to load from, UTF-8
*  \param[in] fileFormat  Type of the file to load from - !!!currently limited only to WAV!!!
*  \param[in] repeat  1/TRUE if the sound should be looped when played
*  \param[in] pauseMs  If the sound is to be looped, the amount of silence in milliseconds between each loop
*
*  \return The newly loaded sound or NULL in case of error
*
*  \see ZDKSound, AudioFileFormat, addSoundFromMemory()
*/
-(id<ZDKSound> _Nullable)addSoundFromFile:(NSString*)filePath fileFormat:(ZDKAudioFileFormat)fileFormat repeat:(BOOL)repeat pauseMs:(int)pauseMs ;
/** \brief Start playback of a sound
*
*  Start playing the sound on one of the two output devices (either the selected output device or the selected ringing device). Use
*  setCurrentOutputDevice() and setCurrentRingDevice() to select the output devices. The sound will be played on the device and will not be sent
*  over the communication channel (see startPlayback()).
*
*  \param[in] sound  The sound to be played
*  \param[in] outputType  The output device to play the sound
*
*  \return Result of the playback
*
*  \see setCurrentOutputDevice(), setCurrentRingDevice(), addSoundFromFile(), addSoundFromMemory(), stopSound(), startPlayback()
*/
-(id<ZDKResult>)startSound:(id<ZDKSound>)sound outputType:(ZDKAudioOutputDeviceType)outputType ;
/** \brief Stops playback of a sound
*
*  Stops playing the sound. Must be called with the same parameters as startSound().
*
*  \param[in] sound  Sound to stop playing
*  \param[in] outputType  The output device to play the sound
*
*  \return Result of the stop
*
*  \see startSound()
*/
-(id<ZDKResult>)stopSound:(id<ZDKSound>)sound outputType:(ZDKAudioOutputDeviceType)outputType ;
/** \brief Starts playback over the current call
*
*  Starts playing back the sound to the remote peer(s) (if there are active calls) instead of the microphone input. Microphone input will be
*  discared during the playback. Optionally plays the sound on the output/ringing device (this is the "monitor" device). When the whole sound
*  has been played out the microphone will be reconnected again. All changes made to the microphone during the playback will be applied after
*  normal operation has been resumed.
*
*  \param[in] sound  The sound to play over the network
*  \param[in] monitorDevice  Monitoring device - optional local output device to play the sound
*
*  \return Result of the playback
*
*  \see startSound(), stopPlayback()
*/
-(id<ZDKResult>)startPlayback:(id<ZDKSound>)sound monitorDevice:(ZDKAudioOutputDeviceType)monitorDevice ;
/** \brief Stops any playback
*
*  Stops any playback and monitored sound immediately if there is such.
*
*  \return Result of the stop
*
*  \see startPlayback()
*/
-(id<ZDKResult>)stopPlayback;
/** \brief Sets the sound to be played over the current call on every recording start
*
*  Sets the sound to be played back to the remote peer(s) (instead of the microphone input) on every start of call recording. (The sound must be
*  added beforehand with addSoundFromFile() or addSoundFromMemory()). Optionally plays the sound on the output/ringing device (this is the "monitor" device).
*
*  When the whole sound has been played out the microphone will be reconnected again.
*
*  All changes made to the microphone during the playback will be applied after normal operation has been resumed.
*
*  \param[in] sound  The sound to play over the network
*  \param[in] monitorDevice  Monitoring device
*
*  \return Result of the setting
*
*  \see addSoundFromFile(), addSoundFromMemory(), startPlayback(), stopPlayback()
*/
-(id<ZDKResult>)setCallRecordingNotifySound:(id<ZDKSound>)sound monitorDevice:(ZDKAudioOutputDeviceType)monitorDevice ;
/** \brief Mute or unmute the input device/microphone
*
*  \param[in] value
*  \li 0 - unmute
*  \li 1 - mute
*
*  \return Result of the mute
*
*  \see muteOutput()
*/
-(id<ZDKResult>)muteInput:(BOOL)value ;
/** \brief Mute or unmute the output device/speaker
*
*  \param[in] value
*  \li 0 - unmute
*  \li 1 - mute
*
*  \return Result of the mute
*
*  \see muteOutput()
*/
-(id<ZDKResult>)muteOutput:(BOOL)value ;
/** \brief Adds audio events listener
*
*  \param[in] value  The audio events handler
*
*  \see ZDKAudioEventsHandler
*/
-(void)addStatusListener:(id<ZDKAudioEventsHandler>)value ;
/** \brief Drops audio events listener
*
*  \param[in] value  The audio events handler
*
*  \see ZDKAudioEventsHandler
*/
-(void)dropStatusListener:(id<ZDKAudioEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
