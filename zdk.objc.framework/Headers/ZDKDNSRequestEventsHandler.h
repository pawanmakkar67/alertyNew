//
// ZDKDNSRequestEventsHandler.h
// ZDK
//

#ifndef ZDKDNSRequestEventsHandler_h
#define ZDKDNSRequestEventsHandler_h

#import <Foundation/Foundation.h>
#import "ZDKDNSRequest.h"
#import "ZDKEventHandle.h"
#import "ZDKDNSRequest.h"
@protocol ZDKDNSRequest;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKDNSRequestEventsHandler <ZDKEventHandle>

@optional

/** \brief DNS request finished successfully
*
*  \param[in] dns  The DNS request
*  \param[in] result  The result of the request
*
*  \see ZDKDNSRequest
*/
-(void)onDns:(id<ZDKDNSRequest>)dns result:(NSString*)result ;
/** \brief DNS request failed
*
*  \param[in] dns  The failed DNS request
*
*  \see ZDKDNSRequest
*/
-(void)onDnsfailed:(id<ZDKDNSRequest>)dns ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
