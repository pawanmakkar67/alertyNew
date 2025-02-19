//
// ZDKTLSConfiguration.h
// ZDK
//

#ifndef ZDKTLSConfiguration_h
#define ZDKTLSConfiguration_h

#import <Foundation/Foundation.h>
#import "ZDKTLSSecureSuiteType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief TLS specific account configuration
*
*  The configuration is applied/initialized with startContext()! Any changes after startContext() has been invoked will
*  not take effect until a restart happens - stopContext() followed by startContext().
*
*  TLS transport configuration along with the User Agent Server part (incoming TLS connections need a domain and cert
*  to work properly).
*/
@protocol ZDKTLSConfiguration <ZDKZHandle>

/** \brief Sets whether the TLS configuration is initialized/applied
*
*  Indicates whether the configuration is applied/initialized with startContext()! Any changes to the configuration
*  can take place only if it is not initialized. If startContext() has been invoked any changes will not take
*  effect until a restart happens - stopContext() followed by startContext().
*
*  \param[in] value
*  \li 0 - not initialized (can be modified)
*  \li 1 - initialized (modifications will take effect after restart)
*/
@property(nonatomic) BOOL  tlsInitialized;

/** \brief Configures whether to to limit the use to only of strong cypher
*
*  If enabled, will limit the ciphers to 3DES and AES (RC4 or DES will not be allowed)
*
*  \param[in] value
*  \li 0 - disabled (use all)
*  \li 1 - enabled (use only strong cyphers - 3DES and AES)
*/
@property(nonatomic) BOOL  useOnlyStrongCyphers;

/** \brief Configures the local domain name
*
*  A default TLS transport is always initialized. Incoming TLS connections will not work with it unless a user
*  certificate is later configured.
*
*  If not set (or set to NULL) only the default transport will be initialized.
*
*  If set to empty string ("") the ZDK will try to guess the local hostname and will generate a self-signed
*  certificate for a TLS transport that will listen for incoming TLS connections. Has a low chance of succeeding.
*  Falls back to "localhost". Does not matter what is the value of domainCert(). This will not stop the default TLS
*  transport creation nor will force any users to use it for their outgoing TLS connections.
*
*  Using self-signed domain TLS certificate is rarely supported by TLS peers and in most cases will not work. It is
*  recommended not to use it.
*
*  If set, it will use this domain, no matter what is the value of the domain name found in the certificate set
*  with domainCert().
*
*  \param[in] value  The TLS domain name
*
*  \see domainCert()
*/
@property(nonatomic) NSString*  _Nullable domain;

/** \brief Configures the domain certificate to be load
*
*  If not set (or set to NULL) AND domain() is also not set (or set to NULL) only the default TLS transport will be
*  initialized. Incoming TLS connections will not work unless a user certificate is later configured.
*
*  If not set (or set to NULL) AND domain() is set a self-signed certificate will be created to be used for the
*  incoming connections. Not recommended because self-signed domain TLS certificate are rarely supported by TLS
*  peers and in most cases will not work.
*
*  If set the ZDK will try loading a Certificate and Key pair from the file with this name. The file can be in PEM
*  format (the order in which the certificate and key are pasted in it does not matter) or in PKCS#12 format (.PFX,
*  the way the pair is exported in Windows). If it is in the PKCS#12 format any additional certificates will be
*  added to the trusted certificate list.
*
*  !!! NOTE !!! If domain() is set (not NULL) the domain name found in the certificate will be ignored!
*
*  \param[in] value  The TLS domain certificate name
*
*  \see domain()
*/
@property(nonatomic) NSString*  _Nullable domainCert;

/** \brief Configures the domain certificate passphrase
*
*  Can optionally contain the plaintext passphrase protecting the key set with domainCert().
*  Can be left not set (or set to NULL pointer) if the key is not protected.
*
*  \param[in] value  The TLS domain certificate passphrase
*
*  \see domainCert()
*/
@property(nonatomic) NSString*  _Nullable domainCertPassphrase;

/** \brief Configures the TLS secure suite type to be used
*
*  By default it is set to TLSv1.2 (support TLSv1.2 and better/newer - TLSv1.3, etc are alsosupported!)
*
*  \param[in] value  The TLS secure suite type
*
*  \see TLSSecureSuiteType
*/
@property(nonatomic) ZDKTLSSecureSuiteType  secureSuite;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
