# import <Foundation/Foundation.h>

/** \brief Type of messages
*/
typedef NS_ENUM(int, ZDKMessageType)
{

	/** \brief Invalid - information not available
	*/
	mt_NA,

	/** \brief SIP Simple message
	*/
	mt_Simple,

	/** \brief Message Session Relay Protocol (MSRP) message
	*/
	mt_MSRP,

	/** \brief Extensible Messaging and Presence Protocol (XMPP)
	*/
	mt_XMPP,
};
