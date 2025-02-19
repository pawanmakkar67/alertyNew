# import <Foundation/Foundation.h>

/** \brief Audio device states
*/
typedef NS_ENUM(int, ZDKAudioDeviceState)
{

	/** \brief Ready for use (or has been plugged or enabled)
	*/
	ads_Active,

	/** \brief The device has been disabled
	*/
	ads_Disabled,

	/** \brief The device has been removed
	*/
	ads_Unplugged,

	/** \brief The device state is unknown
	*/
	ads_Unknown,
};
