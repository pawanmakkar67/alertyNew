# import <Foundation/Foundation.h>

/** \brief SIP Method types
*
*  \see ZDKHeaderField
*/
typedef NS_ENUM(int, ZDKSipMethodTypes)
{

	/** \brief None - not allowed anywhere
	*/
	smt_None,

	/** \brief SIP ZDKNVITE method
	*/
	smt_Invite,

	/** \brief SIP NOTIFY method
	*/
	smt_Notify,

	/** \brief SIP OPTIONS method
	*/
	smt_Options,

	/** \brief SIP REGISTER method
	*/
	smt_Register,

	/** \brief SIP SUBSCRIBE method
	*/
	smt_Subscribe,

	/** \brief SIP MESSAGE method
	*/
	smt_Message,

	/** \brief SIP ZDKNFO method
	*/
	smt_Info,

	/** \brief SIP PUBLISH method
	*/
	smt_Publish,

	/** \brief SIP SERVICE method
	*/
	smt_Service,

	/** \brief ALL SIP methods
	*/
	smt_All,
};
