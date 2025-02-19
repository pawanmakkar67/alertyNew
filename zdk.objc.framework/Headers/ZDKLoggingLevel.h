# import <Foundation/Foundation.h>

/** \brief Debug logging levels
*/
typedef NS_ENUM(int, ZDKLoggingLevel)
{

	/** \brief Disable the debug logging
	*/
	ll_None = 0,

	/** \brief Log only Critical debug messages
	*/
	ll_Critical,

	/** \brief Log only Error and higher priority debug messages - Critical
	*/
	ll_Error,

	/** \brief Log only Warning and higher priority debug messages - Critical/Error
	*/
	ll_Warning,

	/** \brief Log only Info and higher priority debug messages - Critical/Error/Warning
	*/
	ll_Info,

	/** \brief Log only Debug and higher priority debug messages - Critical/Error/Warning/Info
	*/
	ll_Debug,

	/** \brief Log all Stack and higher priority debug messages - Critical/Error/Warning/Info/Debug
	*/
	ll_Stack,
};
