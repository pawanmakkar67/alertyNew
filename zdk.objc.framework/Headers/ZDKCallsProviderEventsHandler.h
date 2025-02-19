//
// ZDKCallsProviderEventsHandler.h
// ZDK
//

#ifndef ZDKCallsProviderEventsHandler_h
#define ZDKCallsProviderEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKCallsProvider.h"
#import "ZDKCall.h"
#import "ZDKEventHandle.h"
#import "ZDKCallsProvider.h"
@protocol ZDKCallsProvider;
#import "ZDKCall.h"
@protocol ZDKCall;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKCallsProviderEventsHandler <ZDKEventHandle>

@optional

-(void)onCallsProvider:(id<ZDKCallsProvider>)callsProvider activeCallchanged:(id<ZDKCall> _Nullable)activeCall ;
/** \brief Notify upon call is added
*
*  Notify upon call is added
*
*  \param[in] callsProvider  The calls provider
*  \param[in] call  The active call that was added
*
*  \see ZDKCallsProvider, ZDKCall
*
*/
-(void)onCallsProvider:(id<ZDKCallsProvider>)callsProvider calladded:(id<ZDKCall>)call ;
/** \brief Notify upon call is removed
*
*  Notify upon call is removed
*
*  \param[in] callsProvider  The calls provider
*  \param[in] call  The active call that was removed
*
*  \see ZDKCallsProvider, ZDKCall
*
*/
-(void)onCallsProvider:(id<ZDKCallsProvider>)callsProvider callremoved:(id<ZDKCall>)call ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
