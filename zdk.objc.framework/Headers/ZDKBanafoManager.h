//
// ZDKBanafoManager.h
// ZDK
//

#ifndef ZDKBanafoManager_h
#define ZDKBanafoManager_h

#import <Foundation/Foundation.h>
#import "ZDKBanafoContact.h"
#import "ZDKBanafoContactSearchCriteria.h"
#import "ZDKContactType.h"
#import "ZDKBanafoPhone.h"
#import "ZDKOriginType.h"
#import "ZDKRecordingType.h"
#import "ZDKRecordingStream.h"
#import "ZDKBanafoCall.h"
#import "ZDKBanafoRecording.h"
#import "ZDKBanafoEventsHandler.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKBanafoContact.h"
@protocol ZDKBanafoContact;
#import "ZDKBanafoContactSearchCriteria.h"
@protocol ZDKBanafoContactSearchCriteria;
#import "ZDKBanafoCall.h"
@protocol ZDKBanafoCall;
#import "ZDKBanafoRecording.h"
@protocol ZDKBanafoRecording;
#import "ZDKBanafoEventsHandler.h"
@protocol ZDKBanafoEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;
#import "ZDKRecordingStream.h"
@protocol ZDKRecordingStream;

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Service Manager
*/
@protocol ZDKBanafoManager <ZDKZHandle>

