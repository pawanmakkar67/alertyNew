# import <Foundation/Foundation.h>

/** \brief AudioResampler types
*
*  Audio resampler is used when the device's native frequency difference from the used codec one.
*
*  Different resamplers produce different quality and CPU usage.
*/
typedef NS_ENUM(int, ZDKAudioResampler)
{

	/** \brief No preference - use default configuration
	*/
	ar_Default,

	/** \brief Use internal resampler implementation - good quality and high CPU usage
	*/
	ar_Internal,

	/** \brief Use iOS resampler
	*/
	ar_iPhone,

	/** \brief Use Speex library resampler - good quality and medium CPU usage
	*/
	ar_Speex,

	/** \brief Use WebRTC resamplers - low quality and low CPU usage
	*/
	ar_Webrtc,
};
