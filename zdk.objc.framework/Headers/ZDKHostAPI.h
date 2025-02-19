# import <Foundation/Foundation.h>

/** \brief Native platform audio host API types
*/
typedef NS_ENUM(int, ZDKHostAPI)
{

	/** \brief Invalid - information not available
	*/
	hapi_NA,

	/** \brief Windows Multimedia Extensions (MME) - deprecated!
	*/
	hapi_WMME,

	/** \brief Windows Audio Session API (WASAPI)
	*/
	hapi_WASAPI,

	/** \brief PulseAudio is a sound server for desktop use commonly used on Linux systems
	*/
	hapi_Pulse,

	/** \brief Core Audio is a low-level API for dealing with sound in Apple's macOS and iOS operating systems
	*/
	hapi_CoreAudio,

	/** \brief Open Sound Library for Embedded Systems (OpenSL ES) is a cross-platformand hardware-accelerated audio
	*  API for 2D and 3D audio on Android
	*/
	hapi_OpenSLES,

	/** \brief AAudio is an audio API introduced in the Android 8.0 release
	*/
	hapi_AAudio,
};
