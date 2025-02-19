# import <Foundation/Foundation.h>

/** \brief The contact subscription rejection types
*/
typedef NS_ENUM(int, ZDKRejectionType)
{

	/** \brief User driven rejection
	*/
	rt_Reject = 0,

	/** \brief The subscription is deactivated
	*/
	rt_Deactivated,

	/** \brief The rejection reason is not known
	*/
	rt_Unknown,
};
