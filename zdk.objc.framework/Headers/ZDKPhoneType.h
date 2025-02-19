# import <Foundation/Foundation.h>

/** \brief Phone type enum
*
*  This enum is used to enumerate all the phone types.
*/
typedef NS_ENUM(int, ZDKPhoneType)
{

	/** \brief Assistant.
	*/
	pt_Assistant,

	/** \brief Mobile.
	*/
	pt_Mobile,

	/** \brief Other.
	*/
	pt_Other,

	/** \brief Phone
	*/
	pt_Phone,

	/** \brief Home
	*/
	pt_Home,

	/** \brief Fax
	*/
	pt_Fax,

	/** \brief IP Phone
	*/
	pt_IPPhone,

	/** \brief Unknown type
	*/
	pt_Undefined,
};
