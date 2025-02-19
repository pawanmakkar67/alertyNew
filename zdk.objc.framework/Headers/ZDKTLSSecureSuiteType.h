# import <Foundation/Foundation.h>

/** \brief TLS secure suite type
*/
typedef NS_ENUM(int, ZDKTLSSecureSuiteType)
{

	/** \brief Invalid - information not available
	*/
	tlssst_NA,

	/** \brief Support SSLv3 or newer. SSLv3/TLSv1.0/TLSv1.1/... connections are accepted (SSLv2 is droppen in OpenSSL 1.1.0)!
	*/
	tlssst_SSLv2_v3,

	/** \brief Support TLSv1.0 or newer. TLSv1.0/TLSv1.1/... connections are accepted!
	*/
	tlssst_TLSv1,

	/** \brief Support TLSv1.1 or newer. TLSv1.1/TLSv1.2/... connections are accepted!
	*/
	tlssst_TLSv1_1,

	/** \brief Support TLSv1.2 or newer. TLSv1.2/TLSv1.3/... connections are accepted!
	*/
	tlssst_TLSv1_2,

	/** \brief Support TLSv1.3 or newer. TLSv1.3/whatever is being released after TLSv1.3... connections are accepted!
	*/
	tlssst_TLSv1_3,
};
