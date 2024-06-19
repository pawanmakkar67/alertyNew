//
//  NSNumberAdditions.h
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


@interface NSNumber (ExtendedMethods)

- (NSDate*) date;
- (NSDate*) millisecondsDate;

// complete xxxValue methods
- (NSNumber*) numberValue;

+ (NSNumber*) c:(char)value;
+ (NSNumber*) uc:(unsigned char)value;
+ (NSNumber*) s:(short)value;
+ (NSNumber*) us:(unsigned short)value;
+ (NSNumber*) i:(int)value;
+ (NSNumber*) ui:(unsigned int)value;
+ (NSNumber*) l:(long)value;
+ (NSNumber*) ul:(unsigned long)value;
+ (NSNumber*) ll:(long long)value;
+ (NSNumber*) ull:(unsigned long long)value;
+ (NSNumber*) f:(float)value;
+ (NSNumber*) d:(double)value;
+ (NSNumber*) b:(BOOL)value;
#if MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED
+ (NSNumber*) int:(NSInteger)value;
+ (NSNumber*) uint:(NSUInteger)value;
#endif

- (NSNumber*) addNumber:(NSNumber*)number;
- (NSNumber*) addChar:(char)value;
- (NSNumber*) addUnsignedChar:(unsigned char)value;
- (NSNumber*) addShort:(short)value;
- (NSNumber*) addUnsignedShort:(unsigned short)value;
- (NSNumber*) addInt:(int)value;
- (NSNumber*) addUnsignedInt:(unsigned int)value;
- (NSNumber*) addLong:(long)value;
- (NSNumber*) addUnsignedLong:(unsigned long)value;
- (NSNumber*) addLongLong:(long long)value;
- (NSNumber*) addUnsignedLongLong:(unsigned long long)value;
- (NSNumber*) addFloat:(float)value;
- (NSNumber*) addDouble:(double)value;
- (NSNumber*) addBool:(BOOL)value;
#if MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED
- (NSNumber*) addInteger:(NSInteger)value;
- (NSNumber*) addUnsignedInteger:(NSUInteger)value;
#endif

- (NSNumber*) subtractNumber:(NSNumber*)number;
- (NSNumber*) subtractChar:(char)value;
- (NSNumber*) subtractUnsignedChar:(unsigned char)value;
- (NSNumber*) subtractShort:(short)value;
- (NSNumber*) subtractUnsignedShort:(unsigned short)value;
- (NSNumber*) subtractInt:(int)value;
- (NSNumber*) subtractUnsignedInt:(unsigned int)value;
- (NSNumber*) subtractLong:(long)value;
- (NSNumber*) subtractUnsignedLong:(unsigned long)value;
- (NSNumber*) subtractLongLong:(long long)value;
- (NSNumber*) subtractUnsignedLongLong:(unsigned long long)value;
- (NSNumber*) subtractFloat:(float)value;
- (NSNumber*) subtractDouble:(double)value;
- (NSNumber*) subtractBool:(BOOL)value;
#if MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED
- (NSNumber*) subtractInteger:(NSInteger)value;
- (NSNumber*) subtractUnsignedInteger:(NSUInteger)value;
#endif

- (NSNumber*) multiplyNumber:(NSNumber*)number;
- (NSNumber*) multiplyChar:(char)value;
- (NSNumber*) multiplyUnsignedChar:(unsigned char)value;
- (NSNumber*) multiplyShort:(short)value;
- (NSNumber*) multiplyUnsignedShort:(unsigned short)value;
- (NSNumber*) multiplyInt:(int)value;
- (NSNumber*) multiplyUnsignedInt:(unsigned int)value;
- (NSNumber*) multiplyLong:(long)value;
- (NSNumber*) multiplyUnsignedLong:(unsigned long)value;
- (NSNumber*) multiplyLongLong:(long long)value;
- (NSNumber*) multiplyUnsignedLongLong:(unsigned long long)value;
- (NSNumber*) multiplyFloat:(float)value;
- (NSNumber*) multiplyDouble:(double)value;
- (NSNumber*) multiplyBool:(BOOL)value;
#if MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED
- (NSNumber*) multiplyInteger:(NSInteger)value;
- (NSNumber*) multiplyUnsignedInteger:(NSUInteger)value;
#endif

- (NSNumber*) divideNumber:(NSNumber*)number;
- (NSNumber*) divideChar:(char)value;
- (NSNumber*) divideUnsignedChar:(unsigned char)value;
- (NSNumber*) divideShort:(short)value;
- (NSNumber*) divideUnsignedShort:(unsigned short)value;
- (NSNumber*) divideInt:(int)value;
- (NSNumber*) divideUnsignedInt:(unsigned int)value;
- (NSNumber*) divideLong:(long)value;
- (NSNumber*) divideUnsignedLong:(unsigned long)value;
- (NSNumber*) divideLongLong:(long long)value;
- (NSNumber*) divideUnsignedLongLong:(unsigned long long)value;
- (NSNumber*) divideFloat:(float)value;
- (NSNumber*) divideDouble:(double)value;
- (NSNumber*) divideBool:(BOOL)value;
#if MAC_OS_X_VERSION_10_5 <= MAC_OS_X_VERSION_MAX_ALLOWED
- (NSNumber*) divideInteger:(NSInteger)value;
- (NSNumber*) divideUnsignedInteger:(NSUInteger)value;
#endif

@end
