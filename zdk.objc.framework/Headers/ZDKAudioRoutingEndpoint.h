# import <Foundation/Foundation.h>

/** \brief Audio routing endpoint types
*
*  The types of audio endpoints can be used to route the audio streams to.
*/
typedef NS_ENUM(int, ZDKAudioRoutingEndpoint)
{

	/** \brief The audio is routed to the system's default endpoint
	*/
	are_Default,

	/** \brief The audio is routed to the earpiece endpoint
	*/
	are_Earpiece,

	/** \brief The audio is routed to the speakerphone/loud speaker endpoint
	*/
	are_Speakerphone,

	/** \brief The audio is routed to the bluetooth device endpoint
	*/
	are_Bluetooth,

	/** \brief The audio is routed to the bluetooth device endpoint with enabled noise and echo cancelation
	*/
	are_BluetoothWithNoiseAndEchoCancellation,

	/** \brief The audio is routed to the wired headset device endpoint
	*/
	are_WiredHeadset,

	/** \brief The audio is routed to the wired headset device endpoint having only loud speaker/speakerphone
	*/
	are_WiredHeadsetSpeakerOnly,
};
