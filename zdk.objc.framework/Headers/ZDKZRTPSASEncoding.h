# import <Foundation/Foundation.h>

/** \brief ZRTP SAS encoding types
*/
typedef NS_ENUM(int, ZDKZRTPSASEncoding)
{

	/** \brief B32 (Base-32 Short Authentication String encoding)
	*/
	zrtpsase_sasb32,

	/** \brief B256 (Base-256 (PGP Wordlist) Short Authentication String encoding)
	*/
	zrtpsase_sasb256,
};
