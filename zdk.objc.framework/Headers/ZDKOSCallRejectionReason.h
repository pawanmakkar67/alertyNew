# import <Foundation/Foundation.h>

/** \brief OS call rejection reasons
*/
typedef NS_ENUM(int, ZDKOSCallRejectionReason)
{

	/** \brief Invalid - information not available
	*/
	oscrr_NA,

	/** \brief User ignored the call
	*/
	oscrr_UserIgnored,

	/** \brief Request timed out
	*/
	oscrr_TimedOut,

	/** \brief There is a concurrent incoming call
	*/
	oscrr_OtherIncomingCall,

	/** \brief There is an ongoing emergency call
	*/
	oscrr_EmergencyCallExists,

	/** \brief The call is in invalid state
	*/
	oscrr_InvalidCallState,
};
