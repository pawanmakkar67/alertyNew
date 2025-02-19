# import <Foundation/Foundation.h>

/** \brief API invocation status result
*
*  Indicates the status result of API's invocation
*/
typedef NS_ENUM(int, ZDKResultCode)
{

	/** \brief Success
	*/
	rc_Ok = 0,

	/** \brief General failure
	*/
	rc_Failure,

	/** \brief One or more of the supplied arguments is invalid
	*/
	rc_InvalidArgument,

	/** \brief Not enough memory
	*/
	rc_NoMemory,

	/** \brief Searched item not found
	*/
	rc_NotFound,

	/** \brief Requested feature is not supported
	*/
	rc_Unsupported,

	/** \brief ZDK is not activated
	*/
	rc_NotActivated,

	/** \brief ZDK is not initialized
	*/
	rc_NotInitialized,

	/** \brief Count of all ResultCode values
	*/
	rc_Count,
};
