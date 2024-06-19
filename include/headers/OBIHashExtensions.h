//
//  OBIHashExtensions.h
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

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonKeyDerivation.h>


// hash algorithms

typedef enum {
	kHashAlgorithmMD2 = 0,
	kHashAlgorithmMD4,
	kHashAlgorithmMD5,
	kHashAlgorithmSHA1,
	kHashAlgorithmSHA224,
	kHashAlgorithmSHA256,
	kHashAlgorithmSHA384,
	kHashAlgorithmSHA512
} HashAlgorithm;


@interface OBIHash : NSObject
{
}

+ (NSUInteger) hashLength:(HashAlgorithm)algorithm;
+ (HashAlgorithm) guessHashAlgorithmFromHashLength:(NSUInteger)length;
+ (CCHmacAlgorithm) ccHmacAlgorithmForHashAlgorithm:(HashAlgorithm)algorithm;
+ (HashAlgorithm) hashAlgorithmForCCHmacAlgorithm:(CCHmacAlgorithm)algorithm;

+ (NSData*) MD2:(NSData*)data;
+ (NSData*) MD4:(NSData*)data;
+ (NSData*) MD5:(NSData*)data;
+ (NSData*) SHA1:(NSData*)data;
+ (NSData*) SHA224:(NSData*)data;
+ (NSData*) SHA256:(NSData*)data;
+ (NSData*) SHA384:(NSData*)data;
+ (NSData*) SHA512:(NSData*)data;
+ (NSData*) hashData:(NSData*)data withHashAlgorithm:(HashAlgorithm)algorithm;

+ (NSData*) HMAC:(NSData*)data key:(NSData*)key algorithm:(HashAlgorithm)algorithm;		// kHashAlgorithmMD5, kHashAlgorithmSHA1, kHashAlgorithmSHA224, kHashAlgorithmSHA256, kHashAlgorithmSHA384, kHashAlgorithmSHA512

@end
