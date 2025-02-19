# import <Foundation/Foundation.h>

/** \brief Banafo Service request state enum
*
*  This enum is used to enumerate all the possible states a Banafo Service request can have.
*/
typedef NS_ENUM(int, ZDKBanafoRequestStateType)
{

	/** \brief The request is being processed.
	*/
	brst_InProgress,

	/** \brief The request is finished successfully.
	*/
	brst_Finished,

	/** \brief The request is canceled by the user.
	*/
	brst_Canceled,

	/** \brief The request is finished with network error.
	*/
	brst_NetworkError,

	/** \brief The request is finished with error.
	*/
	brst_Error,
};
