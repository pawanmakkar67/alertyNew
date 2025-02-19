# import <Foundation/Foundation.h>

/** \brief The contact presence state types
*/
typedef NS_ENUM(int, ZDKContactStateType)
{

	/** \brief The contact is offline
	*/
	cst_Offline = 0,

	/** \brief The contact is online
	*/
	cst_Online,

	/** \brief The contact state is not known
	*/
	cst_Unknown,
};
