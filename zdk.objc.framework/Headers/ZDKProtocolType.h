# import <Foundation/Foundation.h>

/** \brief Communication protocol type
*/
typedef NS_ENUM(int, ZDKProtocolType)
{

	/** \brief Session Initiation Protocol (SIP)
	*/
	pt_SIP,

	/** \brief Inter-Asterisk eXchange (IAX)
	*/
	pt_IAX,

	/** \brief Extensible Messaging and Presence Protocol (XMPP)
	*/
	pt_XMPP,

	/** \brief Real Time Streaming Protocol (RTSP)
	*/
	pt_RTSP,

	/** \brief Invalid - information not available
	*/
	pt_Unknown = 255,
};
