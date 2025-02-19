# import <Foundation/Foundation.h>

/** \brief Activation CERT server status types
*/
typedef NS_ENUM(int, ZDKSecureCertStatus)
{

	/** \brief Cert + Key usable (validity check is separate)
	*/
	scs_Ok,

	/** \brief Invalid security suite selected
	*/
	scs_InvalidSuite,

	/** \brief Library is not initialized
	*/
	scs_NotInitialized,

	/** \brief File access error (not found or bad permission)
	*/
	scs_FileError,

	/** \brief Unrecognized file format
	*/
	scs_UnknownFormat,

	/** \brief Recognized as PEM but the file is broken or corrupt
	*/
	scs_BrokenPem,

	/** \brief Recognized as PKCS#12 but the file is broken or corrupt
	*/
	scs_BrokenPKCS12,

	/** \brief Was unable to decode the file with the provided password
	*/
	scs_BadPassword,

	/** \brief Has no certificate (maybe it is a key file only?)
	*/
	scs_NoCert,

	/** \brief Has no key (maybe it is a cert file only?)
	*/
	scs_NoKey,

	/** \brief The suite could not load the cert
	*/
	scs_UnusableCert,

	/** \brief The suite could not load the key
	*/
	scs_UnusableKey,

	/** \brief The cert is not paired with the key
	*/
	scs_CertNotPaired,

	/** \brief Confirmation from the user is required before proceeding
	*/
	scs_ResultConfirm,
};
