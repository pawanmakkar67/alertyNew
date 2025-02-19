//
// ZDKZRTPConfig.h
// ZDK
//

#ifndef ZDKZRTPConfig_h
#define ZDKZRTPConfig_h

#import <Foundation/Foundation.h>
#import "ZDKZRTPHashAlgorithm.h"
#import "ZDKZRTPCipherAlgorithm.h"
#import "ZDKZRTPAuthTag.h"
#import "ZDKZRTPKeyAgreement.h"
#import "ZDKZRTPSASEncoding.h"
#import "ZDKZRTPConfig.h"
#import "ZDKZHandle.h"
#import "ZDKZRTPConfig.h"
@protocol ZDKZRTPConfig;

NS_ASSUME_NONNULL_BEGIN

/** \brief ZRTP specific account configuration
*/
@protocol ZDKZRTPConfig <ZDKZHandle>

/** \brief Configures the use of user's ZRTP
*
*  \param[in] value
*  \li 0 - disabled
*  \li 1 - enabled
*/
@property(nonatomic) BOOL  enableZRTP;

/** \brief Configures the ZRTP Hash Algorithms for the User
*
*  Adds the specified ZRTP Hash Algorithms list.
*
*  Note that there is limited support for hash algorithms.
*
*  Note that the ZRTP RFC requires S256 to be always present. This means that when doing the actual ZRTP
*  negotiation the ZDK might offer S256 as the lowest prirority even if S256 was not added with this function.
*
*  The hash algorithm is used in various steps in the ZRTP negotiation. Bigger number of bits in the hash mean
*  higher securty and slower computation. It is recommended to add all supported algorithms, putting the most
*  secure ones first.
*
*  \param[in] value  The ZRTP Hash Algorithms list
*
*  \see ZRTPHashAlgorithm
*/
@property(nonatomic) NSArray<NSNumber*>*  hash;

/** \brief Configures the ZRTP Cipher Algorithms for the User
*
*  Adds the specified ZRTP Cipher Algorithm list.
*
*  Note that there might be limited support for cipher algorithms.
*
*  Note also that AES1 is required by the standard and even if not present in a user's cipher list, it will be
*  offered.
*
*  The cipher algorithm is the actual symmetric cipher used to encrypt the audio data once the ZRTP negotiation has
*  completed successfully. It is mainly used by the SRTP protocol for this purpose (ZRTP is NOT the one doing the
*  actual audio encryption. SRTP is still used for this).
*
*  The original SRTP RFC describes only AES1 from the list of ciphers in the ZRTP RFC. Most peers will only support
*  AES1. Please confirm which ciphers are supported by the library.
*
*  Higher numbers behind the cipher name means better encryption and slower processing.
*
*  \param[in] value  The ZRTP Cipher Algorithms list
*
*  \see ZRTPCipherAlgorithm
*/
@property(nonatomic) NSArray<NSNumber*>*  cipher;

/** \brief Configures the ZRTP Authentication Tag types for the User
*
*  Adds the ZRTP Authentication Tag types list.
*
*  Note that there might be limited support for authentication tag types.
*
*  Note that HS32 and HS80 are requred by the standard and even if not present in a user's auth tag type list they
*  will be negotiated. If both are not present, HS80 will have higher priority than HS32.
*
*  The authentication tag is used to authenticate each encrypted audio frame send over the SRTP channel once the
*  ZRTP negotiation has completed.
*
*  The original SRTP specification describes HS32 and HS80 which are 32-bit and 80-bit HMAC-SHA1 authentication
*  tags. The 80-bit tag provides better security.
*
*  The Skein-MAC authentication tags were not in the original SRTP RFC and might not be supported by the peer or
*  even this library. Please confirm this before using it.
*
*  \param[in] value  The ZRTP Authentication Tag types list
*
*  \see ZRTPAuthTag
*/
@property(nonatomic) NSArray<NSNumber*>*  auth;

