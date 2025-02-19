//
// ZDKExtendedError.h
// ZDK
//

#ifndef ZDKExtendedError_h
#define ZDKExtendedError_h

#import <Foundation/Foundation.h>
#import "ZDKProtocolType.h"
#import "ZDKLayerType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKExtendedError <ZDKZHandle>

/** \brief Gets extended error id
*
*  \return The extended error id
*/
@property(nonatomic, readonly) int  id;

/** \brief Gets Q.931 code
*
*  The function gets the Q.931 (ZDKSDN) code
*
*  \return The Q.931 code
*/
@property(nonatomic, readonly) int  q931Code;

/** \brief Gets the extended error protocol type
*
*  \return The protocol type
*
*  \see ProtocolType
*/
@property(nonatomic, readonly) ZDKProtocolType  proto;

/** \brief Gets the extended error layer type
*
*  \return The layer type
*
*  \see LayerType
*/
@property(nonatomic, readonly) ZDKLayerType  layer;

/** \brief Gets the extended error layer code
*
*  \return The layer code
*/
@property(nonatomic, readonly) int  layerCode;

/** \brief Gets the extended error message
*
*  \return The message
*/
@property(nonatomic, readonly) NSString*  message;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
