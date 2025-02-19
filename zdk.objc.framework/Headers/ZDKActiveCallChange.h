# import <Foundation/Foundation.h>

/** \brief Use this enum to control what to do with other currently active calls.
*/
typedef NS_ENUM(int, ZDKActiveCallChange)
{

	/** \brief Holds all other active calls
	*
	*  Holds all other calls and prevent audio mixing.
	*
	*  This should be the default behaviour.
	*/
	acc_HoldOthers,

	/** \brief Do not do anything with all other active calls
	*
	*  Leaves all other calls untouched and leads to mix their audio.
	*/
	acc_DoNothing,
};
