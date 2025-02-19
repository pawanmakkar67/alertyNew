# import <Foundation/Foundation.h>

/** \brief SIP Session Timer Mode as described in RFC-4028
*/
typedef NS_ENUM(int, ZDKSessionTimerModeType)
{

	/** \brief User Agent Client (Caller) should do the refreshes
	*/
	stmt_UAC,

	/** \brief User Agent Server (Callee) should do the refreshes
	*/
	stmt_UAS,

	/** \brief The local peer (we) should do the refreshes (changes depending on call type)
	*/
	stmt_Local,

	/** \brief The remote peer (they) should do the refreshes (also changes depending on call type)
	*/
	stmt_Remote,

	/** \brief Do not offer session expiry
	*/
	stmt_Disabled,
};
