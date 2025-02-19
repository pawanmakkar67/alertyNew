# import <Foundation/Foundation.h>

/** \brief Account registration status
*/
typedef NS_ENUM(int, ZDKAccountStatus)
{

	/** \brief The account is not registered. There is no binding on the server.
	*/
	as_None,

	/** \brief The account registration is in process.
	*/
	as_Registering,

	/** \brief The account is registered. There is an active binding on the server.
	*/
	as_Registered,

	/** \brief The account has successfully unregistered from the server. The binding has been dropped.
	*/
	as_Unregistered,

	/** \brief The account has failed to register to the server. There is no binding.
	*/
	as_Failure,

	/** \brief The account unregistration is in process.
	*/
	as_Unregistering,
};
