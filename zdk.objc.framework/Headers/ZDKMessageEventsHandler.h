//
// ZDKMessageEventsHandler.h
// ZDK
//

#ifndef ZDKMessageEventsHandler_h
#define ZDKMessageEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKMessage.h"
#import "ZDKMessageStatus.h"
#import "ZDKExtendedError.h"
#import "ZDKEventHandle.h"
#import "ZDKMessage.h"
@protocol ZDKMessage;
#import "ZDKExtendedError.h"
@protocol ZDKExtendedError;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKMessageEventsHandler <ZDKEventHandle>

@optional

/** \brief Notify Message's status changed
*
*  Notify upon message status is changed
*
*  \param[in] msg  The message which status is changed
*  \param[in] status  The new message status
*
*  \see ZDKMessage, MessageStatus
*/
-(void)onMessageStatusChanged:(id<ZDKMessage>)msg status:(ZDKMessageStatus)status ;
/** \brief Notify Message error occured
*
*  Notify Message error occured
*
*  \param[in] msg  The message that experienced the error
*  \param[in] error  The error that occured
*
*  \see ZDKMessage, ExtendedError
*/
-(void)onMessageExtendedError:(id<ZDKMessage>)msg error:(id<ZDKExtendedError>)error ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
