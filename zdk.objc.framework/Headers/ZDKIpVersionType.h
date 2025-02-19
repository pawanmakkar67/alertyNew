# import <Foundation/Foundation.h>

/** \brief IP version preference enum
*
*  This enum is used to select between the available IP versions.
*/
typedef NS_ENUM(int, ZDKIpVersionType)
{

	/** \brief Automatically select the fastest-connecting IP version
	*/
	ivt_Automatic,

	/** \brief Prefer ZDKPv4
	*/
	ivt_IPv4,

	/** \brief Prefer ZDKPv6
	*/
	ivt_IPv6,
};
