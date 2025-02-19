# import <Foundation/Foundation.h>

/** \brief RTP Collision Resolution algorithm
*
*  This enum is used to select between the different algorithms for RTP SSRC collision resolution.
*/
typedef NS_ENUM(int, ZDKRTPCollisionResolutionType)
{

	/** \brief Handle collisions by sending a RTCP BYE
	*/
	rtpcrt_Strict,

	/** \brief Act as if the first few collisions did not happen and send a RTCP BYE after that
	*/
	rtpcrt_Moderate,

	/** \brief Act as if no collisions ever happen
	*/
	rtpcrt_Lenient,
};
