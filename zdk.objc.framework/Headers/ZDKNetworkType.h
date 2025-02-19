# import <Foundation/Foundation.h>

/** \brief Network types
*/
typedef NS_ENUM(int, ZDKNetworkType)
{

	/** \brief Network is blocked (bad; maybe STUN server is down; STUN should be OFF)
	*/
	nt_Blocked,

	/** \brief Symmetric Firewall (bad; STUN should be OFF and hope for the best)
	*/
	nt_SymmetricFirewall,

	/** \brief Open network (good; but STUN must be OFF)
	*/
	nt_Open,

	/** \brief Full Cone NAT (good; STUN should be ON)
	*/
	nt_FullConeNAT,

	/** \brief Symmetric NAT (bad; STUN should be OFF and hope for the best)
	*/
	nt_SymmetricNAT,

	/** \brief Port Restricted NAT (good; STUN should be ON)
	*/
	nt_PortRestrictedNAT,

	/** \brief Restricted Cone NAT (good; STUN should be ON)
	*/
	nt_RestrictConeNAT,

	/** \brief Unknown NOT SYMMETRIC type of NAT (good; STUN should be ON)
	*/
	nt_NotSymmetricNAT,

	/** \brief Unknown network type!
	*/
	nt_Unknown,
};
