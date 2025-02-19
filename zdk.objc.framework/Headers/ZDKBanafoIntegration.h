//
// ZDKBanafoIntegration.h
// ZDK
//

#ifndef ZDKBanafoIntegration_h
#define ZDKBanafoIntegration_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Integration
*
*  Describes the Banafo CRM Integration.
*/
@protocol ZDKBanafoIntegration <ZDKZHandle>

/** \brief Name of the integration
*
*  The name of the CRM integration.
*
*  \return The name of the CRM integration
*/
@property(nonatomic, readonly) NSString*  _Nullable name;

/** \brief Status of the integration
*
*  Status of the CRM integration.
*
*  \return Status of the integration
*/
@property(nonatomic, readonly) NSString*  _Nullable status;

/** \brief Creation date
*
*  Date of creation of the integration.
*
*  \return The date of creation of the integration.
*/
@property(nonatomic, readonly) NSString*  _Nullable createdAt;

/** \brief Update date
*
*  Date of last update of the integration.
*
*  \return The last update date of the integration.
*/
@property(nonatomic, readonly) NSString*  _Nullable updatedAt;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
