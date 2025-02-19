# import <Foundation/Foundation.h>

/** \brief Audio source recording preset types
*
*  NOTE! Currently used only for Android's OpenSLES and AAudio.
*
*  Audio recording/input preset values taken directly from OpenSLES and AAudio
*/
typedef NS_ENUM(int, ZDKAudioSourcePresetType)
{

	/** \brief Preset "None" cannot be set - it is used to indicate the current settings do not match any of the presets.
	*/
	aspt_None               = 0,

	/** \brief Generic recording configuration on the platform
	*/
	aspt_Generic            = 1,

	/** \brief Uses the mic audio source with the same orientation as the camera if available - the main device mic otherwise
	*/
	aspt_CamCoder           = 2,

	/** \brief Uses the main mic tuned for voice recognition
	*/
	aspt_VoiceRecognition   = 3,

	/** \brief Uses the main mic tuned for audio communications
	*/
	aspt_VoiceCommunication = 4,

	/** \brief Uses the main mic unprocessed (with no effects) - the input will have no AGC (Auto Gain Control) - recorded volume may be very low
	*/
	aspt_Unprocessed        = 5,
};
