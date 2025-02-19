//
// ZDKEncryptionConfiguration.h
// ZDK
//

#ifndef ZDKEncryptionConfiguration_h
#define ZDKEncryptionConfiguration_h

#import <Foundation/Foundation.h>
#import "ZDKTLSConfiguration.h"
#import "ZDKResult.h"
#import "ZDKSecureCertStatus.h"
#import "ZDKZHandle.h"
#import "ZDKTLSConfiguration.h"
@protocol ZDKTLSConfiguration;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Encription specific configuration
*/
@protocol ZDKEncryptionConfiguration <ZDKZHandle>

/** \brief Sets the TLS specific configuration
*
*  The configuration is applied with startContext()! Any changes after startContext() has been invoked will not
*  take effect until a restart happens - stopContext() followed by startContext().
*
*  \param[in] value  The TLS configuration
*
*  \see ZDKTLSConfiguration
*/
@property(nonatomic) id<ZDKTLSConfiguration>  _Nullable tlsConfig;

/** \brief Adds a certificate to the exception list
*
*  Adds the given certificate to the list of exceptions.
*
*  This can be useful if the user wants to force a SIP/TLS connection with a server that presents a broken
*  certificate.
*
*  The PEM data can be taken straight from the onContextSecureCertStatus() status callback.
*
*  The next attempt to communicate with a server using the same certificate will succeed. All connection
*  establishments (e.g. registrations and calls) will have to be left for the user to retry.
*
*  The user should be warned that using exceptions makes TLS much less secure than they think it is.
*
*  \param[in] pem  The certificate in PEM format
*
*  \return Result of the addition
*
*  \see addCertificatesDirect(), onContextSecureCertStatus(), ZDKResult
*/
-(id<ZDKResult>)addKnownCertificate:(NSString*)pem ;
/** \brief Adds TLS certificates from a PEM file
*
*  Adds the certificates found in the file.  The file must be in PEM format.
*  Note that on Windows platforms the certificate authorities from the system certificate store will be
*  automatically added.
*
*  \param[in] filename  File name containing PEM certificates to add
*
*  \return Result of the addition
*
*  \see addCertificatesDirect(), ZDKResult
*/
-(id<ZDKResult>)addCertificates:(NSString*)filename ;
/** \brief Adds TLS certificates from memory
*
*  Adds the certificates at that memory location. The format must still be PEM like in addCertificates().
*
*  \param[in] data  data to the buffer containing PEM certificates
*  \param[in] dataLen  Size of the buffer in bytes
*
*  \return Result of the addition
*
*  \see addCertificates(), ZDKResult
*/
-(id<ZDKResult>)addCertificatesDirect:(unsigned char*)data dataLen:(int)dataLen ;
/** \brief Configure global ZRTP ZID Cache file
*
*  Sets the full file name for the global ZRTP ZID Cache file. The file is in a file format similar to CSV. It is
*  managed entirely by the ZDK based on RFC 6189 (ZRTP).
*
*  If the file name is an empty string or NULL pointer, the ZRTP will proceed in cacheless mode.
*
*  The file name is UTF-8 encoded and will be converted to the native Unicode encoding for the system. (Yes, this
*  means no need for special handling on Windows!)
*
*  The cache file is used to store binary keys called "retained secrets" in the ZRTP protocol. These retained
*  secrets are obtained from a successful ZRTP negotiation with a peer.
*
*  Each device or phone capable of ZRTP has its own ZRTP ID called "ZID". When doing the ZRTP handshake this ZID
*  is exchanged and can later be used to associate information with a ZRTP peer.
*
*  The ZRTP negotiation includes confirmation that the person on the other end is who they claim they are. It is
*  always recommended to confirm the person by their voice. The ZRTP cache is used to also confirm that the person
*  is using a device that we've already interacted with.
*
*  In the very first call with a peer we will not have a cache entry. After that we expect our cache to match the
*  peer's cache. In case this does not happen we might have a security problem. This means confirming the
*  negotiation with the short authentication string.
*
*  Just in case, here are some details about the file format:
*
*  The first line is our own ZID, base64-encoded. The ZID is a unique ZRTP identifier consisting of 96 random
*  bits. The ZDK will generate a new ZID for new cache files. Once generated, our ZID will not change unless a new
*  cache file is configured or it is lost.
*
*  From the second line to the end of the file we have peer cache records, single record per line with fields
*  separated by the pipe symbol '|'.
*
*  Each peer record consists of:
*    - The peer's ZID, base64 encoded
*    - Retained Secret 1, base64 encoded. The retained secret is a one-way 256-bit hash produced from a previous
*      successful ZRTP negotiation. It will be used to confirm the peer identity for subsequent ZRTP negotiations
*      without the need for SAS confirmation.
*    - Retained Secret 1 expiration, ZDKSO format, or +ZDKNF if the retained secret will never expire
*    - Retained Secret 2, base64 encoded. After every successful ZRTP negotiation involving a Diffie-Hellman key
*      exchange, a new retained secret is obtained. What was previously the "Retained Secret 2" is deleted. What
*      was previously the "Retained Secret 1" becomes the new "Retained Secret 2". The brand new retained secret is
*      stored as the new "Retained Secret 1".
*    - Retained Secret 2 expiration, ZDKSO format, or +ZDKNF for "never expires" or -ZDKNF for "not available yet".
*
*  \param[in] value  The ZID Cache file name, or empty to disable
*
*  \return Result of the set
*
*  \see ZDKResult
*/
-(id<ZDKResult>)globalZrtpCache:(NSString*)value ;
/** \brief Evaluates the certificate trust type.
*
*  This function asks the OS for trust type.
*
*  \param[in] pem  The PEM encoded certificate
*  \param[in] expectedName  The policy will require this value to match the host name.
*
*  \return The status of the evaluation
*
*  \see SecureCertStatus
*/
-(ZDKSecureCertStatus)evaluateCertificateTrust:(NSString*)pem expectedName:(NSString*)expectedName ;
/** \brief Verifies usability for SSL certificate and key pair
*
*  This function can be used to check if a certificate and key pair found in a PEM or PKCS#12 file is valid before
*  applying it to a user.
*
*  This gives much more detail than SetUserCertificate which still MUST be called to actually configure the user.
*
*  The code tries to isolate the most common errors like trying to load an encrypted private key with the incorrect
*  password or trying to use a wrong combination of key and certificate.
*
*  Actual certificate signature validation is not done yet although we have decided to reserve an output parameter
*  for it.
*
*  The suite for which we will test the cert is taken from the setting done by zdktlsConfiguration::SecureSuite()
*
*  \param[in] fileName  File name of the cert+key pair. Accepts PEM (text file with the cert and key one after the
*                       other in base64 encoding) or PKCS#12 (a binary format more common on Windows)
*  \param[in] passphrase  Optional, the pass phrase which is used to protect the private key in the file
*
*  \return The status of the verification
*
*  \see zdktlsConfiguration::SecureSuite()
*/
-(ZDKSecureCertStatus)verifyUserCertificate:(NSString*)fileName passphrase:(NSString*)passphrase ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
