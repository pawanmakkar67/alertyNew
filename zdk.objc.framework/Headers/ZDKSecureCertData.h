//
// ZDKSecureCertData.h
// ZDK
//

#ifndef ZDKSecureCertData_h
#define ZDKSecureCertData_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKSecureCertData <ZDKZHandle>

/** \brief Gets the mask of errors for the certificate
*
*  Bit-field of CertificateError
*
*  \return The mask of errors
*
*  \see CertificateError
*/
@property(nonatomic, readonly) int  errorMask;

/** \brief Gets the certificate's subject
*
*  \return The certificate's subject
*/
@property(nonatomic, readonly) NSString*  certSubject;

/** \brief Gets the certificate's issuer
*
*  \return The certificate's issuer
*/
@property(nonatomic, readonly) NSString*  certIssuer;

/** \brief Gets the certificate's start of validity
*
*  \return The certificate's start validity
*/
@property(nonatomic, readonly) NSString*  certNotBefore;

/** \brief Gets the certificate's end of validity
*
*  \return The certificate's end validity
*/
@property(nonatomic, readonly) NSString*  certNotAfter;

/** \brief Gets the expected subject name for the certificate
*
*  The function gets the expected subject name for the certificate.
*  The main certificate name is in the certificate's subject in the
* 'commonName' field. More names can be found in the certificate's
*  'altSubjectName' extension.
*
*  \return The expected subject name for the certificate
*/
@property(nonatomic, readonly) NSString*  expectedName;

/** \brief Gets the actual certificate names list
*
*  The function gets the actual certificate names list.
*  The whole list is in the actual list represented as a ASCIIZ string of comma delimited
*  values.
*
*  \return The actual certificate names list
*/
@property(nonatomic, readonly) NSString*  actualNameList;

/** \brief Gets the certificate itself
*
*  The function gets the certificate itself, PEM encoded.
*
*  \return The actual certificate
*/
@property(nonatomic, readonly) NSString*  certDataPEM;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
