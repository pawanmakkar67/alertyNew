# import <Foundation/Foundation.h>

/** \brief User Account specific TLS Configuration types
*
*  Used for specifying a custom TLS Configuration behavior per user account
*/
typedef NS_ENUM(int, ZDKSecureUserConfigType)
{

	/** \brief Disable TLS server operation for this user; use no certificate for client TLS connections (recommended)
	*/
	suct_ClientOnly,

	/** \brief Use the common server TLS transport if available
	*/
	suct_Common,

	/** \brief Create a dedicated TLS transport for this user with a certificate from a file
	*/
	suct_Dedicated,

	/** \brief Create a dedicated TLS transport for this user and generate a self-signed certificate (not recommended)
	*/
	suct_Generated,
};
