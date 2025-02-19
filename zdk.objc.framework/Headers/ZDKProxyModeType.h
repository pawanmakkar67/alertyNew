# import <Foundation/Foundation.h>

/** \brief Proxy mode types
*/
typedef NS_ENUM(int, ZDKProxyModeType)
{

	/** \brief No mode - do not use proxy
	*/
	pmt_None,

	/** \brief Envirenment/System settings
	*/
	pmt_Envirenment,

	/** \brief Custom proxy settings
	*/
	pmt_Custom,
};
