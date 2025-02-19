//
// ZDKBanafoRecording.h
// ZDK
//

#ifndef ZDKBanafoRecording_h
#define ZDKBanafoRecording_h

#import <Foundation/Foundation.h>
#import "ZDKRecordingStream.h"
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief Banafo Recording
*
*  Describes the Banafo Recording.
*/
@protocol ZDKBanafoRecording <ZDKZHandle>

/** \brief The Banafo Service's recording ID.
*
*  The Banafo Service's recording ID.
*
*  \return The Banafo Service's recording ZDKD
*/
@property(nonatomic, readonly) NSString*  _Nullable banafoId;

/** \brief Started time of the recording
*
*  Time and date when the recording was initiated in ZDKSO 8601 Format.
*  Example: '2019-11-18T15:20:31.928Z'
*
*  \return The start time of the recording
*/
@property(nonatomic, readonly) NSString*  startedAt;

/** \brief Ending time of the recording
*
*  Time and date when recording was finished in ZDKSO 8601 Format.
*  Example: '2019-11-18T15:22:12.422Z'
*
*  \return The start time of the recording
*/
@property(nonatomic, readonly) NSString*  _Nullable finishedAt;

/** \brief The Banafo Service's call ID this recording was taken for
*
*  The Banafo Service's call ID this recording was taken for.
*
*  \return The Banafo Service's call ID this recording was taken for
*/
@property(nonatomic, readonly) NSString*  banafoCallId;

/** \brief List of streams this recording consists of
*
*  List of streams this recording consists of.
*
*  \return The list of streams this recording consists of
*
*  \see ZDKRecordingStream
*/
@property(nonatomic, readonly) NSArray<id<ZDKRecordingStream>>*  streams;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
