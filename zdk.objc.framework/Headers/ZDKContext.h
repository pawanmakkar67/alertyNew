//
// ZDKContext.h
// ZDK
//

#ifndef ZDKContext_h
#define ZDKContext_h

#import <Foundation/Foundation.h>
#import "ZDKCallsProvider.h"
#import "ZDKAccountProvider.h"
#import "ZDKConferenceProvider.h"
#import "ZDKDNSRequestProvider.h"
#import "ZDKContextConfiguration.h"
#import "ZDKEncryptionConfiguration.h"
#import "ZDKAudioEndpointControl.h"
#import "ZDKVideoEndpointControl.h"
#import "ZDKRingBackToneControl.h"
#import "ZDKActivation.h"
#import "ZDKLog.h"
#import "ZDKProxyManager.h"
#import "ZDKBanafoManager.h"
#import "ZDKProtocolType.h"
#import "ZDKContextEventsHandler.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKCallsProvider.h"
@protocol ZDKCallsProvider;
#import "ZDKAccountProvider.h"
@protocol ZDKAccountProvider;
#import "ZDKConferenceProvider.h"
@protocol ZDKConferenceProvider;
#import "ZDKDNSRequestProvider.h"
@protocol ZDKDNSRequestProvider;
#import "ZDKContextConfiguration.h"
@protocol ZDKContextConfiguration;
#import "ZDKEncryptionConfiguration.h"
@protocol ZDKEncryptionConfiguration;
#import "ZDKAudioEndpointControl.h"
@protocol ZDKAudioEndpointControl;
#import "ZDKVideoEndpointControl.h"
@protocol ZDKVideoEndpointControl;
#import "ZDKRingBackToneControl.h"
@protocol ZDKRingBackToneControl;
#import "ZDKActivation.h"
@protocol ZDKActivation;
#import "ZDKLog.h"
@protocol ZDKLog;
#import "ZDKProxyManager.h"
@protocol ZDKProxyManager;
#import "ZDKBanafoManager.h"
@protocol ZDKBanafoManager;
#import "ZDKContextEventsHandler.h"
@protocol ZDKContextEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief ZDK's main entry point
*/
@protocol ZDKContext <ZDKZHandle>

/** \brief Returnes whether the context is running and functional
*
*  \return Context's running state
*/
@property(nonatomic, readonly) BOOL  contextRunning;

/** \brief Gets the active calls information provider
*
*  \return The calls provider
*
*  \see ZDKCallsProvider
*/
@property(nonatomic, readonly) id<ZDKCallsProvider>  callsProvider;

/** \brief Gets the account information and control provider
*
*  Manages creation and destruction of user accounts and provides information regarding them.
*
*  \return The account provider
*
*  \see ZDKAccountProvider
*/
@property(nonatomic, readonly) id<ZDKAccountProvider>  accountProvider;

/** \brief Gets the conference controlling helper
*
*  \return The conference provider
*
*  \see ZDKConferenceProvider
*/
@property(nonatomic, readonly) id<ZDKConferenceProvider>  conferenceProvider;

/** \brief Gets the DNS resolving requests provider
*
*  \return The DNS resolving requests provider
*
*  \see ZDKDNSRequestProvider
*/
@property(nonatomic, readonly) id<ZDKDNSRequestProvider>  dnsRequestProvider;

/** \brief Gets the general ZDK/Context configuration
*
*  The configuration is applied with startContext()! Any changes after startContext() has been invoked will not take
*  effect until a restart happens - stopContext() followed by startContext().
*
*  \return The context configuration
*
*  \see ZDKContextConfiguration
*/
@property(nonatomic, readonly) id<ZDKContextConfiguration>  configuration;

/** \brief Gets the encription specific configuration
*
*  \return The encription configuration
*
*  \see ZDKEncryptionConfiguration
*/
@property(nonatomic, readonly) id<ZDKEncryptionConfiguration>  encryptionConfiguration;

/** \brief Gets the audio endpoint's main entry point
*
*  Entry point for controlling the audio endpoint
*
*  \return The audio endpoint control
*
*  \see ZDKAudioEndpointControl
*/
@property(nonatomic, readonly) id<ZDKAudioEndpointControl>  audioControls;

