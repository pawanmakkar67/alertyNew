//
// ZDKUploadProgress.h
// ZDK
//

#ifndef ZDKUploadProgress_h
#define ZDKUploadProgress_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Upload progress
*
*  Describes the current upload progress state.
*/
@protocol ZDKUploadProgress <ZDKZHandle>

/** \brief Completion in percent
*
*  Completion in percent or -1 in case upload size is not known in advance.
*
*  \return Completion in percent
*/
@property(nonatomic, readonly) int  percentComplete;

/** \brief Total number of sucessfully uploaded octets
*
*  Total number of sucessfully uploaded octets/bytes (always known).
*
*  \return Total number of sucessfully uploaded octets
*/
@property(nonatomic, readonly) long long  octetsComplete;

/** \brief Total number of octets/bytes to be uploaded
*
*  Total number of octets/bytes to be uploaded or -1 in case the size is not known in advance.
*
*  \return Total number of octets/bytes to be uploaded
*/
@property(nonatomic, readonly) long long  totalOctets;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
