# import <Foundation/Foundation.h>

/** \brief ZRTP Authentication tag types
*/
typedef NS_ENUM(int, ZDKZRTPAuthTag)
{

	/** \brief HS32 (HMAC-SHA1 with 32-bit tag)
	*/
	zrtpat_hs32,

	/** \brief HS80 (HMAC-SHA1 with 80-bit tag)
	*/
	zrtpat_hs80,

	/** \brief SK32 (Skein-512-Mac with 32-bit tag) NOT SUPPORTED (complicated+)
	*/
	zrtpat_sk32,

	/** \brief SK64 (Skein-512-Mac with 64-bit tag) NOT SUPPORTED (complicated+)
	*/
	zrtpat_sk64,
};
