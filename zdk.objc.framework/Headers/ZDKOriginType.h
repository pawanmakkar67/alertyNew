# import <Foundation/Foundation.h>

/** \brief Call's initiator types
*/
typedef NS_ENUM(int, ZDKOriginType)
{

	/** \brief Invalid - information not available
	*/
	ot_NA,

	/** \brief Locally originated/initiated call - outgoing call
	*/
	ot_Local,

	/** \brief Remotely originated/initiated call - incoming call
	*/
	ot_Remote,
};
