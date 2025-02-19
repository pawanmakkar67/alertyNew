# import <Foundation/Foundation.h>

/** \brief Activation status result types
*/
typedef NS_ENUM(int, ZDKActivationStatus)
{

	/** \brief "ok" - cert decrypted and parsed
	*/
	as_Success,

	/** \brief "ok" - cert decrypted but could not parse
	*/
	as_Unparsable,

	/** \brief "ok" - cert could not be decrypted
	*/
	as_FailedDecrypt,

	/** \brief "error"
	*/
	as_Failed,

	/** \brief deadline reached while retrying
	*/
	as_FailedDeadline,

	/** \brief "ok" but checksums don't match
	*/
	as_FailedChecksum,

	/** \brief "ok" but hdd or the mac don't match
	*/
	as_FailedId,

	/** \brief error loading cert from cache and HTTP fallback is unavailable
	*/
	as_FailedCache,

	/** \brief error HTTP connecting to the certificate server
	*/
	as_FailedHttp,

	/** \brief error DNS socket or cURL error while connecting to the certificate server
	*/
	as_FailedCurl,

	/** \brief error while checking the signature
	*/
	as_FailedSignCheck,

	/** \brief error certificate expired
	*/
	as_Expired,

	/** \brief activation not started
	*/
	as_NA,
};
