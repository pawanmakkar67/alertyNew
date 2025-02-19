//
// ZDKMessage.h
// ZDK
//

#ifndef ZDKMessage_h
#define ZDKMessage_h

#import <Foundation/Foundation.h>
#import "ZDKMessageType.h"
#import "ZDKMessageEventsHandler.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKMessageEventsHandler.h"
@protocol ZDKMessageEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKMessage <ZDKZHandle>

/** \brief Gets message handle
*
*  \return The message handle
*
*/
@property(nonatomic, readonly) long int  messageHandle;

/** \brief Gets the message type
*
*  \return the message type
*
*  \see  ZDKMessageType
*
*/
@property(nonatomic, readonly) ZDKMessageType  type;

/** \brief Sets the message peer
*
*  \param[in] value The name of the peer to set to
*
*/
@property(nonatomic) NSString*  peer;

/** \brief Sets the message content
*
*  \param[in] value The content of the message to be setted to
*
*/
@property(nonatomic) NSString*  content;

/** \brief Sends the message
*
*  \return The result of sending message
*
*/
-(id<ZDKResult>)sendMessage;
/** \brief Sets a message event listener
*
*  \param[in] value The message events handler
*
*/
-(void)setMessageEventListener:(id<ZDKMessageEventsHandler>)value ;
/** \brief Drops a message event listener
*
*  \param[in] value The message events handler
*
*/
-(void)dropMessageEventListener:(id<ZDKMessageEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
