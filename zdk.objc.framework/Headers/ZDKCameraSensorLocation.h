# import <Foundation/Foundation.h>

/** \brief Location of the active camera
*/
typedef NS_ENUM(int, ZDKCameraSensorLocation)
{

	/** \brief Information not available
	*/
	csl_NA,

	/** \brief The back camera
	*/
	csl_Back,

	/** \brief The front camera
	*/
	csl_Front,
};
