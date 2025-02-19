//
// ZDKResult.h
// ZDK
//

#ifndef ZDKResult_h
#define ZDKResult_h

#import <Foundation/Foundation.h>
#import "ZDKResultCode.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief API invocation status result
*
*  Indicates the status result of API's invocation
*/
@protocol ZDKResult <ZDKZHandle>

/** \brief Gets the text representation of the status result of API invocation
*
*  \return The text representation of the status result of API invocation
*/
@property(nonatomic, readonly) NSString*  text;

/** \brief Gets the code representation of the status result of API invocation
*
*  \return The code representation of the status result of API invocation
*
*  \see ResultCode
*/
@property(nonatomic, readonly) ZDKResultCode  code;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
