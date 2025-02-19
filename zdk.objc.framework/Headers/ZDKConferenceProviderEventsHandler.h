//
// ZDKConferenceProviderEventsHandler.h
// ZDK
//

#ifndef ZDKConferenceProviderEventsHandler_h
#define ZDKConferenceProviderEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKConferenceProvider.h"
#import "ZDKConference.h"
#import "ZDKEventHandle.h"
#import "ZDKConferenceProvider.h"
@protocol ZDKConferenceProvider;
#import "ZDKConference.h"
@protocol ZDKConference;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKConferenceProviderEventsHandler <ZDKEventHandle>

@optional

/** \brief Event invoked upon succesful creation of conference
*
*  Invoked on successful creation of conference call.
*
*  \param[in] confProvider  The conference provider
*  \param[in] conference  The conference
*
*  \see ZDKConferenceProvider, ZDKConference
*
*/
-(void)onConferenceAdded:(id<ZDKConferenceProvider>)confProvider conference:(id<ZDKConference>)conference ;
/** \brief Event invoked upon removing a conference call
*
*  Invoked on removing a conference call.Conference is being removed by removing every call in it.
*  It is not allowed to have an empty conference, and that is why such are automatically destroyed
*  this event will be fired once a conference is empty.
*
*  \param[in] confProvider  The conference provider
*  \param[in] conference  The conference
*
*  \see ZDKConferenceProvider, ZDKConference
*
*/
-(void)onConferenceRemoved:(id<ZDKConferenceProvider>)confProvider conference:(id<ZDKConference>)conference ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
