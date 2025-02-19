# import <Foundation/Foundation.h>

/** \brief Error layer types
*/
typedef NS_ENUM(int, ZDKLayerType)
{

	/** \brief Invalid - information not available
	*/
	lt_Unknown,

	/** \brief Wrapper internal layer
	*/
	lt_Wrapper,

	/** \brief SIP local layer
	*/
	lt_SIPLocal,

	/** \brief SIP layer
	*/
	lt_SIP,

	/** \brief IAX local layer
	*/
	lt_IAXLocal,

	/** \brief IAX layer
	*/
	lt_IAX,

	/** \brief RTSP layer
	*/
	lt_RTSPLocal = 6,

	/** \brief RTSP layer
	*/
	lt_RTSP,

	/** \brief ZRTP local layer
	*/
	lt_ZRTPLocal,

	/** \brief ZRTP layer
	*/
	lt_ZRTP,

	/** \brief MSRP local layer
	*/
	lt_MSRPLocal,

	/** \brief MSRP layer
	*/
	lt_MSRP,

	/** \brief HTTP layer
	*/
	lt_HTTP,

	/** \brief APIDispatche layer
	*/
	lt_APIDispatche,

	/** \brief Activation layer
	*/
	lt_Activation,

	/** \brief Application layer
	*/
	lt_Application,
};