/** \brief Set up and Start the Banafo Service
*
*  Setup and start the Banafo Service that can be used to query data, upload files, etc to the Banafo Web Service.
*
*  Upon starting the Banafo Service it will automatically start getting its well known configuration from the Banafo Web service i.e. change
*  state to 'BanafoServiceStateType::Configuring'.
*
*  \param[in] schemeAndAuthority  The scheme and authority where the Banafo Service is located. This is a required parameter and if empty string
*                                 is provided the function will fail with 'ResultCode::InvalidArgument'.
*  \param[in] basePath  The base path used for the Banafo Service. It doesn't change between requests. This is a required parameter and if empty
*                       string is provided the function will fail with 'ResultCode::InvalidArgument'.
*  \param[in] clientID  The client ID used by the Banafo Web Service to identify the application. The application must be registered in the
*                       Banafo Web service beforehand so that a client ID can be obtained. This is a required parameter and if empty string is
*                       provided the function will fail with 'ResultCode::InvalidArgument'.
*
*  \return  Result of the invocation
*
*  \see ZDKResult, BanafoServiceStateType, stop()
*/
-(id<ZDKResult>)start:(NSString*)schemeAndAuthority basePath:(NSString*)basePath clientID:(NSString*)clientID ;
/** \brief Stops the Banafo Service
*
*  Stops the already started Banafo Service along all requests associated with it.
*
*  \return  Result of the invocation
*
*  \see ZDKResult, start()
*/
-(id<ZDKResult>)stop;
/** \brief Starts Banafo Service authorization process
*
*  Starts a Banafo Service authorization sequence. The authorization is done using OAuth2.0 device flow.
*  To be able to start authorization process the Banafo Service must be in 'BanafoServiceStateType::Ready' state.
*
*  \return  Result of the invocation
*
*  \see ZDKResult, BanafoServiceStateType, cancelAuthorization()
*/
-(id<ZDKResult>)startAuthorization;
/** \brief Cancels Banafo Service authorization process
*
*  Cancels the Banafo Service authorization process.
*
*  To be able to cancel the authorization process the Banafo Service must be authorizing i.e. to be in 'BanafoServiceStateType::Ready' or
*  'BanafoServiceStateType::VerifyingAuthorizing' state.
*
*  \return  Result of the invocation
*
*  \see ZDKResult, BanafoServiceStateType, cancelAuthorization()
*/
-(id<ZDKResult>)cancelAuthorization;
/** \brief Set Banafo Service authorization tokens
*
*  Sets the Banafo Service authorization tokens explicitly so there will be no need of authorization process to take place for this service
*  before it is able to be used.
*
*  To be able to set tokens the Banafo Service must be in 'BanafoServiceStateType::Ready' state.
*
*  \param[in] accessToken  The access token for the service. It can be left empty and a new access token will be obtained from the refresh token.
*  \param[in] refreshToken  The refresh token for the service. This is a required parameter and if empty string is provided the function will
*                           fail with 'ResultCode::InvalidArgument'.
*
*  \return  Result of the invocation
*
*  \see ZDKResult, BanafoServiceStateType, startAuthorization()
*/
-(id<ZDKResult>)setTokens:(NSString* _Nullable)accessToken refreshToken:(NSString*)refreshToken ;
/** \brief Cancels a Banafo Service request
*
*  Cancels an already running Banafo service request and discards any results that might be received. The request is destroyed.
*
*  \param[in] requestId  The Banafo Service request handler that is going to be canceled. If invalid handler is provided the function will fail
*                        with 'ResultCode::NotFound'.
*
*  \return  Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)cancelRequest:(long int)requestId ;
/** \brief Updates contact information to a call
*
*  Updates contact information to a Banafo call.
*
*  \param[in] banafoCallId  The Banafo call identifier. This is a required parameter and if empty string is provided the function will fail with
*                           'ResultCode::InvalidArgument'.
*  \param[in] contact  The new contact data. This is a required parameter and if empty string is provided the function will fail with
*                      'ResultCode::InvalidArgument'.
*
*  \return  Result of the invocation
*
*  \see ZDKResult, ZDKBanafoContact
*/
-(id<ZDKResult>)setCallContact:(NSString*)banafoCallId contact:(id<ZDKBanafoContact>)contact ;
/** \brief List contacts based on serch criterias
*
*  Provides a list of contacts that can come from local or external resources. In order to get local contacts the 'provider' should be set to
*  "banafo". If no provider specified - contacts from all active external providers will be returned.
*  By default the response will contain the maximum number of contacts as per the provider's limits per request.
*
*  For basic filtering use the search parameter, for filtering by phone number only using the 'phone' field might generate better results for
*  depending on the providers.
*
*  In case a Reverse Lookup is desired, the ZDKBanafoContactSearchCriteria's 'ReverseLookup()' must be set to 'true', 'Region()' and 'Phone()' MUST
*  be set while all other parameters will be discarded! In case they are empty strings, this function will fail and return 'ZDKInvalidHandle'.
*
*  Upon success, the zdkBanafoEventsHandler::OnContactList() will be invoked delivering the contacts.
*
*  \param[in] criteria  The search criteria to be used for the contact listing. This is a required parameter and if empty/NULL is provided the
*                       function will and return 'ZDKInvalidHandle'.
*
*  \return  The Banafo Service request ID corresponding to this list contacts search
*
*  \see ZDKBanafoContactSearchCriteria, ZDKBanafoEventsHandler, cancelRequest()
*/
-(long int)listContacts:(id<ZDKBanafoContactSearchCriteria>)criteria ;
/** \brief List CRM integrations
*
*  Provides a list of all active integrations for the authenticated user with a provider from the list.
*
*  Upon success, the 'ZDKBanafoEventsHandler::OnIntegrationsList will be invoked delivering the integrations.
*
*  \return  The Banafo Service request ID corresponding to this list integrations search
*
*  \see ZDKBanafoEventsHandler, cancelRequest()
*/
-(long int)listIntegrations;
/** \brief Upload audio recording file to the Banafo server
*
*  Adds a multipart/form-data recording file upload as described by W3C here: https:
*  and RFC 7578.
*
*  The advertised file name is retrieved from the passed 'filePathUtf8' by stripping the path itself.
*
*  The advertised mime type is retrieved from the passed 'filePathUtf8' by extracting the file extension. In case there is no file extension a
*  'audio/wav' mime is assumed.
*
*  \param[in] banaforRecordingId  The Banafo file identifier received by the 'ZDKBanafoEventsHandler::OnEventState' callback once the call
*                                 recording is started. This is a required parameter and if empty string is provided the function will fail and
*                                 return 'ZDKInvalidHandle'.
*  \param[in] filePathUtf8  Full pathname of the file to upload. The file must reside on the local system and must be accessible by the library.
*                           This is a required parameter and if empty string is provided the function will fail and return 'ZDKInvalidHandle'.
*
*  \return  The Banafo Service request ID corresponding to this upload request
*
*  \see ZDKBanafoEventsHandler, cancelRequest()
*/
-(long int)uploadRecording:(NSString*)banaforRecordingId filePathUtf8:(NSString*)filePathUtf8 ;
/** \brief Creates a BanafoContactSearchCriteria object
*
*  Creates a BanafoContactSearchCriteria object to be used for listContacts()
*
*  \param[in] contactId  See ZDKBanafoContactSearchCriteria
*  \param[in] provider  See ZDKBanafoContactSearchCriteria
*  \param[in] search  See ZDKBanafoContactSearchCriteria
*  \param[in] types  See ZDKBanafoContactSearchCriteria
*  \param[in] phone  See ZDKBanafoContactSearchCriteria
*  \param[in] nationalNumber  See ZDKBanafoContactSearchCriteria
*  \param[in] reverseLookup  See ZDKBanafoContactSearchCriteria
*  \param[in] region  See ZDKBanafoContactSearchCriteria
*  \param[in] start  See ZDKBanafoContactSearchCriteria
*  \param[in] limit  See ZDKBanafoContactSearchCriteria
*  \param[in] pageId  See ZDKBanafoContactSearchCriteria
*
*  \return  The newly created ZDKBanafoContactSearchCriteria object
*
*  \see ZDKBanafoContactSearchCriteria, listContacts()
*/
-(id<ZDKBanafoContactSearchCriteria>)createContactSearchCriteria:(NSString* _Nullable)contactId provider:(NSString* _Nullable)provider search:(NSString* _Nullable)search types:(NSArray* _Nullable)types phone:(NSString* _Nullable)phone nationalNumber:(NSString* _Nullable)nationalNumber reverseLookup:(BOOL)reverseLookup region:(NSString* _Nullable)region start:(int)start limit:(int)limit pageId:(NSString* _Nullable)pageId ;
/** \brief Creates a BanafoContact object
*
*  Creates a BanafoContact object that can be used with setCallContact()
*
*  \param[in] banafoId  See ZDKBanafoContact
*  \param[in] remoteId  See ZDKBanafoContact
*  \param[in] remoteProvider  See ZDKBanafoContact
*  \param[in] displayName  See ZDKBanafoContact
*  \param[in] firstName  See ZDKBanafoContact
*  \param[in] middleName  See ZDKBanafoContact
*  \param[in] lastName  See ZDKBanafoContact
*  \param[in] type  See ZDKBanafoContact
*  \param[in] url  See ZDKBanafoContact
*  \param[in] company  See ZDKBanafoContact
*  \param[in] emails  See ZDKBanafoContact
*  \param[in] phones  See ZDKBanafoContact
*
*  \return  The newly created ZDKBanafoContactSearchCriteria object
*
*  \see ZDKBanafoContact, setCallContact()
*/
-(id<ZDKBanafoContact>)createContact:(NSString* _Nullable)banafoId remoteId:(NSString* _Nullable)remoteId remoteProvider:(NSString* _Nullable)remoteProvider displayName:(NSString* _Nullable)displayName firstName:(NSString* _Nullable)firstName middleName:(NSString* _Nullable)middleName lastName:(NSString* _Nullable)lastName type:(ZDKContactType)type url:(NSString* _Nullable)url company:(NSString* _Nullable)company emails:(NSArray* _Nullable)emails phones:(NSArray* _Nullable)phones ;
/** \brief Creates a BanafoCall object
*
*  Creates a BanafoCall object
*
*  \param[in] banafoId  See ZDKBanafoCall
*  \param[in] summary  See ZDKBanafoCall
*  \param[in] title  See ZDKBanafoCall
*  \param[in] source  See ZDKBanafoCall
*  \param[in] origin  See ZDKBanafoCall
*  \param[in] startedAt  See ZDKBanafoCall
*  \param[in] acceptedAt  See ZDKBanafoCall
*  \param[in] finishedAt  See ZDKBanafoCall
*  \param[in] type  See ZDKBanafoCall
*  \param[in] localPhone  See ZDKBanafoCall
*  \param[in] remotePhone  See ZDKBanafoCall
*  \param[in] contact  See ZDKBanafoCall
*
*  \return  The newly created ZDKBanafoCall object
*
*  \see ZDKBanafoCall
*/
-(id<ZDKBanafoCall>)createCall:(NSString* _Nullable)banafoId summary:(NSString* _Nullable)summary title:(NSString* _Nullable)title source:(NSString*)source origin:(ZDKOriginType)origin startedAt:(NSString*)startedAt acceptedAt:(NSString* _Nullable)acceptedAt finishedAt:(NSString* _Nullable)finishedAt type:(NSString*)type localPhone:(NSString* _Nullable)localPhone remotePhone:(NSString* _Nullable)remotePhone contact:(id<ZDKBanafoContact> _Nullable)contact ;
/** \brief Creates a RecordingStream object
*
*  Creates a RecordingStream object
*
*  \param[in] origin  See ZDKRecordingStream
*  \param[in] type  See ZDKRecordingStream
*  \param[in] fileName  See ZDKRecordingStream
*  \param[in] languageCode  See ZDKRecordingStream
*
*  \return  The newly created ZDKRecordingStream object
*
*  \see ZDKRecordingStream
*/
-(id<ZDKRecordingStream>)createRecordingStream:(ZDKRecordingType)origin type:(NSString*)type fileName:(NSString*)fileName languageCode:(NSString* _Nullable)languageCode ;
/** \brief Creates a BanafoRecording object
*
*  Creates a BanafoRecording object
*
*  \param[in] banafoId  See ZDKBanafoRecording
*  \param[in] startedAt  See ZDKBanafoRecording
*  \param[in] finishedAt  See ZDKBanafoRecording
*  \param[in] banafoCallId  See ZDKBanafoRecording
*  \param[in] streams  See ZDKBanafoRecording
*
*  \return  The newly created ZDKBanafoRecording object
*
*  \see ZDKBanafoRecording
*/
-(id<ZDKBanafoRecording>)createRecording:(NSString* _Nullable)banafoId startedAt:(NSString*)startedAt finishedAt:(NSString* _Nullable)finishedAt banafoCallId:(NSString*)banafoCallId streams:(NSArray*)streams ;
/** \brief Force creates Banafo Call at the Banafo Service
*
*  Manually creates call on the Banafo Server. In case 'ZDKBanafoCall::BanafoId()' is set, a request to update that already existing call, instead
*  of creating a new one, will be made.
*
*  Upon completion the 'ZDKBanafoEventsHandler::OnEventState' callback will be invoked delivering the result of the request and the 'banafo call id'
*  when creating new calls.
*
*  The `ZDKBanafoCall::Origin()`, `ZDKBanafoCall::Type()`, `ZDKBanafoCall::Source()` and `ZDKBanafoCall::StartedAt()` fields are MANDATORY! If any of them
*  is missing, the function will return `ZDKInvalidHandle`!
*
*  !!! Do not use for calls made through the ZDK as it will duplicate the calls on Banafo !!!
*
*  \param[in] call  The call to be created at the Banafo Service
*
*  \return  The Banafo Service request ID corresponding to this create request
*
*  \see ZDKBanafoCall, ZDKBanafoEventsHandler, cancelRequest()
*/
-(long int)forceCreateCallatServer:(id<ZDKBanafoCall>)call ;
/** \brief Force creates Banafo Recording at the Banafo Service
*
*  Manually creates call recording on the Banafo Server. In case 'ZDKBanafoRecording::BanafoId()' is set, a request to update that already existing
*  recording, instead of creating a new one, will be made.
*
*  Upon completion the 'ZDKBanafoEventsHandler::OnEventState' callback will be invoked delivering the result of the request and the 'banafo recording id'
*  when creating new recording. That ID can later be used to upload the actual file to the Banafo Server via uploadRecording().
*
*  The `ZDKBanafoRecording::BanafoCallId()` field is MANDATORY! If missing, the function will return `ZDKInvalidHandle`!
*
*  !!! Do not use for recordings made through the ZDK as it will duplicate them on Banafo !!!
*
*  \param[in] recording  The recording to be created at the Banafo Service
*
*  \return  The Banafo Service request ID corresponding to this create request
*
*  \see ZDKBanafoRecording, ZDKBanafoEventsHandler, cancelRequest(), uploadRecording()
*/
-(long int)forceCreateRecordingatServer:(id<ZDKBanafoRecording>)recording ;
/** \brief Get Banafo profile
*
*  Gets Banafo user profile information.
*
*  Upon completion the 'ZDKBanafoEventsHandler::OnProfile' callback will be invoked delivering the result of the request.
*
*  \return  The Banafo Service request ID corresponding to this list profile retrieval
*
*  \see ZDKBanafoEventsHandler, cancelRequest()
*/
-(long int)getProfile;
/** \brief List Banafo transcript languages
*
*  Lists Banafo transcript languages.
*
*  Upon completion the 'ZDKBanafoEventsHandler::OnTranscriptLanguageList' callback will be invoked delivering the result of the request.
*
*  \return  The Banafo Service request ID corresponding to this list transcript languages request
*
*  \see ZDKBanafoEventsHandler, cancelRequest()
*/
-(long int)listTranscriptLanguages;
/** \brief Adds a new Banafo Service event listener
*
*  All added listeners will be notified for each event.
*
*  \param[in] value  The Banafo Service event listener to be added
*
*  \see ZDKBanafoEventsHandler, dropBanafoListener()
*/
-(void)addBanafoListener:(id<ZDKBanafoEventsHandler>)value ;
/** \brief Removes a specific already added Banafo Service event listener
*
*  All added/left listeners will be notified for each event.
*
*  \param[in] value  The Banafo Service event listener to be removed
*
*  \see ZDKBanafoEventsHandler, addBanafoListener()
*/
-(void)dropBanafoListener:(id<ZDKBanafoEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
