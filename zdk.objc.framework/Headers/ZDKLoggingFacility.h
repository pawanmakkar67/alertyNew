# import <Foundation/Foundation.h>

/** \brief Debug logging facility types
*
*  Using different logging facilities easy looking through the produced debug logs
*/
typedef NS_ENUM(int, ZDKLoggingFacility)
{

	/** \brief Library internal
	*/
	lf_Library = 0,

	/** \brief ZDK internal
	*/
	lf_ZDK,

	/** \brief User Interface (UI)
	*/
	lf_UI,

	/** \brief Network layer
	*/
	lf_Network,

	/** \brief Provisioning layer
	*/
	lf_Provisioning,

	/** \brief Softphone layer
	*/
	lf_Softphone,

	/** \brief Audio layer
	*/
	lf_Audio,

	/** \brief Configuration layer
	*/
	lf_Configuration,

	/** \brief Contacts layer
	*/
	lf_Contacts,

	/** \brief Utility layer
	*/
	lf_Utility,

	/** \brief Persistence layer
	*/
	lf_Persistence,
};
