# import <Foundation/Foundation.h>

/** \brief Call's security level types
*
*  Indicates what is the current security level of the call
*/
typedef NS_ENUM(int, ZDKCallSecurityLevel)
{

	/** \brief The call has no security at all (red)
	*/
	csl_None,

	/** \brief ZRTP was used to establish an encrypted channel but we need to confirm the SAS (orange)
	*/
	csl_ZrtpUnconfirmed,

	/** \brief The call is protected by SRTP which was configured by ZRTP and confirmed by the user (green)
	*/
	csl_ZrtpSrtp,

	/** \brief The call is protected by SRTP which was configured by SDES and depends on the security level of the SIP/TLS channel (blue)
	*/
	csl_SdesSrtp,
};
