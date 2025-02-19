# import <Foundation/Foundation.h>

/** \brief Banafo Service error enum
*
*  This enum is used to enumerate all the possible errors a Banafo Service can have.
*/
typedef NS_ENUM(int, ZDKBanafoServiceErrorType)
{

	/** \brief Error occurred while getting well known configuration.
	*/
	bset_WellKnown,

	/** \brief Error occurred while getting or refreshing tokens.
	*/
	bset_AuthorizationToken,

	/** \brief Error occurred while getting a new device code.
	*/
	bset_DeviceCode,

	/** \brief The device code has expired and the device authorization session has concluded.
	*
	* The client MAY commence a new device authorization request but SHOULD wait for user interaction
	* before restarting to avoid unnecessary polling.
	*/
	bset_AuthorizationExpired,

	/** \brief The end user denied the device authorization request.
	*/
	bset_AuthorizationDeny,
};
