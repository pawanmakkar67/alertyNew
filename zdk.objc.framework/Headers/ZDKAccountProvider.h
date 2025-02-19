//
// ZDKAccountProvider.h
// ZDK
//

#ifndef ZDKAccountProvider_h
#define ZDKAccountProvider_h

#import <Foundation/Foundation.h>
#import "ZDKAccount.h"
#import "ZDKSipMethodTypes.h"
#import "ZDKAccountProviderEventsHandler.h"
#import "ZDKAccountConfig.h"
#import "ZDKMSRPConfig.h"
#import "ZDKStunConfig.h"
#import "ZDKIAXConfig.h"
#import "ZDKSIPConfig.h"
#import "ZDKZRTPConfig.h"
#import "ZDKPushConfig.h"
#import "ZDKHeaderField.h"
#import "ZDKZHandle.h"
#import "ZDKAccount.h"
@protocol ZDKAccount;
#import "ZDKAccountProviderEventsHandler.h"
@protocol ZDKAccountProviderEventsHandler;
#import "ZDKAccountConfig.h"
@protocol ZDKAccountConfig;
#import "ZDKMSRPConfig.h"
@protocol ZDKMSRPConfig;
#import "ZDKStunConfig.h"
@protocol ZDKStunConfig;
#import "ZDKIAXConfig.h"
@protocol ZDKIAXConfig;
#import "ZDKSIPConfig.h"
@protocol ZDKSIPConfig;
#import "ZDKZRTPConfig.h"
@protocol ZDKZRTPConfig;
#import "ZDKPushConfig.h"
@protocol ZDKPushConfig;
#import "ZDKHeaderField.h"
@protocol ZDKHeaderField;

NS_ASSUME_NONNULL_BEGIN

/** \brief Account information and control provider
*
*  Manages creation and destruction of user accounts and provides information regarding them.
*/
@protocol ZDKAccountProvider <ZDKZHandle>

/** \brief Gets a list with all active accounts
*
*  \return List with all accounts
*
*  \see ZDKAccount
*/
@property(nonatomic, readonly) NSArray<id<ZDKAccount>>*  listAccounts;

/** \brief Gets the count of all active accounts
*
*  \return The number of all accounts
*/
@property(nonatomic, readonly) int  accountsCount;

/** \brief Gets the default account
*
*  \return The default account
*/
@property(nonatomic, readonly) id<ZDKAccount>  _Nullable defaultAccount;

/** \brief Creates a new user account
*
*  Creates a new user that can be used to register on a server for incoming calls, create outgoing calls, subscribe
*  for presence, etc. This is a mandatory operation before using most of the library's functions.
*
*  This call will only prepare the structures for the user account. It will not be registered to the server until
*  registerAccount() is called (note that registration is not a mandatory operation).
*
*  \return The newly created user account
*
*  \see ZDKAccount
*/
-(id<ZDKAccount>)createUserAccount;
/** \brief Destroys an user account
*
*  Destroys an user account object and all related structures. If the user has active calls, they will be
*  terminated first.
*
*  \param[in] account  The account to be destroyed
*/
-(void)deleteUserAccount:(id<ZDKAccount>)account ;
/** \brief Gets the account with the specified ID
*
*  Returns the account with the specified ID if exist, otherwise a null pointer is returned.
*
*  \param[in] hAccountId  The ID of the requested account
*
*  \return The requested account if exists or null pointer otherwise
*/
-(id<ZDKAccount> _Nullable)getAccount:(long int)hAccountId ;
/** \brief Sets the default account
*
*  \param[in] account  The default account
*
*  \return Whether or not the set was successful
*/
-(BOOL)setAsDefaultAccount:(id<ZDKAccount> _Nullable)account ;
/** \brief Unregisters all accounts
*
*  If the user account is in the process of registration this function will cancel it. If the user was already
*  registered an unregistration process will start. If there is no error the function will return immediately and
*  the final result will be delivered via a callback.
*
*  \see ZDKAccountEventsHandler
*/
-(void)unregisterAllAccounts;
/** \brief Creates a new empty account configuration
*
*  \return The newly created account configuration
*
*  \see ZDKAccountConfig
*/
-(id<ZDKAccountConfig>)createAccountConfiguration;
/** \brief Creates a new empty MSRP configuration
*
*  \return The newly created MSRP configuration
*
*  \see ZDKMSRPConfig
*/
-(id<ZDKMSRPConfig>)createMSRPConfiguration;
/** \brief Creates a new empty STUN configuration
*
*  \return The newly created STUN configuration
*
*  \see ZDKStunConfig
*/
-(id<ZDKStunConfig>)createStunConfiguration;
/** \brief Creates a new empty IAX configuration
*
*  \return The newly created IAX configuration
*
*  \see ZDKIAXConfig
*/
-(id<ZDKIAXConfig>)createIAXConfiguration;
/** \brief Creates a new empty SIP configuration
*
*  \return The newly created SIP configuration
*
*  \see ZDKSIPConfig
*/
-(id<ZDKSIPConfig>)createSIPConfiguration;
/** \brief Creates a new empty ZRTP configuration
*
*  \return The newly created ZRTP configuration
*
*  \see ZDKZRTPConfig
*/
-(id<ZDKZRTPConfig>)createZRTPConfiguration;
/** \brief Creates a new empty Push configuration
*
*  \return The newly created Push configuration
*
*  \see ZDKPushConfig
*/
-(id<ZDKPushConfig>)createPushConfiguration;
/** \brief Creates a SIP header
*
*  \param[in] name  The NAME of the header
*  \param[in] values  List with header VALUES
*  \param[in] method  SIP METHOD this header to be added to
*
*  \return The newly created SIP Header
*
*  \see SipMethodTypes
*/
-(id<ZDKHeaderField>)createSIPHeaderField:(NSString*)name values:(NSArray*)values method:(ZDKSipMethodTypes)method ;
/** \brief Adds a new account provider event listener
*
*  All added listeners will be notified for each event.
*
*  \param[in] value  The account provider event listener to be added
*
*  \see ZDKAccountProviderEventsHandler, dropAccountProviderListener()
*/
-(void)addAccountProviderListener:(id<ZDKAccountProviderEventsHandler>)value ;
/** \brief Removes a specific already added account provider event listener
*
*  All added/left listeners will be notified for each event.
*
*  \param[in] value  The account provider event listener to be removed
*
*  \see ZDKAccountProviderEventsHandler, addConferenceProviderListener()
*/
-(void)dropAccountProviderListener:(id<ZDKAccountProviderEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
