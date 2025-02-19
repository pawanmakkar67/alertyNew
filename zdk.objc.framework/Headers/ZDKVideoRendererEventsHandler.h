//
// ZDKVideoRendererEventsHandler.h
// ZDK
//

#ifndef ZDKVideoRendererEventsHandler_h
#define ZDKVideoRendererEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKEventHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKVideoRendererEventsHandler <ZDKEventHandle>

@optional

/** \brief Video frame is received
*
*  A video frame data is received. The dimensions of the frame are provided.
*
*  \param[in] pBuffer  Frame buffer
*  \param[in] length  The length of the frame
*  \param[in] width  The width of the frame in pixels
*  \param[in] height  The height of the frame in pixels
*/
-(void)onVideoFrameReceived:(unsigned char*)pBuffer length:(int)length width:(int)width height:(int)height ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
