# import <Foundation/Foundation.h>

/** \brief ZRTP Cipher algorithm types
*/
typedef NS_ENUM(int, ZDKZRTPCipherAlgorithm)
{

	/** \brief AES1 (AES-128 in CFB mode with 128 bit feedback)
	*/
	zrtpca_cipher_aes1,

	/** \brief AES2 (AES-192 in CFB-128 mode)
	*/
	zrtpca_cipher_aes2,

	/** \brief AES3 (AES-256 in CFB-128 mode)
	*/
	zrtpca_cipher_aes3,

	/** \brief 2FS1 (TwoFish-128) NOT SUPPORTED YET
	*/
	zrtpca_cipher_2fs1,

	/** \brief 2FS2 (TwoFish-192) NOT SUPPORTED YET
	*/
	zrtpca_cipher_2fs2,

	/** \brief 2FS3 (TwoFish-256) NOT SUPPORTED YET
	*/
	zrtpca_cipher_2fs3,
};
