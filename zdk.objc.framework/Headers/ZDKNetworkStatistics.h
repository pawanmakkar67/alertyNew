//
// ZDKNetworkStatistics.h
// ZDK
//

#ifndef ZDKNetworkStatistics_h
#define ZDKNetworkStatistics_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKNetworkStatistics <ZDKZHandle>

/** \brief Gets call channel
*
*  \return The call channel
*
*/
@property(nonatomic, readonly) int  callChannel;

/** \brief Gets total input packets
*
*  \return The total input packets
*
*/
@property(nonatomic, readonly) int  totalInputPackets;

/** \brief Gets total input bytes
*
*  \return The total input bytes
*
*/
@property(nonatomic, readonly) int  totalInputBytes;

/** \brief Gets total input bytes payload
*
*  \return The total input bytes payload
*
*/
@property(nonatomic, readonly) int  totalInputBytesPayload;

/** \brief Gets current input bitrate
*
*  \return The current input bitrate
*
*/
@property(nonatomic, readonly) int  currentInputBitrate;

/** \brief Gets the average input bitrate
*
*  \return The average input bitrate
*
*/
@property(nonatomic, readonly) int  averageInputBitrate;

/** \brief Gets the total output packets
*
*  \return The total output packets
*
*/
@property(nonatomic, readonly) int  totalOutputPackets;

/** \brief Gets the total output bytes
*
*  \return The total output bytes
*
*/
@property(nonatomic, readonly) int  totalOutputBytes;

/** \brief Gets the total output bytes payload
*
*  \return The total output bytes payload
*
*/
@property(nonatomic, readonly) int  totalOutputBytesPayload;

/** \brief Gets the total output bytes payload
*
*  \return The total output bytes payload
*
*/
@property(nonatomic, readonly) int  currentOutputBitrate;

/** \brief Gets the average output bitrate
*
*  \return The average output bitrate
*
*/
@property(nonatomic, readonly) int  averageOutputBitrate;

/** \brief Gets the current input loss permil
*
*  \return The current input loss permil
*
*/
@property(nonatomic, readonly) int  currentInputLossPermil;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
