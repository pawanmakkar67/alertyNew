# import <Foundation/Foundation.h>

/** \brief Contact type enum
*
*  This enum is used to enumerate all the contact types.
*/
typedef NS_ENUM(int, ZDKContactType)
{

	/** \brief Contact.
	*/
	ct_Contact,

	/** \brief Lead.
	*/
	ct_Lead,

	/** \brief Account.
	*/
	ct_Account,

	/** \brief Opportunity
	*/
	ct_Opportunity,

	/** \brief Unknown
	*/
	ct_Unknown,
};
