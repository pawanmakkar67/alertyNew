# import <Foundation/Foundation.h>

/** \brief ZRTP hash algorithm types
*/
typedef NS_ENUM(int, ZDKZRTPHashAlgorithm)
{

	/** \brief S256 (SHA-256)
	*/
	zrtpha_s256,

	/** \brief S384 (SHA-384)
	*/
	zrtpha_s384,

	/** \brief N256 (SHA-3 256) NOT SUPPORTED YET
	*/
	zrtpha_n256,

	/** \brief N384 (SHA-3 384) NOT SUPPORTED YET
	*/
	zrtpha_n384,
};
