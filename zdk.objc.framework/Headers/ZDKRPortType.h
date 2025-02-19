# import <Foundation/Foundation.h>

/** \brief RPort usage types
*
*  Used to discover the public address and port in case there is a NAT between the user and the server. It also
*  helps for normal unfirewalled TCP and TLS connections (highly recommended for these two protocols).
*
*  If rport is enabled along with STUN, STUN will be preferred.
*/
typedef NS_ENUM(int, ZDKRPortType)
{

	/** \brief Do not use RPort
	*/
	rpt_No,

	/** \brief Enables usage of RPort discovered public address for signaling negotiations
	*/
	rpt_Signaling,

	/** \brief Enables usage of RPort discovered public address for both signaling and media negotiations.
	*
	*  This option is NOT recommended. Enable it only if you absolutely know what you're doing.
	*/
	rpt_SignalingAndMedia,
};
