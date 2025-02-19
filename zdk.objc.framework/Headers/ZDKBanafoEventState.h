//
// ZDKBanafoEventState.h
// ZDK
//

#ifndef ZDKBanafoEventState_h
#define ZDKBanafoEventState_h

#import <Foundation/Foundation.h>
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Service event state
*
*  Describes the current full state of the automatically created Banafo Service events.
*/
@protocol ZDKBanafoEventState <ZDKZHandle>

/** \brief The result of the invernally created event
*
*  Shows the outcome of the event.
*
*  \return The result of the event
*
*  \see ZDKResult
*/
@property(nonatomic, readonly) id<ZDKResult>  _Nullable result;

/** \brief Object ID triggered the event
*
*  Indicates the ZDK object ID triggered the Banafo Service event.
*  E.g. For `BanafoEventType::Call*` events the `EventId()` would be `CallHandle`.
*
*  \return The object ID triggered the event
*
*  \see ZDKHandle
*/
@property(nonatomic, readonly) long int  eventId;

/** \brief Event specific data
*
*  Contains the event specific data. Currently used with the `BanafoEventType::*Finished` event types to deliver
*  the Banafo Event ID.
*
*  \return The event specific data
*/
@property(nonatomic, readonly) NSString*  _Nullable value;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