/** \brief Gets the video endpoint's main entry point
*
*  Entry point for controlling the video endpoint
*
*  \return The video endpoint control
*
*  \see ZDKVideoEndpointControl
*/
@property(nonatomic, readonly) id<ZDKVideoEndpointControl>  videoControls;

/** \brief Ringback tone's main entry point
*
*  Entry point for controlling the ringback tone heard by the user when the remote peer starts ringing
*
*  \return The ringback tone control
*
*  \see ZDKRingBackToneControl
*/
@property(nonatomic, readonly) id<ZDKRingBackToneControl>  ringback;

/** \brief Gets the ZDK's Activation process handler
*
*  \return The activation handler
*
*  \see ZDKActivation
*/
@property(nonatomic, readonly) id<ZDKActivation>  activation;

/** \brief Gets the ZDK's debug logging facility instance
*
*  Only a single instance of the debug logging facility is created and returned during the life time of the library.
*
*  \return The ZDK's debug logging facility instance
*
*  \see ZDKLog
*/
@property(nonatomic, readonly) id<ZDKLog>  logger;

/** \brief Gets the ZDK's proxy manager
*
*  \return The ZDK's proxy manager instance
*
*  \see ZDKProxyManager
*/
@property(nonatomic, readonly) id<ZDKProxyManager>  proxyManager;

/** \brief Gets the ZDK's Banafo manager
*
*  \return The ZDK's Banafo manager instance
*
*  \see ZDKBanafoManager
*/
@property(nonatomic, readonly) id<ZDKBanafoManager>  banafoManager;

/** \brief Get the ZDK version
*
*  Get the revision of the ZDK's source last commit.
*
*  \return The revision as an ASCII string.
*/
@property(nonatomic, readonly) NSString*  libraryVersion;

/** \brief Initialize the ZDK
*
*  Create all internal structures, protocol stacks, network transports and event queues. It will test the available
*  audio devices. It will spawn necessary processing threads. You must call stopContext() to close the network
*  transports, stop all threads and free all structures.
*
*  Do not call this function more than once in a row - use stopContext() to clean up and then you can call
*  startContext() again.
*
*  \return Result of the initialization
*
*  \see stopContext(), ZDKResult
*/
-(id<ZDKResult>)startContext;
/** \brief Destroys the ZDK
*
*  Closes network transports, terminates worker threads and frees all structures. You can call startContext() after
*  this to re-open the library.
*
*  This is a blocking call and will always take some time to finish but has a hard-limit of 2 seconds for IAX and
*  4 seconds for SIP which in the worst case means 6-7 seconds with some additional time for thread synchronisation.
*
*  \return Result of the initialization
*
*  \see startContext(), ZDKResult
*/
-(id<ZDKResult>)stopContext;
/** \brief Creates a call manager instance for a protocol
*
*  Creates a call manager instance for a specific protocol.
*
*  Protocol MUST be added before creating accounts using it!
*
*  Will be automatically destroyed by stopContext().
*
*  Some call managers are automatically created by startContext(). SIP cannot be created by this function.
*
*  \param[in] proto  Protocol
*  \param[in] port  Port at which to bind the main socket, or 0 for random port to be used
*
*  \return Result of the addition
*
*  \see ProtocolType, ZDKResult
*/
-(id<ZDKResult>)addProto:(ZDKProtocolType)proto col:(int)port ;
/*
*/
-(id<ZDKResult>)testSIPURI:(NSString*)sipUri ;
/** \brief Configures the context event listener
*
*  The set listener will be notified for each event.
*
*  \param[in] value  The context event listener to be added
*
*  \see ZDKContextEventsHandler
*/
-(void)setStatusListener:(id<ZDKContextEventsHandler>)value ;
/** \brief Notify the ZDK for changed network event
*
*  Handles the network change event - resets the DNS, re-register users, refreshes active calls, etc.
*
*  Each invocation restarts a timer delaying the execution of the handling with 500ms from the last received
*  event - if invoked more then once in the delay period, the handling will happen 500ms after the last call.
*
*  \return Result of the invocation
*
*  \see ZDKResult
*/
-(id<ZDKResult>)networkChanged;
/** \brief Force native crash
*
*  Forces a native crash to take place.
*
*  \param[in] delayMs Delay in milliseconds. If 0 - crashes immediately!
*/
-(void)forceNativeCrash:(unsigned int)delayMs ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
