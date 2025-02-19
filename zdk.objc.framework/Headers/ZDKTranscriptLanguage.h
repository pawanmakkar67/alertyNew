//
// ZDKTranscriptLanguage.h
// ZDK
//

#ifndef ZDKTranscriptLanguage_h
#define ZDKTranscriptLanguage_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo transcript language
*
*  Describes a Banafo transcript language
*/
@protocol ZDKTranscriptLanguage <ZDKZHandle>

/** \brief Name of the language
*
*  \return The name of the language
*/
@property(nonatomic, readonly) NSString*  _Nullable name;

/** \brief ZDKETF language code tag
*
*  \return The ZDKETF language code tag
*/
@property(nonatomic, readonly) NSString*  _Nullable code;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
