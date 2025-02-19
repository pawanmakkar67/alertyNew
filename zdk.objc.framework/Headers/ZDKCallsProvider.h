//
// ZDKCallsProvider.h
// ZDK
//

#ifndef ZDKCallsProvider_h
#define ZDKCallsProvider_h

#import <Foundation/Foundation.h>
#import "ZDKCall.h"
#import "ZDKActiveCallChange.h"
#import "ZDKCallsProviderEventsHandler.h"
#import "ZDKZHandle.h"
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKCallsProviderEventsHandler.h"
@protocol ZDKCallsProviderEventsHandler;

NS_ASSUME_NONNULL_BEGIN

/** \brief Active calls information provider
*/
@protocol ZDKCallsProvider <ZDKZHandle>

/** \brief Gets the currently active call
*
*  \return The currently active call
*
*  \see ZDKCall
*/
@property(nonatomic, readonly) id<ZDKCall>  _Nullable activeCall;

/** \brief Gets a list with all calls
*
*  \return List with all calls
*
*  \see ZDKCall
*/
@property(nonatomic, readonly) NSArray<id<ZDKCall>>*  calls;

/** \brief Gets the count of all calls
*
*  \return The number of all calls
*/
@property(nonatomic, readonly) int  callsCount;

/** \brief Sets the currently active call and specifies what to happen with all the rest calls (if any)
*
*  NOTE!!! Does NOT change the new active call's state! It is up to the API user to decide what to do with it!
*
*  \param[in] call  The currently active call
*  \param[in] callChange  The action to be taken for all of the rest calls (if any)
*
*  \see ZDKCall, ActiveCallChange
*/
-(void)setActiveCall:(id<ZDKCall> _Nullable)call callChange:(ZDKActiveCallChange)callChange ;
/** \brief Creates a call with the default account
*
*  Creates a call with the ZDKAccountProvider's defaultAccount().
*
*  \param[in] calleeNumber  The number to be dialed
*  \param[in] video  Indicator whether the call to have video or not
*
*  \return The call
*
*  \see ZDKCall, defaultAccount()
*/
-(id<ZDKCall>)createCallWithDefaultAccount:(NSString*)calleeNumber video:(BOOL)video ;
/** \brief Adds a new calls provider event listener
*
*  All added listeners will be notified for each event.
*
*  \param[in] value  The calls provider event listener to be added
*
*  \see ZDKCallsProviderEventsHandler, dropActiveCallListener()
*/
-(void)addActiveCallListener:(id<ZDKCallsProviderEventsHandler>)value ;
/** \brief Removes a specific already added calls provider event listener
*
*  All added/left listeners will be notified for each event.
*
*  \param[in] value  The calls provider event listener to be removed
*
*  \see ZDKCallsProviderEventsHandler, addActiveCallListener()
*/
-(void)dropActiveCallListener:(id<ZDKCallsProviderEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
