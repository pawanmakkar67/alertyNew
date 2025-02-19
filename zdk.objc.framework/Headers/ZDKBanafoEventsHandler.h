//
// ZDKBanafoEventsHandler.h
// ZDK
//

#ifndef ZDKBanafoEventsHandler_h
#define ZDKBanafoEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKBanafoServiceState.h"
#import "ZDKBanafoRequestState.h"
#import "ZDKBanafoEventType.h"
#import "ZDKBanafoEventState.h"
#import "ZDKBanafoContactSearchCriteria.h"
#import "ZDKPagination.h"
#import "ZDKBanafoContact.h"
#import "ZDKBanafoIntegration.h"
#import "ZDKBanafoProfile.h"
#import "ZDKTranscriptLanguage.h"
#import "ZDKEventHandle.h"
#import "ZDKBanafoServiceState.h"
@protocol ZDKBanafoServiceState;
#import "ZDKBanafoRequestState.h"
@protocol ZDKBanafoRequestState;
#import "ZDKBanafoEventState.h"
@protocol ZDKBanafoEventState;
#import "ZDKBanafoContactSearchCriteria.h"
@protocol ZDKBanafoContactSearchCriteria;
#import "ZDKPagination.h"
@protocol ZDKPagination;
#import "ZDKBanafoProfile.h"
@protocol ZDKBanafoProfile;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKBanafoEventsHandler <ZDKEventHandle>

@optional

/** \brief Banafo Service state changed
*
*  This callback is used to monitor a Banafo Service state. It is called whenever the state changes.
*
*  \param[in] state  The new state of the Banafo Service
*
*  \see ZDKBanafoServiceState
*/
-(void)onServiceState:(id<ZDKBanafoServiceState> _Nullable)state ;
/** \brief Banafo Service request state changed
*
*  This callback is used to monitor a Banafo Service request state.
*
*  \param[in] requestId  The Banafo Service request handler this state change corresponds to
*  \param[in] state  The new state of the Banafo request
*
*  \see ZDKBanafoRequestState
*/
-(void)onRequestState:(long int)requestId state:(id<ZDKBanafoRequestState> _Nullable)state ;
/** \brief Banafo Service event state changed
*
*  This callback is used to monitor an internally created Banafo Service request state.
*
*  \param[in] event  The ZDK event triggered internally created the Banafo Service request
*  \param[in] state  The state of the Banafo Service event
*
*  \see BanafoEventType, ZDKBanafoEventState
*/
-(void)onEvent:(ZDKBanafoEventType)event state:(id<ZDKBanafoEventState> _Nullable)state ;
/** \brief Banafo contact list received
*
*  This callback is invoked when the Banafo Contact list is being received after zdkBanafoManager::ListContacts() request
*
*  \param[in] requestId  The list contact request ID
*  \param[in] searchCriteria  The search criteria used for obtaining the contact list
*  \param[in] state  The current full state of the Banafo Contact Search request
*  \param[in] pagination  The pagination used by the Banafo server for paged searching
*  \param[in] contactsList  Result of the contacts search
*
*  \see ZDKBanafoContactSearchCriteria, ZDKBanafoRequestState, ZDKPagination, ZDKBanafoContact
*/
-(void)onContactList:(long int)requestId searchCriteria:(id<ZDKBanafoContactSearchCriteria> _Nullable)searchCriteria state:(id<ZDKBanafoRequestState> _Nullable)state pagination:(id<ZDKPagination> _Nullable)pagination contactsList:(NSArray* _Nullable)contactsList ;
/** \brief Banafo integrations list received
*
*  This callback is invoked when the Banafo Integrations list is being received after ZDKBanafoManager::ListIntegrations request
*
*  \param[in] requestId  The list integrations request ID
*  \param[in] state  The current full state of the Banafo Integration List request
*  \param[in] integrationsList  List of Banafo CRM integrations
*
*  \see ZDKBanafoManager, ZDKBanafoIntegration
*/
-(void)onIntegrationList:(long int)requestId state:(id<ZDKBanafoRequestState>)state integrationsList:(NSArray* _Nullable)integrationsList ;
/** \brief Banafo profile received
*
*  This callback is invoked when the Banafo profile is being received after ZDKBanafoManager::GetProfile request
*
*  \param[in] requestId  The profile request ID
*  \param[in] profile  The Banafo profile data
*
*  \see ZDKBanafoManager, ZDKBanafoProfile
*/
-(void)onProfile:(long int)requestId profile:(id<ZDKBanafoProfile> _Nullable)profile ;
/** \brief Banafo transcription language list received
*
*  This callback is invoked when the Banafo transcription language list is being received after WrapperContext::BanafoListTranscriptLanguages request
*
*  \param[in] requestId  The transcription language list request ID
*  \param[in] state  The current full state of the Banafo Transcription Language List request
*  \param[in] languageList  List of Banafo transcription languages
*
*  \see ZDKBanafoManager, ZDKTranscriptLanguage
*/
-(void)onTranscriptionLanguageList:(long int)requestId state:(id<ZDKBanafoRequestState>)state languageList:(NSArray* _Nullable)languageList ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
