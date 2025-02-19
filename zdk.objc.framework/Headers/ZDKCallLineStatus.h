# import <Foundation/Foundation.h>

/** \brief State of the call
*/
typedef NS_ENUM(int, ZDKCallLineStatus)
{

	/** \brief Invalid - information not available
	*/
	cls_NA,

	/** \brief The call is in preparation state - the peer is not yet notified for its presence
	*/
	cls_Dialing,

	/** \brief The call has failed
	*/
	cls_Failed,

	/** \brief Ringing - the peer is notified for the call and is waited of action
	*/
	cls_Ringing,

	/** \brief The call is established
	*/
	cls_Active,

	/** \brief The call is put on hold
	*/
	cls_Held,

	/** \brief The call is in early media state
	*/
	cls_EarlyMedia,

	/** \brief The call is terminated/disconnected
	*/
	cls_Terminated,
};
