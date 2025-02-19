//
// ZDKHeaderField.h
// ZDK
//

#ifndef ZDKHeaderField_h
#define ZDKHeaderField_h

#import <Foundation/Foundation.h>
#import "ZDKSipMethodTypes.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief SIP header fields structure
*
*  An ZDKHeaderField object is created via zdkAccountProvider::CreateSIPHeaderField()
*
*  \see onAccountSipHeaderField(), onCallSipHeaderFields(), zdkAccountProvider::CreateSIPHeaderField()
*/
@protocol ZDKHeaderField <ZDKZHandle>

/** \brief The Name of the SIP header field
*
*  \return The Name of the SIP header field
*/
@property(nonatomic, readonly) NSString*  name;

/** \brief List of header field values
*
*  \return List of header field values
*/
@property(nonatomic, readonly) NSArray*  _Nullable values;

/** \brief The SIP Method this header is allowed to be put at/comming from
*
*  \return The SIP Method this header is associeted with
*
*  \see SipMethodTypes
*/
@property(nonatomic, readonly) ZDKSipMethodTypes  method;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
