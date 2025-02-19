//
// ZDKConferenceEventsHandler.h
// ZDK
//

#ifndef ZDKConferenceEventsHandler_h
#define ZDKConferenceEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKConference.h"
#import "ZDKCall.h"
#import "ZDKEventHandle.h"
#import "ZDKConference.h"
@protocol ZDKConference;
#import "ZDKCall.h"
@protocol ZDKCall;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKConferenceEventsHandler <ZDKEventHandle>

@optional

/** \brief Call was added to the conference
*
*  Confirmation that the call has joined the conference.
*
*  \param[in] conf  The conference
*  \param[in] call  The call that has joined it
*
*  \see ZDKConference, ZDKCall
*/
-(void)onConf:(id<ZDKConference>)conf erenceParticipantJoined:(id<ZDKCall>)call ;
/** \brief Call was removed from the conference
*
*  Confirmation that the call has left the conference
*
*  Can also happen if a call, part of a conference was moved to another conference.
*
*  \param[in] conf  The conference
*  \param[in] call  The call that has left it
*
*  \see ZDKConference, ZDKCall
*/
-(void)onConf:(id<ZDKConference>)conf erenceParticipantRemoved:(id<ZDKCall>)call ;
/** \brief Notify upon error on Conference
*
*  The event is notifying upon an error ocurring on the conference, it provides error message in string format
*
*  \param[in] conf  The conference
*  \param[in] message  The error message
*
*  \see ZDKConference
*/
-(void)onConf:(id<ZDKConference>)conf erenceExtendedError:(NSString*)message ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
