//
// ZDKDNSRequestProvider.h
// ZDK
//

#ifndef ZDKDNSRequestProvider_h
#define ZDKDNSRequestProvider_h

#import <Foundation/Foundation.h>
#import "ZDKDNSRequest.h"
#import "ZDKResult.h"
#import "ZDKZHandle.h"
#import "ZDKDNSRequest.h"
@protocol ZDKDNSRequest;
#import "ZDKResult.h"
@protocol ZDKResult;

NS_ASSUME_NONNULL_BEGIN

/** \brief DNS resolving requests provider
*/
@protocol ZDKDNSRequestProvider <ZDKZHandle>

/** \brief Creates a new EMPTY DNS resolve requst
*
*  \return Empty DNS request
*
*  \see DNSRequest
*/
-(id<ZDKDNSRequest>)createDNSRequest;
/** \brief Sets a list with additional name servers
*
*  Sets name servers to be used by ARES for DNS resolving in addition to the system ones. They will be added at the
*  end of the system name servers list and be used as a fallback.
*
*  Does not overwrite the system name servers!!!
*
*  Adding additional name servers could be done at any time!
*
*  Each list with name server will override any previously set ones by this API and will reset the DNS sybsystem.
*
*  \param[in] value  The additional name servers to be used
*  \return  Result of the addition
*
*  \see ZDKResult
*/
-(id<ZDKResult>)setAdditionalNameServers:(NSArray*)value ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
