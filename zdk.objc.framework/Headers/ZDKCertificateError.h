# import <Foundation/Foundation.h>

/** \brief Certificate verification error types
*
*  Used as a bit-field in zdkSecureCertData::errorMask()
*/
typedef NS_ENUM(int, ZDKCertificateError)
{

	/** \brief All is OK
	*/
	ce_None,

	/** \brief Issuer untrusted/not found/not valid/wrong purpose
	*/
	ce_Issuer,

	/** \brief Peer certificate broken (wrong Signature/Public Key/Purpose)
	*/
	ce_Cert,

	/** \brief Certificate not yet valid or already expired
	*/
	ce_Date,

	/** \brief Certificate was revoked or rejected
	*/
	ce_Revoked,

	/** \brief Internal or other unrecognized error--ask for debug log...
	*/
	ce_Internal,

	/** \brief Certificate names mismatch
	*/
	ce_Name,
};
