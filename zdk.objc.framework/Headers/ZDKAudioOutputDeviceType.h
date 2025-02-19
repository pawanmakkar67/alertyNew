# import <Foundation/Foundation.h>

/** \brief Audio output device types
*/
typedef NS_ENUM(int, ZDKAudioOutputDeviceType)
{

	/** \brief Use the normal output device
	*/
	aodt_Normal,

	/** \brief Use the ringing output device
	*/
	aodt_Ringing,

	/** \brief Disable output
	*/
	aodt_Disable,
};
