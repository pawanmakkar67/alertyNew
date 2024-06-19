//
//  NSDataAdditions.h
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
#import "LibraryConfig.h"


@interface NSData (ExtendedMethods)

+ (NSData*) openFile:(NSString*)path;
+ (NSData*) openFile:(NSString*)path error:(NSError**)error;
- (BOOL) saveAs:(NSString*)path;
- (BOOL) saveAs:(NSString*)path error:(NSError**)error;

+ (NSData*) dataWithString:(NSString*)string;
- (NSString*) string;

- (NSData*) encryptAES128:(NSData*)key iv:(NSData*)iv;
- (NSData*) decryptAES128:(NSData*)key iv:(NSData*)iv;
- (NSData*) encryptAES192:(NSData*)key iv:(NSData*)iv;
- (NSData*) decryptAES192:(NSData*)key iv:(NSData*)iv;
- (NSData*) encryptAES256:(NSData*)key iv:(NSData*)iv;
- (NSData*) decryptAES256:(NSData*)key iv:(NSData*)iv;
- (NSData*) encryptDES:(NSData*)key iv:(NSData*)iv;
- (NSData*) decryptDES:(NSData*)key iv:(NSData*)iv;
- (NSData*) encrypt3DES:(NSData*)key iv:(NSData*)iv;
- (NSData*) decrypt3DES:(NSData*)key iv:(NSData*)iv;
- (NSData*) encryptCAST:(NSData*)key iv:(NSData*)iv;
- (NSData*) decryptCAST:(NSData*)key iv:(NSData*)iv;
- (NSData*) encryptRC4:(NSData*)key iv:(NSData*)iv;
- (NSData*) decryptRC4:(NSData*)key iv:(NSData*)iv;

- (NSData*) obfuscate:(uint8_t)key;

- (NSString*) base64Encode;
- (NSString*) urlBase64Encode;
- (NSString*) urlBase64EncodeForMicrosoft;
+ (NSData*) dataWithBase64String:(NSString*)base64;
+ (NSData*) dataWithUrlBase64String:(NSString*)urlBase64;

- (NSData*) MD2;
- (NSData*) MD4;
- (NSData*) MD5;
- (NSData*) SHA1;
- (NSData*) SHA224;
- (NSData*) SHA256;
- (NSData*) SHA384;
- (NSData*) SHA512;

- (NSString*) urlBase64Encoding;

- (NSData*) reverse;

- (uint8_t) at:(NSInteger)position;
- (uint8_t) safeAt:(NSInteger)position;
- (NSData*) safeSubdataWithRange:(NSRange)range;

- (NSString*) hex;
- (NSString*) hexWithPrefix:(NSString*)prefix;
- (NSString*) hexWithPrefix:(NSString*)prefix uppercase:(BOOL)uppercase;

#if HAVE_ECC
- (NSData*) eccEncode;
- (NSData*) eccDecode;
#endif

- (id) jsonRepresentation:(NSError**)error;
- (id) plistRepresentation:(NSError**)error;
- (id) xmlRepresentation:(NSError**)error;

@end
