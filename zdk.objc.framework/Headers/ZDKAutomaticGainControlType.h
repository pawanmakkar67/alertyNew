# import <Foundation/Foundation.h>

/** \brief Automatic Gain Control (AGC) types
*/
typedef NS_ENUM(int, ZDKAutomaticGainControlType)
{

	/** \brief Disable Automatic Gain Control. Neither software nor hardware/system gain will be used.
	*/
	agct_Off,

	/** \brief An adaptive analog gain controler which controls the gain by manipulating the volume control of the
	*  hardware mixer. It is advised to limit the user from changing the volume.
	*
	*  If the volume control cannot be manipulated the SoftwareDigitalV1 is used instead automatically.
	*/
	agct_SoftwareAnalog,

	/** \brief An adaptive digital gain controler. It cannot apply additional fixed gain and the gain parameter is not
	*          takin into account.
	*/
	agct_SoftwareDigitalV1,

	/** \brief This is a more modern adaptive gain controller that is changing the gain only digitally.
	*          It can apply additional fixed gain taken from the gain parameter.
	*/
	agct_SoftwareDigitalV2,

	/** \brief This is a combination of SoftwareAnalog and SoftwareDigitalV2 modes.
	*/
	agct_SoftwareHybrid,

	/** \brief Enable hardware/system Automatic Gain Control. Works only on iOS and has no effect on all other platforms!
	*/
	agct_Hardware,
};