/** \brief Configures the ZRTP Key Agreement algorithms for the User
*
*  Adds the ZRTP Key Agreement algorithms list.
*
*  Note that there might be limited support for key agreement algorithms.
*
*  Note that DH3K is required by the standard and even if not present in this list it will be negotiated.
*
*  The key agreement algorithm is the main feature of the ZRTP process. There are three types described in the RFC.
*
*  1. Finite Field Diffie-Hellman. This is the standard public key exchange used in many security protocols. It
*     involves complex calculations with huge integer numbers. The ZRTP protocol uses two public prime groups for
*     the key agreement: the 3072-bit group and the 2048-bit group. The names 'DH3k' and 'DH2k' come from the prime
*     group size. The 3027-bit group provides better security (obviosly).
*
*  2. Elliptic Curve Diffie-Hellman. This is a newer public key exchange also employed in many security protocols
*     (most of the newer versions of the same protocols that use FFDH). ECDH uses smaller numbers, but they're
*     still huge and the calculations are still expensive. The two supported curve groups by the ZRTP standard are
*     the 384-bit and 256-bit groups. The names 'EC25' and 'EC38' come from the group size. EC38 provides better
*     security.
*
*  3. Preshared. This key exchange does not rely on any public key exchange algorithm but instead relies on both
*     parties sharing a common secret which is configured on each peer before the ZRTP negotiation is made. This
*     negotiation type is used when a peer lacks the CPU or memory necessary for a full Diffie-Hellman exchange.
*
*  EC38 and DH3k are recommended for their better security. EC38 is preferred because it is less CPU-intensive than
*     DH3k and provides similar security.
*
*  Please confirm that PRSH (Preshared) is available in the ZDK before using it.
*
*  \param[in] value  The ZRTP Key Agreement algorithms list
*
*  \see ZRTPKeyAgreement
*/
@property(nonatomic) NSArray<NSNumber*>*  keyAgreement;

/** \brief Configures the ZRTP SAS encodings for the User
*
*  Adds the ZRTP SAS encodings list.
*
*  The SAS stands for "Short Authentication String". It is used to confirm the public key exchange and to do
*  "biometric" voice authentication.
*
*  The public key exchange employed by ZRTP is vulnerable to man-in-the-middle attacks. By doing vocal comparison
*  of the resulting key exchange the two peers both establish each other's voice authenticity (assuming they know
*  each other and that the VoIP codec is not awful) and make sure the result is the same.
*
*  If an attacker tries to hijack the ZRTP key exchnage the two parties will end up with different results. By
*  requiring voice authentication the attacker now has to fake the voices of both peers (and do it not only for the
*  key exchange but for the entire call too).
*
*  This voice authentication does not really work for peers that can't recognize each other's voices. In case a
*  secure call is desired with a unknown party, a preshared secret must be employed.
*
*  The SAS is used to make comparing the result easier. Instead of reading a long binary sequence ZRTP employs a
*  simple conversion of the binary code into a short easy to read text. Only the most significant bits from the
*  result are used.
*
*  B32 (Base-32) converts the 20 most significant bits into 4 alphanumeric characters which are chosen from the
*  latin alphabet combined with some digits so there are no ambiguous characters in it (like 1, l and I for
*  example). To compare the SAS the two participants must know how to spell the latin letters and the digits from 0
*  to 9 (with some omissions).
*
*  B256 (Base-256) converts the 32 most significant bits into 4 english words from a carefully selected dictionary
*  produced by a complicated genetic algorithm. This SAS type requires the two user to be able to read and
*  pronounce correctly each of the 512 words in the dictionary. They don't need to know the words by heart by they
*  do need to be able to pronounce them unambiguously. This might not be suitable for non-english speakers.
*
*  Note that B32 is always required to be present in the negotiation and the library will add it to the negotiation
*  even if it is not present in the list.
*
*  \param[in] value  The ZRTP SAS encodings list
*
*  \see ZRTPSASEncoding
*/
@property(nonatomic) NSArray<NSNumber*>*  sasEncoding;

/** \brief Configures the ZRTP cache expiry for the User
*
*  After a ZRTP negotiation between two peers is complete they update their caches based on their configuration and
*  the negotiation expiry times.
*
*  The cache is only useful if both peers in a negotiation have one. In case one of the peers does not have a cache
*  there is absolutely no point in caching for the other peer.
*
*  In case both peers have working caches they need to negotiate the lifetime of the cached data. For this to
*  happen both send to the other end their preferences for the cache expiry. After both receive each other's cache
*  expiry preferences, they choose the smaller of the two.
*
*  The expiry is set in seconds from the time of the negotiation. There are two special values: 0 disables caching
*  for this exchange and -1 sets the expiry to infinity (never expire). -1 is the default (also recommended by the
*  protocol).
*
*  When comparing expiration, -1 is treated as the maximum value. This means that if one peer is configured to
*  never expire, and the other is configured to expire in 3 days, both will set the expiry to 3 days.
*
*  If either one of the peers set the expiry to 0 both peers will delete their cache entries for each other.
*
*  \param[in] value  The expiry in seconds or 0 for no cache or -1 for infinity (default)
*/
@property(nonatomic) int  cacheExpiry;

/** \brief Compares the current configuration with the given one
*
*  \param[in] comp  SIP configuration to be compared
*
*  \return
*  \li 0 - not equal
*  \li 1 - equal
*/
-(BOOL)isEqual:(id<ZDKZRTPConfig>)comp ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
