# import <Foundation/Foundation.h>

/** \brief Activation flags used to adjust the activation procedure for different platforms and conditions.
*
*  !NOTE! This is a bit-field!
*
*  !NOTE! For Zoiper internal use only! For SDK builds the activation flags are handled internally!
*/
typedef NS_ENUM(int, ZDKActivationFlags)
{

	/** \brief No special activation instructions
	*/
	af_None                     = 0x00,

	/** \brief Used to be CheckCacheOnly but it is already deprecated and has no effect
	*/
	af_Reserved1                = 0x01,

	/** \brief Do not require checksum verification. Useful for platforms where calculating ZDK checksum is not possible as Android iOS and .NET
	*/
	af_SkipChecksumVerification = 0x02,

	/** \brief This flag is used when we want to check the server only without checking the cache. It is useful for revoking certificates for example
	*/
	af_CheckOnlineOnly          = 0x04,

	/** \brief Used to be UseV3Certificate but the ZDK works only with V4 certificates
	*/
	af_Reserved2                = 0x08,

	/** \brief This flag is used when we want to check against an URL that uses proper signing and returns V2 XML data
	*/
	af_UseV4Certificate         = 0x10,

	/** \brief zdkContextEventsHandler::OnContextActivationCompleted() will be fired after the online check is done
	*/
	af_WaitToComplete           = 0x20,
};
