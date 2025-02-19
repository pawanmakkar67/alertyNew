//
// ZDKBanafoPhone.h
// ZDK
//

#ifndef ZDKBanafoPhone_h
#define ZDKBanafoPhone_h

#import <Foundation/Foundation.h>
#import "ZDKPhoneType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Phone
*
*  Describes the Banafo Phone.
*/
@protocol ZDKBanafoPhone <ZDKZHandle>

/** \brief Phone number type
*
*  The type of the phone number.
*
*  \return The phone type
*
*  \see PhoneType
*/
@property(nonatomic, readonly) ZDKPhoneType  type;

/** \brief Phone number
*
*  The phone number itself.
*
*  \return Phone number
*/
@property(nonatomic, readonly) NSString*  _Nullable number;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
