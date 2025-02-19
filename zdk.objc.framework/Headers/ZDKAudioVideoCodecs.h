# import <Foundation/Foundation.h>

/** \brief Audio and video codec types
*/
typedef NS_ENUM(int, ZDKAudioVideoCodecs)
{

	/** \brief No codec - invalid
	*/
	avc_NA,

	/** \brief G.729 @ 8000 Hz
	*/
	avc_G729,

	/** \brief GSM @ 8000 Hz
	*/
	avc_GSM,

	/** \brief iLBC 20 @ 8000 Hz
	*/
	avc_iLBC_20,

	/** \brief H.264 video
	*/
	avc_h264,

	/** \brief VP8 video
	*/
	avc_vp8,

	/** \brief Hardware accelerated H.264 video
	*/
	avc_h264_hwd,

	/** \brief Speex @ 8000 Hz
	*/
	avc_SPEEX_NARROW,

	/** \brief Speex @ 16000 Hz
	*/
	avc_SPEEX_WIDE,

	/** \brief Speex @ 32000 Hz
	*/
	avc_SPEEX_ULTRA,

	/** \brief G.726 32 kbps @ 8000 Hz
	*/
	avc_G726,

	/** \brief Opus @ 8000 Hz
	*/
	avc_OPUS_NARROW,

	/** \brief Opus @ 16000 Hz
	*/
	avc_OPUS_WIDE,

	/** \brief Opus @ 24000 Hz
	*/
	avc_OPUS_SUPER,

	/** \brief Opus @ 48000 Hz
	*/
	avc_OPUS_FULL,

	/** \brief AMR @ 8000 Hz
	*/
	avc_AMR,

	/** \brief Wide Band AMR @ 16000 HZ
	*/
	avc_AMR_WB,

	/** \brief G.711 mu-law @ 8000 Hz
	*/
	avc_PCMU,

	/** \brief G.711 a-law @ 8000 Hz
	*/
	avc_PCMA,

	/** \brief G.722 @ 16000 Hz
	*/
	avc_G722,
};
