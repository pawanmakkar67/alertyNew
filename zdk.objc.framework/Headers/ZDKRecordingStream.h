//
// ZDKRecordingStream.h
// ZDK
//

#ifndef ZDKRecordingStream_h
#define ZDKRecordingStream_h

#import <Foundation/Foundation.h>
#import "ZDKRecordingType.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Call
*
*  Describes the Recording stream, mainly used for Banafo recordings.
*/
@protocol ZDKRecordingStream <ZDKZHandle>

/** \brief The origin of the file content
*
*  The origin of the file content.
*
*  \return The origin of the file content
*
*  \see RecordingType
*/
@property(nonatomic, readonly) ZDKRecordingType  origin;

/** \brief Recording stream type
*
*  The type of the recording stream, e.g. "phone-call", "web-conference", "other", etc.
*
*  \return The stream type
*/
@property(nonatomic, readonly) NSString*  _Nullable type;

/** \brief The name of the file
*
*  The name of the file.
*
*  \return The name of the file
*/
@property(nonatomic, readonly) NSString*  _Nullable fileName;

/** \brief ZDKETF language tag of the recording
*
*  ZDKETF language tag of the recording.
*
*  \return ZDKETF language tag of the recording
*/
@property(nonatomic, readonly) NSString*  _Nullable languageCode;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
