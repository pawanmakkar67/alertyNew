# import <Foundation/Foundation.h>

/** \brief Type of call ownership change
*/
typedef NS_ENUM(int, ZDKOwnershipChange)
{

	/** \brief Invalid - information not available
	*/
	oc_NA,

	/** \brief Relieve the call
	*/
	oc_Relieve,

	/** \brief Acquire the call
	*/
	oc_Acquire,
};
