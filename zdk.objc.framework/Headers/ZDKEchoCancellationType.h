# import <Foundation/Foundation.h>

/** \brief Type of the used echo cancellation
*/
typedef NS_ENUM(int, ZDKEchoCancellationType)
{

	/** \brief Disable echo cancellation. Neither software nor hardware/system cancellation will be used.
	*/
	ect_Off,

	/** \brief Enable software echo cancellation. Works on all platforms!
	*/
	ect_Software,

	/** \brief Enable hardware/system echo cancellation. Works only on iOS and has no effect on all other platforms!
	*/
	ect_Hardware,
};
