# import <Foundation/Foundation.h>

/** \brief Proxy protocol types
*/
typedef NS_ENUM(int, ZDKProxyProtocolType)
{

	/** \brief Hypertext Transfer Protocol (HTTP)
	*/
	ppt_HTTP,

	/** \brief Hypertext Transfer Protocol Secure (HTTPS)
	*/
	ppt_HTTPS,

	/** \brief File Transfer Protocol (FTP)
	*/
	ppt_FTP,

	/** \brief A proxy for all supported protocols that will be used in case no protocol-specific proxy is available
	*/
	ppt_All,
};
