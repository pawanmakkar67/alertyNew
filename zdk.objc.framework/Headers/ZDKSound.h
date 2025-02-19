//
// ZDKSound.h
// ZDK
//

#ifndef ZDKSound_h
#define ZDKSound_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

/** \brief ZDK Sound description
*/
@protocol ZDKSound <ZDKZHandle>

/** \brief Gets the underlying sound handler ID
*
*  Internally assigned on successful addSound() invocation and invalidated on removeSound().
*
*  \return The underlying sound handler ZDKD
*/
@property(nonatomic, readonly) long int  soundHandle;

/** \brief Gets the path to the file this Sound was created from
*
*  \return The path to the sound file in case the sound is created from such, NULL otherwise.
*/
@property(nonatomic, readonly) NSString*  _Nullable path;

@property(nonatomic, readonly) int  frequency;

@property(nonatomic, readonly) int  lengthSamples;

@property(nonatomic, readonly) int  approximateLengthMs;

@property(nonatomic, readonly) int  channelCount;

@property(nonatomic, readonly) BOOL  repeat;

@property(nonatomic, readonly) int  pause;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
