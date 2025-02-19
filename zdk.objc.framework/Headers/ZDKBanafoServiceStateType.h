# import <Foundation/Foundation.h>

/** \brief Banafo Service state enum
*
*   This enum is used to enumerate all the possible states a Banafo Service can have.
*/
typedef NS_ENUM(int, ZDKBanafoServiceStateType)
{

	/** \brief The service is getting its well known configuration. No requests can be added to the service in this
	*  state. No new requests can be added to the service in this state.
	*/
	bsst_Configuring,

	/** \brief The service is in ready state but it is not authorized yet. In this state the user can set access and
	*  refresh tokens or start the authorization process. No new requests can be added to the service in this state.
	*/
	bsst_Ready,

	/** \brief The service is waiting for the end user to verify the authorization on Banafo web site. This is the
	*  second stage of the authorization process. The user may only cancel the authorization in this state. No new
	*  requests can be added to the service in this state.
	*/
	bsst_VerifyingAuthorizing,

	/** \brief The service is ready and authorized. The user may add new requests to the service.
	*/
	bsst_Authorized,

	/** \brief The service has experienced a network error. No requests can be added to the service in this state.
	*/
	bsst_NetworkError,

	/** \brief The service has experienced a Banafo error i.e. the Banafo server has returned an error. No requests can
	*  be added to the service in this state.
	*/
	bsst_Error,
};
