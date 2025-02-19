//
// ZDKConference.h
// ZDK
//

#ifndef ZDKConference_h
#define ZDKConference_h

#import <Foundation/Foundation.h>
#import "ZDKCall.h"
#import "ZDKConferenceEventsHandler.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKConferenceEventsHandler.h"
@protocol ZDKConferenceEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKConference <ZDKCall, ZDKZHandle>

/** \brief Gets conference handle
*
*  The function returns the conference handler
*
*  \return The conference handle
*/
@property(nonatomic, readonly) long int  conferenceHandle;

/** \brief Gives the number of calls in conference
*
*  \return The number of calls
*/
@property(nonatomic, readonly) int  callsCount;

/** \brief Gives list with all calls in conference
*
*  \return The list with calls in conference
*/
@property(nonatomic, readonly) NSArray<id<ZDKCall>>*  calls;

/** \brief Adds a call to the conference
*
*  Adds a call to the conference.  If the call is already part of another conference, it will be moved.
*
*  \param[in] hCall The call to add to the conference
*
*  \return The result of the function
*
*  \see  ZDKCall, ZDKResult
*/
-(id<ZDKResult>)addCall:(id<ZDKCall>)hCall ;
/** \brief Removes a call from the conference
*
*  \param[in] hCall The call to remove from the conference
*  \param[in] hangUp boolean to hang up or not
*
*  \return The result of the function
*
*  \see  ZDKCall, ZDKResult
*/
-(id<ZDKResult>)removeCall:(id<ZDKCall>)hCall hangUp:(BOOL)hangUp ;
/** \brief Mute a call in the conference
*
*  \param[in] hCall The call to be muted
*
*  \return The result of muting
*
*  \see  ZDKCall, ZDKResult
*/
-(id<ZDKResult>)muteCall:(id<ZDKCall>)hCall ;
/** \brief Unmute a call in the conference
*
*  \param[in] hCall The call to be Unmute
*
*  \return The result of Unmute
*
*  \see  ZDKCall, ZDKResult
*/
-(id<ZDKResult>)unmuteCall:(id<ZDKCall>)hCall ;
/** \brief Checks if a call is part of conference
*
*  \param[in] hCall The call to be checked
*
*  \return True if the call is part of the conference, false otherwise
*/
-(BOOL)isCallFromConference:(long int)hCall ;
/** \brief Acquire video sink from call
*
*  \param[in] call The call which video sink to be aquired
*
*  \return Result of the acquiring
*/
-(id<ZDKResult>)acquireVideoSinkMngrFromCall:(id<ZDKCall>)call ;
/** \brief Set Conference Events Listener
*
*  \param[in] confEventHandler The conference event handler
*
*  \see  ZDKConferenceEventsHandler
*/
-(void)setConferenceEventsListener:(id<ZDKConferenceEventsHandler>)confEventHandler ;
/** \brief Drops Conference Events Listener
*
*  \param[in] confEventHandler The conference event handler
*
*  \see  ZDKConferenceEventsHandler
*/
-(void)dropConferenceEventsListener:(id<ZDKConferenceEventsHandler>)confEventHandler ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
