//
// ZDKBanafoProfile.h
// ZDK
//

#ifndef ZDKBanafoProfile_h
#define ZDKBanafoProfile_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo user profile
*
*  Describes the user Banafo profile.
*/
@protocol ZDKBanafoProfile <ZDKZHandle>

/** \brief Role of the user
*
*  \return The role of the user
*/
@property(nonatomic, readonly) NSString*  _Nullable role;

/** \brief Status of the user
*
*  \return The status of the user
*/
@property(nonatomic, readonly) NSString*  _Nullable status;

/** \brief Full name of the user
*
*  \return The full name of the user
*/
@property(nonatomic, readonly) NSString*  _Nullable name;

/** \brief Email of the user
*
*  \return The email of the user
*/
@property(nonatomic, readonly) NSString*  _Nullable email;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
