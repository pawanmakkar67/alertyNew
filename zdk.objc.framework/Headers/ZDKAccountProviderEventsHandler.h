//
// ZDKAccountProviderEventsHandler.h
// ZDK
//

#ifndef ZDKAccountProviderEventsHandler_h
#define ZDKAccountProviderEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKAccountProvider.h"
#import "ZDKAccount.h"
#import "ZDKEventHandle.h"
#import "ZDKAccountProvider.h"
@protocol ZDKAccountProvider;
#import "ZDKAccount.h"
@protocol ZDKAccount;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKAccountProviderEventsHandler <ZDKEventHandle>

@optional

/** \brief Account information and control provider
*
*  Provides information on creation , destruction and configuration of user accounts.
*
*  \param[in] accountProvider  The account provider for which the default account has changed
*  \param[in] account  The new default account
*
*  \see ZDKAccount, ZDKAccountProvider
*/
-(void)onDefaultAccountChanged:(id<ZDKAccountProvider>)accountProvider account:(id<ZDKAccount>)account ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
