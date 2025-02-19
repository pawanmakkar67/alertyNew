//
// ZDKBanafoCall.h
// ZDK
//

#ifndef ZDKBanafoCall_h
#define ZDKBanafoCall_h

#import <Foundation/Foundation.h>
#import "ZDKOriginType.h"
#import "ZDKBanafoContact.h"
#import "ZDKZHandle.h"
#import "ZDKBanafoContact.h"
@protocol ZDKBanafoContact;

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Call
*
*  Describes the Banafo call. The `Origin()`, `Type()`, `Source()` and `StartedAt()` fields are MANDATORY!
*/
@protocol ZDKBanafoCall <ZDKZHandle>

/** \brief The Banafo Service's call ID.
*
*  The Banafo Service's call ID.
*
*  \return The Banafo Service's call ZDKD
*/
@property(nonatomic, readonly) NSString*  _Nullable banafoId;

/** \brief Summary of the call
*
*  Some descriptive text about the call.
*
*  \return The summary of the call
*/
@property(nonatomic, readonly) NSString*  _Nullable summary;

/** \brief Title of the call
*
*  Some title for the concersation.
*
*  \return The title of the call
*/
@property(nonatomic, readonly) NSString*  _Nullable title;

/** \brief The call's source
*
*  The conversation's source.
*
*  \return The call's source
*/
@property(nonatomic, readonly) NSString*  source;

/** \brief The call's origin
*
*  The originator of the call
*
*  \return The originator of the call
*
*  \see OriginType
*/
@property(nonatomic, readonly) ZDKOriginType  origin;

/** \brief Started time of the call
*
*  Time and date when call was initiated in ZDKSO 8601 Format.
*  Example: '2019-11-18T15:20:31.928Z'
*
*  \return The start time of the call
*/
@property(nonatomic, readonly) NSString*  startedAt;

/** \brief Acceptance time of the call
*
*  Time and date when call was accepted in ZDKSO 8601 Format.
*  Example: '2019-11-18T15:20:32.728Z'
*
*  \return The start time of the call
*/
@property(nonatomic, readonly) NSString*  _Nullable acceptedAt;

/** \brief Ending time of the call
*
*  Time and date when call was finished in ZDKSO 8601 Format.
*  Example: '2019-11-18T15:22:12.422Z'
*
*  \return The start time of the call
*/
@property(nonatomic, readonly) NSString*  _Nullable finishedAt;

/** \brief Type of the call
*
*  The type of conversation, for phone calls the type should be set as `phone-call`.
*
*  \return The type of the call
*/
@property(nonatomic, readonly) NSString*  type;

/** \brief Local user's phone number
*
*  Local user's phone number.
*
*  \return The local user's phone number
*/
@property(nonatomic, readonly) NSString*  _Nullable localPhone;

/** \brief Remote user's phone number
*
*  Remote user's phone number
*
*  \return The remote user's phone number
*/
@property(nonatomic, readonly) NSString*  _Nullable remotePhone;

/** \brief Remote user's contact
*
*  Remote user's contact.
*
*  \return The remote user's contact
*/
@property(nonatomic, readonly) id<ZDKBanafoContact>  _Nullable contact;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
