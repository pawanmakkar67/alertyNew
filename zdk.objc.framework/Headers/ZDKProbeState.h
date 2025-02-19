# import <Foundation/Foundation.h>

/** \brief State of the transport probing
*/
typedef NS_ENUM(int, ZDKProbeState)
{

	/** \brief Invalid - information not available
	*/
	ps_Unknown,

	/** \brief Checking the configuration
	*/
	ps_Config,

	/** \brief Probing for TLS transport
	*/
	ps_Tls,

	/** \brief Probing for TCP transport
	*/
	ps_Tcp,

	/** \brief Probing for UDP transport
	*/
	ps_Udp,
};
