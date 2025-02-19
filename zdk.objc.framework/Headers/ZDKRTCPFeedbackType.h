# import <Foundation/Foundation.h>

/** \brief RTCP Feedback usage types
*
*  The purpose of RTCP Feedback is to provide quick inbound status reporting for media streams, error correction
*  and resilience against packet losses.
*/
typedef NS_ENUM(int, ZDKRTCPFeedbackType)
{

	/** \brief Uses only AVP RTP Profile type - RTCP Feedbacks are OFF
	*/
	rtcpft_Off,

	/** \brief Use both AVP and AVPF RTP Profile types - RTCP Feedbacks are ON (video media is duplicated in the SDP)
	*/
	rtcpft_Compatibility,

	/** \brief Use only AVPF RTP Profile type - RTCP Feedbacks are ON (will establish media only if the remote peer also supports AVPF!)
	*/
	rtcpft_On,
};
