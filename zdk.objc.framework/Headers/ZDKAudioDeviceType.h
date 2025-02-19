# import <Foundation/Foundation.h>

/** \brief Audio device types
*/
typedef NS_ENUM(int, ZDKAudioDeviceType)
{

	/** \brief Input device (microphone)
	*/
	adt_Input,

	/** \brief Output device (speaker or headset)
	*/
	adt_Output,

	/** \brief The device supports both input AND output
	*/
	adt_InputAndOutput,

	/** \brief The device type is unknown - the device does not support neither input nor output
	*/
	adt_Unknown,
};
