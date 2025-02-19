# import <Foundation/Foundation.h>

/** \brief Call's DTMF type
*/
typedef NS_ENUM(int, ZDKDTMFType)
{

	/** \brief Not set/information not available
	*/
	dtmft_NA,

	/** \brief DTMF sent as RTP samples over the audio media channel
	*/
	dtmft_MediaInband,

	/** \brief DTMF sent as RTP tel-event for SIP and as DTMF packet for ZDKAX2
	*/
	dtmft_MediaOutband,

	/** \brief DTMF sent as SIP ZDKNFO message for SIP and the same as MediaOutband for ZDKAX2
	*/
	dtmft_SignallingOutband,

	/** \brief DTMF are not available/can not be sent
	*/
	dtmft_Disabled,
};
