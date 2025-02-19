# import <Foundation/Foundation.h>

/** \brief Type of the transport
*/
typedef NS_ENUM(int, ZDKTransportType)
{

	/** \brief Invalid - information not available
	*/
	tt_NA,

	/** \brief User Datagram Protocol (UDP)
	*/
	tt_UDP,

	/** \brief Transmission Control Protocol (TCP)
	*/
	tt_TCP,

	/** \brief Transport Layer Security (TLS)
	*/
	tt_TLS,
};
