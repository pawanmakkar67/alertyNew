//
// ZDKDNSRequest.h
// ZDK
//

#ifndef ZDKDNSRequest_h
#define ZDKDNSRequest_h

#import <Foundation/Foundation.h>
#import "ZDKDNSRequestEventsHandler.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKDNSRequestEventsHandler.h"
@protocol ZDKDNSRequestEventsHandler;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKDNSRequest <ZDKZHandle>

/** \brief Gets DNS handle
*
*  \return The dns handle
*/
@property(nonatomic, readonly) long int  dnsRequestHandle;

/** \brief Gets DNS Query
*
*  \return The dns query
*/
@property(nonatomic, readonly) NSString*  query;

/** \brief Start a DNS request
*
*  \param[in] query The host name to be requested
*
*  \return Result of the query start
*
*  \see ZDKResult
*/
-(id<ZDKResult>)start:(NSString*)query ;
/** \brief Set dns request events listener
*
*  \param[in] value The dns request event handler
*
*  \see  ZDKDNSRequestEventsHandler
*/
-(void)setStatusEventListener:(id<ZDKDNSRequestEventsHandler>)value ;
/** \brief Drop dns request events listener
*
*  \param[in] value The dns request event handler
*
*  \see  ZDKDNSRequestEventsHandler
*/
-(void)dropStatusEventListener:(id<ZDKDNSRequestEventsHandler>)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
