//
// ZDKAccountConfig.h
// ZDK
//

#ifndef ZDKAccountConfig_h
#define ZDKAccountConfig_h

#import <Foundation/Foundation.h>
#import "ZDKProtocolType.h"
#import "ZDKSIPConfig.h"
#import "ZDKIAXConfig.h"
#import "ZDKDTMFType.h"
#import "ZDKAudioOutputDeviceType.h"
#import "ZDKAccountConfig.h"
#import "ZDKZHandle.h"
#import "ZDKSIPConfig.h"
@protocol ZDKSIPConfig;
#import "ZDKIAXConfig.h"
@protocol ZDKIAXConfig;
#import "ZDKAccountConfig.h"
@protocol ZDKAccountConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief General account configuration
*/
@protocol ZDKAccountConfig <ZDKZHandle>

/** \brief Sets the Account's username (SIP, IAX, XMPP, etc, depending on the Account type)
*
*  \param[in] value  The Account's username
*
*  \see type()
*/
@property(nonatomic) NSString*  userName;

/** \brief Sets the Account's password (SIP, IAX, XMPP, etc, depending on the Account type)
*
*  \param[in] value  The Account's password
*
*  \see type()
*/
@property(nonatomic) NSString*  _Nullable password;

/** \brief Sets the Account's type (SIP, IAX, XMPP, etc.)
*
*  \param[in] value  The Account's type
*
*  \see ProtocolType
*/
@property(nonatomic) ZDKProtocolType  type;

/** \brief Set the Account's registration refresh time
*
*  Sets the desired registration refresh period in seconds. Note that the server might enforce different (shorter)
*  refresh time.  The stack will not wait for the full period to refresh the registration.  It will try to refresh
*  it after 90% of the negotiated time has elapsed.
*
*  \param[in] value  The registration refresh period in seconds
*/
@property(nonatomic) int  reregistrationTime;

/** \brief Sets the SIP specific account configuration
*
*  Sets the SIP specific account configuration being used in case the Account's type is SIP. Note the SIP
*  configuration is not used if the Account's type is not SIP!
*
*  \param[in] value  The SIP configuration
*
*  \see ZDKSIPConfig, type()
*/
@property(nonatomic) id<ZDKSIPConfig>  _Nullable sip;

/** \brief Sets the IAX specific account configuration
*
*  Sets the IAX specific account configuration being used in case the Account's type is IAX. Note the IAX
*  configuration is not used if the Account's type is not IAX!
*
*  \param[in] value  The IAX configuration
*
*  \see ZDKIAXConfig, type()
*/
@property(nonatomic) id<ZDKIAXConfig>  _Nullable iax;

/** \brief Sets per account Device GUID
*
*  !!!NOTE!!! NOT used internally!
*
*  \param[in] value  The account's Device GUID
*/
@property(nonatomic) NSString*  _Nullable deviceGUID;

/** \brief Sets per account Registration GUID
*
*  !!!NOTE!!! NOT used internally!
*
*  \param[in] value  The account's Registration GUID
*/
@property(nonatomic) NSString*  _Nullable registrationGUID;

/** \brief NOT USED! MIGHT BE REMOVED ANYTIME!
*
*  ZDKPv6 is a global option and there are no plans making it configurable per account!
*/
@property(nonatomic) BOOL  enableIPv6Detection;

/** \brief Selects the DTMF band for the user
*
*  \param[in] value  The DTMF band to select
*
*  \see DTMFType
*/
@property(nonatomic) ZDKDTMFType  dtmfBand;

/** \brief Automatically play DTMF sounds to the user
*
*  Controls whether to automatically play the DTMF sounds to the user when sending DTMFs with zdkCall::SendDTMF().
*
*  The default behaviour is to not play anything (ZDK::AudioOutputDeviceType::Disable).
*
*  \param[in] value  The DTMF autoplay device
*
*  \see zdkCall::SendDTMF(), AudioOutputDeviceType
*/
@property(nonatomic) ZDKAudioOutputDeviceType  dtmfAutoplayDevice;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  Account configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKAccountConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
