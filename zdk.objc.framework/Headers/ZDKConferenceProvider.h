//
// ZDKConferenceProvider.h
// ZDK
//

#ifndef ZDKConferenceProvider_h
#define ZDKConferenceProvider_h

#import <Foundation/Foundation.h>
#import "ZDKConference.h"
#import "ZDKBrandingInfo.h"
#import "ZDKCall.h"
#import "ZDKConferenceProviderEventsHandler.h"
#import "ZDKZHandle.h"
#import "ZDKBrandingInfo.h"
@protocol ZDKBrandingInfo;
#import "ZDKCall.h"
@protocol ZDKCall;
#import "ZDKConferenceProviderEventsHandler.h"
@protocol ZDKConferenceProviderEventsHandler;
#import "ZDKConference.h"
@protocol ZDKConference;

NS_ASSUME_NONNULL_BEGIN

/** \brief Conference controlling helper
*/
@protocol ZDKConferenceProvider <ZDKZHandle>

/** \brief Gets a list with all conferences
*
*  \return List with all conferences
*
*  \see ZDKConference
*/
@property(nonatomic, readonly) NSArray<id<ZDKConference>>*  listConferences;

/** \brief Gets the count of all conferences
*
*  \return The number of all conferences
*/
@property(nonatomic, readonly) int  conferencesCount;

/** \brief Gets the total count of calls in all conferences
*
*  \return The number of all calls in conferences
*/
@property(nonatomic, readonly) int  callsInConferences;

/** \brief Gets the conference branding info
*
*  \return The conference branding info
*
*  \see ZDKBrandingInfo
*/
@property(nonatomic, readonly) id<ZDKBrandingInfo>  _Nullable brandingInfo;

/** \brief Creates a new conferene with the provided calls
*
*  ZDKConferenceProviderEventsHandler's onConferenceAdded() is invoked on successful creation of the conference.
*  ZDKConferenceEventsHandler's onConferenceParticipantJoined() is invoked for each added call to the conferene.
*
*  Creating an empty conference (with empty calls list) is not supported!
*
*  To remove a conference simply remove all its calls/participants. It is not allowed to have an empty conference,
*  and that is why such are automatically destroyed! onConferenceRemoved() is invoked in this case.
*
*  \param[in] calls  List of the calls to be added in the conference
*
*  \return  The newly created conference
*
*  \see ZDKConference, ZDKConferenceEventsHandler, ZDKConferenceProviderEventsHandler
*/
-(id<ZDKConference>)createConference:(NSArray*)calls ;
/** \brief Gets the conference with the specified ID
*
*  Returns the conference with the specified ID if exist, otherwise a null pointer is returned.
*
*  \param[in] hConf  The ID of the requested conference

*  \return The requested conference if exists or null pointer otherwise
*/
-(id<ZDKConference> _Nullable)getConference:(long int)hConf ;
/** \brief Checks whether the call with the provided ID is part of any conference
*
*  Returns whether a call with the provided ID exists and is part of any active conference.
*
*  \param[in] hCall  The ID of the call to be searched for
*
*  \return
*  \li 0 - The call is not in conference, or does not exists at all
*  \li 1 - The call is in conference
*
*  \see conferenceContainingCall()
*/
-(BOOL)isCallInConference:(long int)hCall ;
/** \brief Gets the conference in which the provided call is part of
*
*  Returns the conference in which the given call is part of, if it is part of any, otherwise a null pointer is returned.
*
*  \param[in] call  The call to be searched for
*
*  \return The call's conference if exists or null pointer otherwise
*
*  \see isCallInConference()
*/
-(id<ZDKConference> _Nullable)conferenceContainingCall:(id<ZDKCall>)call ;
/** \brief Adds a new conference provider event listener
*
*  All added listeners will be notified for each event.
*
*  \param[in] value  The conference provider event listener to be added
*
*  \see ZDKConferenceProviderEventsHandler, dropConferenceProviderListener()
*/
-(void)addConferenceProviderListener:(id<ZDKConferenceProviderEventsHandler>)value ;
/** \brief Removes a specific already added conference provider event listener
*
*  All added/left listeners will be notified for each event.
*
*  \param[in] value  The conference provider event listener to be removed
*
*  \see ZDKConferenceProviderEventsHandler, addConferenceProviderListener()
*/
-(void)dropConferenceProviderListener:(id<ZDKConferenceProviderEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
