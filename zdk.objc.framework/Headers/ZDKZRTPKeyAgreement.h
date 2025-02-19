# import <Foundation/Foundation.h>

/** \brief ZRTP key agreement types
*/
typedef NS_ENUM(int, ZDKZRTPKeyAgreement)
{

	/** \brief DH3k (Finite-Field Diffie-Hellman with 3072-bit prime)
	*/
	zrtpka_dh3k,

	/** \brief DH2k (Finite-Field Diffie-Hellman with 2048-bit prime)
	*/
	zrtpka_dh2k,

	/** \brief EC25 (Elliptic Curve Diffie-Hellman with 256-bit prime)
	*/
	zrtpka_ec25,

	/** \brief EC38 (Elliptic Curve Diffie-Hellman with 384-bit prime)
	*/
	zrtpka_ec38,

	/** \brief PRSH (Preshared) NOT SUPPORTED
	*/
	zrtpka_prsh,

	/** \brief MULT (Multistream) AUTOMATIC! DO NOT CONFIGURE! NOT SUPPORTED
	*/
	zrtpka_mult,
};
