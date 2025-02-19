//
// ZDKActivation.h
// ZDK
//

#ifndef ZDKActivation_h
#define ZDKActivation_h

#import <Foundation/Foundation.h>
#import "ZDKPermissionType.h"
#import "ZDKAudioVideoCodecs.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Handles the Activation process of the ZDK
*/
@protocol ZDKActivation <ZDKZHandle>

/** \brief Gets the activation status
*
*  \return
*  \li 0 - not activated
*  \li 1 - activated
*/
@property(nonatomic, readonly) BOOL  activated;

/** \brief Starts activation process
*
*  For Zoiper internal use only! For SDK builds see startSDK()!
*
*  Starts activation process of the product. Without activation, much of the functionality is not allowed.
*  Activation first tries to use data from a certificate cache file, the path to which is supplied by the user. If
*  the file is available and valid for the current device, it's contents will be used to set the allowed
*  functionalities. If file is invalid OR not present, the SDK will make an HTTP request to a licensing server. On
*  valid response the results from the server will be used to configure functionality availability and, if the
*  location supplied by the user in certCacheFile is valid and writable, the results will be stored there so that
*  the cache file can be used on next invocation.
*
*  The activation process is doing a GET request constructed from the arguments of the function. The base URL of
*  the GET request can be changed if the baseUrl parameter is not NULL.
*
*  All of the parameter values will be properly URL escaped by the library and MUST NOT be already URL escaped
*  when being passed to this function.
*
*  The password parameter will be scrambled using MD5 and the result will be converted to a hex string before
*  passing it to the web server. It MUST NOT be pre-processed in any way before passing it to this function.
*
*  \param[in] certCacheFile  If non-zero, it is a UTF-8 file name which is used to cache the certificate received
*                            from the server. If such file does not exist, the usual HTTP (online) activation is
*                            initiated, if possible. After a successful online activation, the resulting
*                            certificate will be stored in the file.
*  \param[in] moduleName  Provides support for DLL products using this ZDK as a static library. This is not for
*                         the case where ZDK is used as a DLL. In that case the \p moduleName is ignored. In the
*                         case where ZDK is a static library used to link a DLL project, and that DLL project is
*                         used by an external application, the checksum must be calculated from the DLL, not the
*                         main application. In this case \p moduleName is needed to hint the Activation object
*                         when it tries to discover the file from which we're loaded.
*  \param[in] opFlags  A bit field flag controlling the activation options - ActivationFlags enum
*  \param[in] username Client's username ("username" URL parameter)
*  \param[in] password Client's password ("password" URL parameter)
*  \param[in] version  The phone build version as configured on the cert site. This is the "version" URL parameter
*  \param[in] certPem  The certificate issued by the cert server for this specific phone build. Must match the
*                      certificate on the server.
*
*
*  \return Result of the invocation
*
*  \see startSDK(), stop(), onContextActivationCompleted(), ZDKResult, ActivationFlags
*/
-(id<ZDKResult>)start:(NSString*)certCacheFile moduleName:(NSString* _Nullable)moduleName opFlags:(int)opFlags username:(NSString*)username password:(NSString*)password version:(NSString*)version certPem:(NSString*)certPem ;
/** \brief starts activation for an SDK product
*
*  For SDK products only! For Zoiper internal use see start()!
*
*  starts activation process of the SDK product. Without activation, much of the functionality is not allowed.
*  Activation first tries to use data from a certificate cache file, the path to which is supplied by the user. If
*  the file is available and valid for the current device, it's contents will be used to set the allowed
*  functionalities. If file is invalid OR not present, the SDK will make an HTTP request to a licensing server. On
*  valid response the results from the server will be used to configure functionality availability and, if the
*  location supplied by the user in certCacheFile is valid and writable, the results will be stored there so that
*  the cache file can be used on next invocation.
*
*  The activation process is doing a GET request constructed from the arguments of the function. The base URL of
*  the GET request can be changed if the baseUrl parameter is not NULL.
*
*  All of the parameter values will be properly URL escaped by the library and MUST NOT be already URL escaped
*  when being passed to this function.
*
*  The password parameter will be scrambled using MD5 and the result will be converted to a hex string before
*  passing it to the web server. It MUST NOT be pre-processed in any way before passing it to this function.
*
*  \param[in] certCacheFile  If non-zero, it is a UTF-8 file name which is used to cache the certificate received
*                            from the server. If such file does not exist, the usual HTTP (online) activation is
*                            initiated, if possible. After a successful online activation, the resulting
*                            certificate will be stored in the file.
*  \param[in] username Username to use for authentication to the cert server
*  \param[in] password Password to use for authentication to the cert server
*
*
*  \return Result of the invocation
*
*  \see start(), stop(), onContextActivationCompleted(), ZDKResult
*/
-(id<ZDKResult>)startSDK:(NSString*)certCacheFile username:(NSString*)username password:(NSString*)password ;
/** \brief Stops the activation process
*
*  Cancels any activation in progress.
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)stop;
/** \brief Gets whether a given ZDK functionality is enabled and can be used
*
*  \param[in] value  Functionality to be checked
*
*  \return
*  \li 0 - not available
*  \li 1 - available
*
*  \see PermissionType
*/
-(BOOL)checkPermission:(ZDKPermissionType)value ;
/** \brief Gets whether a given media (audio/video) codec is enabled and can be used
*
*  \param[in] value  Codec to be checked
*
*  \return
*  \li 0 - not available
*  \li 1 - available
*
*  \see AudioVideoCodecs
*/
-(BOOL)checkCodecPermission:(ZDKAudioVideoCodecs)value ;
/** \brief Gets whether a given hostname (domain) is allowed to be used
*
*  \param[in] value  Hostname (domain) to be checked
*
*  \return
*  \li 0 - not allowed
*  \li 1 - allowed
*/
-(BOOL)checkHostname:(NSString*)value ;
/** \brief Creates a file required for offline activation
*
*  For Zoiper internal use only! For SDK builds see createOfflineActivationFileSDK()!
*  Creates a file required for offline activation
*
*  1. Create a file with the createOfflineActivationFile().
*
*  2. Send the file to "register5@shop.zoiper.com" attached in email.
*
*  3. An email will be send to you with the new certificate file needed for offline activation.
*
*  4. Use the received file (from the received email from the CERT server) as "certCacheFile" input parameter
*     of start().
*
*  \param[in] activationFile  File name (including full path to it!)
*  \param[in] username  The username for the account to be activated
*  \param[in] password  The password for the activation of the account
*  \param[in] hddSerial  The HDD serial number
*  \param[in] version  The build version as configured on the cert site. This is the "version" URL parameter
*  \param[in] pcUser  The user name
*  \param[in] pcName  The device name
*
*  \return Result of the creating of the file
*
*  \see ZDKResult, start()
*/
-(id<ZDKResult>)createOfflineActivationFile:(NSString*)activationFile username:(NSString*)username password:(NSString*)password hddSerial:(NSString*)hddSerial version:(NSString*)version pcUser:(NSString*)pcUser pcName:(NSString*)pcName ;
/** \brief Creates a file  required for offline activation
*
*  For SDK products only! For Zoiper internal use see createOfflineActivationFile()!
*  Creates a file required for offline activation
*
*  1. Create a file with the createOfflineActivationFileSDK().
*
*  2. Send the file to "register5@shop.zoiper.com" attached in email.
*
*  3. An email will be send to you with the new certificate file needed for offline activation.
*
*  4. Use the received file (from the received email from the CERT server) as "certCacheFile" input parameter
*     of startSDK().
*
*  \param[in] activationFile  File name (including full path to it!)
*  \param[in] username the  Username for the account to be activated
*  \param[in] password the  Password for the activation of the account
*
*  \return Result of the creating of the file
*
*  \see ZDKResult, startSDK()
*/
-(id<ZDKResult>)createOfflineActivationFile:(NSString*)activationFile sdk:(NSString*)username password:(NSString*)password ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
