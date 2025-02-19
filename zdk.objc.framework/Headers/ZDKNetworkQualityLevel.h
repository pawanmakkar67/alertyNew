# import <Foundation/Foundation.h>

/** \brief SIP call's DTMF type
*/
typedef NS_ENUM(int, ZDKNetworkQualityLevel)
{

	/** \brief Gray; 0/5 stars (grayed?): qualification is pending
	*/
	nql_Pending,

	/** \brief Black or Gray; 1/5 stars: No incoming packets at all
	*/
	nql_None,

	/** \brief Red; 2/5 stars: heavy incoming packet loss
	*/
	nql_VeryBad,

	/** \brief Orange or Yellow; 3/5 stars: incoming packet loss
	*/
	nql_Bad,

	/** \brief Green; 4/5 stars: very low incoming packet loss
	*/
	nql_Normal,

	/** \brief Green or Blue; 5/5 shiny stars: no incoming packet loss
	*/
	nql_Perfect,
};
