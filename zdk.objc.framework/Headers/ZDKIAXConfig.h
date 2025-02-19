//
// ZDKIAXConfig.h
// ZDK
//

#ifndef ZDKIAXConfig_h
#define ZDKIAXConfig_h

#import <Foundation/Foundation.h>
#import "ZDKIAXConfig.h"
#import "ZDKZHandle.h"
#import "ZDKIAXConfig.h"
@protocol ZDKIAXConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief IAX specific account configuration
*/
@protocol ZDKIAXConfig <ZDKZHandle>

/** \brief Configures the server/host address to be used
*
*  \param[in] value  The server/host address
*/
@property(nonatomic) NSString*  host;

/** \brief Configures the context to be used
*
*  \param[in] value  The context
*/
@property(nonatomic) NSString*  context;

/** \brief Configures the caller ID used for identification
*
*  \param[in] value  The caller ID to be used
*/
@property(nonatomic) NSString*  _Nullable callerID;

/** \brief Configures the caller number used for identification
*
*  \param[in] value  The caller number to be used
*/
@property(nonatomic) NSString*  _Nullable callerNumber;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  IAX configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKIAXConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
