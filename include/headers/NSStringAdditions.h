//
//  NSStringAdditions.h
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
#import <UIKit/UIKit.h>
#import <wchar.h>


@interface NSString (ExtendedMethods)

+ (NSString*) openFile:(NSString*)path;
+ (NSString*) openFile:(NSString*)path error:(NSError**)error;
- (BOOL) saveAs:(NSString*)path;
- (BOOL) saveAs:(NSString*)path error:(NSError**)error;

- (NSURL*) fileURL;
+ (NSURL*) fileURL:(NSString*)url;

+ (NSString*) uuid;

- (NSData*) MD2;
- (NSData*) MD4;
- (NSData*) MD5;
- (NSData*) SHA1;
- (NSData*) SHA224;
- (NSData*) SHA256;
- (NSData*) SHA384;
- (NSData*) SHA512;

- (NSData*) base64Decode;
- (NSData*) urlBase64Decode;
- (NSData*) urlBase64DecodeForMicrosoft;
+ (NSString*) base64StringWithData:(NSData*)data;
+ (NSString*) urlBase64StringWithData:(NSData*)data;

- (NSURL*) url;
+ (NSURL*) url:(NSString*)url;

- (NSMutableString*) mutableString;

// complete xxxValue methods
- (NSString*) stringValue;
- (NSNumber*) numberValue;
- (char) charValue;
- (unsigned char) unsignedCharValue;
- (short) shortValue;
- (unsigned short) unsignedShortValue;
- (unsigned int) unsignedIntValue;
- (long) longValue;
- (unsigned long) unsignedLongValue;
- (unsigned long long) unsignedLongLongValue;
- (NSUInteger) unsignedIntegerValue NS_AVAILABLE(10_5, 2_0);

- (NSString*) reverse;

- (CGSize) sizeUsingFont:(UIFont*)font;
- (CGSize) sizeUsingFont:(UIFont*)font constrainedToSize:(CGSize)size;
- (CGSize) sizeUsingFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (void) drawAtPoint:(CGPoint)point usingFont:(UIFont*)font;

- (void) drawInRect:(CGRect)rect usingFont:(UIFont*)font;
- (void) drawInRect:(CGRect)rect usingFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void) drawInRect:(CGRect)rect usingFont:(UIFont*)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

+ (id) stringWithContentsOfUTF8File:(NSString*)path;
+ (NSString*) stringWithData:(NSData*)data;
- (NSData*) data;

- (NSString*) changeSubstring:(NSString*)findString toString:(NSString*)toString;

- (NSString*) between:(NSString*)open pair:(NSString*)close;
- (NSString*) removeBetween:(NSString*)open pair:(NSString*)close;
- (NSString*) from:(NSString*)from to:(NSString*)to;
- (NSString*) removeFrom:(NSString*)from to:(NSString*)to;

- (NSInteger) locate:(NSString*)string;
- (NSInteger) locate:(NSString*)string offset:(NSInteger)offset;
- (NSInteger) locateReverse:(NSString*)string;
- (NSInteger) locateReverse:(NSString*)string offset:(NSInteger)offset;
- (NSString*) at:(NSUInteger)loc;
- (NSString*) left:(NSUInteger)length;
- (NSString*) mid:(NSUInteger)loc len:(NSUInteger)len;
- (NSString*) mid:(NSUInteger)start end:(NSUInteger)end;
- (NSString*) midRange:(NSRange)range;
- (NSString*) mid:(NSUInteger)loc;
- (NSString*) right:(NSUInteger)length;

- (NSString*) trimmedString;
- (NSString*) whitespaceTrimmedString;
- (NSString*) whitespaceFreeString;
- (NSString*) emptyLineFreeString;
- (NSString*) formattedNumberString;

- (NSString*) digitString;
- (NSString*) alphabetString;
- (NSString*) sqlSafeString;
- (BOOL) sqlIsNull;

- (NSString*) stringByInsertingString:(NSString*)string;
- (NSString*) stringByRemovingCharactersFromSet:(NSCharacterSet*)charSet;
- (NSString*) stringByReplacingCharactersFromSet:(NSCharacterSet*)charSet to:(NSString*)string;

- (NSString*) normalizedString;					// only [a-z] [A-Z] [0-9] and "_"

- (NSString*) stringBySelectingCharactersFromSet:(NSCharacterSet*)charSet;
- (NSString*) stringByAddingStartBracket:(NSString*)start endBracket:(NSString*)end;
- (NSString*) stringByRemovingStartBracket:(NSString*)start endBracket:(NSString*)end;
- (BOOL) containsOnlyCharactersFromSet:(NSCharacterSet*)charSet;

- (NSString*) stringWithArray:(NSArray*)array;
- (NSString*) stringWithArray:(NSArray*)array separator:(NSString*)separator;

- (BOOL) startsWith:(NSString*)string;
- (BOOL) endsWith:(NSString*)string;
- (BOOL) containsString:(NSString*)string;
- (BOOL) startsSensitive:(NSString*)string;
- (BOOL) endsSensitive:(NSString*)string;
- (BOOL) containsSensitive:(NSString*)string;

- (NSString*) encodeURLBase64;					// modified Base64 for URL encoded string (base64 without padding '=', and the '+' and '/' characters replaced by '-' and '_')
- (NSString*) decodeURLBase64;					// converts back
- (NSString*) stripTags;

- (NSData*) dehex;
- (NSData*) dehexWithPrefix:(NSString*)prefix;
+ (uint8_t) hexTetradeToValue:(uint8_t)ch;
+ (uint8_t) valueToHexTetrade:(uint8_t)ch;
+ (uint8_t) valueToHexTetrade:(uint8_t)ch uppercase:(BOOL)uppercase;

- (NSString*) urlEncodedString;
- (NSString*) urlDecodedString;

+ (NSString*) stringWithWChar:(wchar_t*)wstring;
- (wchar_t*) createWCharRepresentation;

- (NSString*) urlPrefix;
- (NSURL*) completeURLPath;
- (BOOL) isCompleteURLPath;
- (BOOL) isCompleteFileURLPath;
- (BOOL) isCompleteWebURLPath;
- (BOOL) isCompleteFTPURLPath;
- (NSString*) completeFileURLPath;
- (NSString*) completeFTPURLPath;
- (NSString*) completeHTTPURLPath;
- (NSString*) completeHTTPSURLPath;
- (NSString*) completeHTTPLocalURLPath;
- (NSString*) completeHTTPSLocalURLPath;
- (NSString*) truncateCompleteURLPath;
- (NSString*) truncateCompleteURLPathToRoot:(BOOL)root;

- (BOOL) isInternetPath;
- (BOOL) isLocalPath;
- (BOOL) isPNGFileName;
- (BOOL) isJPGFileName;
- (BOOL) isEmail;

- (NSUInteger) numberOfOccurrencesOfCharacter:(UniChar)character;
- (NSUInteger) numberOfOccurrencesOfString:(NSString*)string;

- (NSString*) groupedString:(NSUInteger)count backward:(BOOL)backward;
- (NSString*) groupedStringWithSeparator:(NSString*)separator count:(NSUInteger)count backward:(BOOL)backward;

- (CGFloat) fittingFontSizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

@end
