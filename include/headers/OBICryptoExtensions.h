//
//  OBICryptoExtensions.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSExtensionsConfig.h"
#if HAVE_CRYPTO
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#if HAVE_CRYPTO_SECURITY
#import "OBIHashExtensions.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#endif


// encryption algorithms

typedef enum {
	kCryptoAlgorithmAES = 0,
	kCryptoAlgorithmAES128,
	kCryptoAlgorithmAES192,
	kCryptoAlgorithmAES256,
	kCryptoAlgorithmDES,
	kCryptoAlgorithm3DES,
	kCryptoAlgorithmCAST,
	kCryptoAlgorithmRC4,
	kCryptoAlgorithmRC2,
	kCryptoAlgorithmBlowfish
} CryptoAlgorithm;


// note:
//	DES and TripleDES have fixed key sizes.
//	AES has three discrete key sizes.
//	CAST and RC4 have variable key sizes.
typedef struct {
	NSUInteger min;
	NSUInteger max;
} CCKeyLength;


static inline CCKeyLength CCMakeKeyLength(NSUInteger min, NSUInteger max)
{
	CCKeyLength kl;
	kl.min = min;
	kl.max = max;
	return kl;
}


@interface OBICrypto : NSObject
{
}

+ (CCKeyLength) keyLength:(CryptoAlgorithm)algorithm;
+ (NSInteger) extraLength:(CryptoAlgorithm)algorithm;
+ (CCAlgorithm) ccAlgorithmForCryptoAlgorithm:(CryptoAlgorithm)algorithm;
+ (NSData*) encryptOrDecrypt:(NSData*)data key:(NSData*)key iv:(NSData*)iv operation:(CCOperation)operation algorithm:(CryptoAlgorithm)algorithm;

+ (NSData*) encryptAES128:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decryptAES128:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) encryptAES192:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decryptAES192:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) encryptAES256:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decryptAES256:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) encryptDES:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decryptDES:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) encrypt3DES:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decrypt3DES:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) encryptCAST:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decryptCAST:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) encryptRC4:(NSData*)data key:(NSData*)key iv:(NSData*)iv;
+ (NSData*) decryptRC4:(NSData*)data key:(NSData*)key iv:(NSData*)iv;

+ (NSData*) obfuscate:(NSData*)data key:(uint8_t)key;

#if HAVE_CRYPTO_SECURITY
+ (BOOL) generateKeyPair:(NSUInteger)keySize publicTag:(NSData*)publicTag privateTag:(NSData*)privateTag publicKey:(SecKeyRef*)publicKey privateKey:(SecKeyRef*)privateKey;

+ (NSData*) publicKeyToData:(SecKeyRef)secKey;
+ (NSData*) privateKeyToData:(SecKeyRef)secKey;
+ (NSData*) secKeyToData:(SecKeyRef)secKey isPrivateKey:(BOOL)privateKey;
+ (SecKeyRef) publicKeyFromData:(NSData*)secKeyData;
+ (SecKeyRef) privateKeyFromData:(NSData*)secKeyData;
+ (SecKeyRef) secKeyFromData:(NSData*)secKeyData isPrivateKey:(BOOL)privateKey;
+ (NSData*) secKeyModulus:(NSData*)secKeyData;
+ (NSData*) secKeyExponent:(NSData*)secKeyData;
+ (NSData*) secKeyWithExponent:(NSData*)exponent andModulus:(NSData*)modulus;

+ (NSData*) encryptData:(NSData*)data withPublicKey:(SecKeyRef)publicKey padding:(SecPadding)padding;
+ (NSData*) decryptData:(NSData*)data withPrivateKey:(SecKeyRef)privateKey padding:(SecPadding)padding;

+ (SecPadding) secAndHashPaddingForHashAlgorithm:(HashAlgorithm)algorithm;
+ (NSData*) signatureForData:(NSData*)data withPrivateKey:(SecKeyRef)privateKey withHashAlgorithm:(HashAlgorithm)algorithm;							// kHashAlgorithmMD4 not supported
+ (BOOL) verifyData:(NSData*)data withSignature:(NSData*)signature andPublicKey:(SecKeyRef)publicKey withHashAlgorithm:(HashAlgorithm)algorithm;	// kHashAlgorithmMD4 not supported

+ (CCAlgorithm) derivedKeyLengthForPseudoRandomAlgorithm:(CCPseudoRandomAlgorithm)algorithm;
+ (NSUInteger) roundsForData:(NSData*)data algorithm:(CCPseudoRandomAlgorithm)algorithm salt:(NSData*)salt executionTime:(NSTimeInterval)time;
+ (NSData*) deriveKey:(NSData*)data algorithm:(CCPseudoRandomAlgorithm)algorithm salt:(NSData*)salt rounds:(NSUInteger)rounds;
#endif

@end
#endif
