//
//  NSHelpers.h
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
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NSNullAdditions.h"
#import "NSStringAdditions.h"
#import <objc/runtime.h>								// objc_msgSend
#import <objc/message.h>								// objc_msgSend


#pragma mark -
#pragma mark Logging helpers

#if DEBUG_LOG
	#if DEBUG_LONG_LOG
		#define cmdlog									NSLog(@"[%@] (%@)", self.class, NSStringFromSelector(_cmd));
		#define cmdlogerr(OBJ, ERR)						NSLog(@"[%@] (%@): %@", self.class, NSStringFromSelector(_cmd), [NSString stringWithFormat:@"%@ (%@)", OBJ, ERR]);
		#define cmdlogint(INT)							NSLog(@"[%@] (%@): %ld", self.class, NSStringFromSelector(_cmd), (long)INT);
		#define cmdlogfloat(FLOAT)						NSLog(@"[%@] (%@): %lf", self.class, NSStringFromSelector(_cmd), (double)FLOAT);
		#define cmdlogtext(TEXT,...)					NSLog(@"[%@] (%@): %@", self.class, NSStringFromSelector(_cmd), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogobj(OBJ)							NSLog(@"[%@] (%@): %@", self.class, NSStringFromSelector(_cmd), [NSString stringWithFormat:@"%@", OBJ]);
		#define cmdlogretain(OBJ)						NSLog(@"[%@] (%@): %@", self.class, NSStringFromSelector(_cmd), [NSString stringWithFormat:@"(retain: %u) %@", [OBJ retainCount], OBJ]);
		#define cmdlogframe(FRAME)						NSLog(@"[%@] (%@): frame: %@", self.class, NSStringFromSelector(_cmd), NSStringFromCGRect(FRAME));
		#define cmdlogpoint(POINT)						NSLog(@"[%@] (%@): point: %@", self.class, NSStringFromSelector(_cmd), NSStringFromCGPoint(POINT));
		#define cmdlogsize(SIZE)						NSLog(@"[%@] (%@): size: %@", self.class, NSStringFromSelector(_cmd), NSStringFromCGSize(SIZE));
		#define cmdlogframetext(FRAME,TEXT,...)			NSLog(@"[%@] (%@): frame: %@ %@", self.class, NSStringFromSelector(_cmd), NSStringFromCGRect(FRAME), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogpointtext(POINT,TEXT,...)			NSLog(@"[%@] (%@): size: %@ %@", self.class, NSStringFromSelector(_cmd), NSStringFromCGPoint(POINT), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogsizetext(SIZE,TEXT,...)			NSLog(@"[%@] (%@): size: %@ %@", self.class, NSStringFromSelector(_cmd), NSStringFromCGSize(SIZE), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogaffinetr(AFFINE)					NSLog(@"[%@] (%s): affine:\na:%f   b:%f   tx:%f\nc:%f   d:%f   ty:%f", AFFINE.a, AFFINE.b, AFFINE.tx, AFFINE.c, AFFINE.d, AFFINE.ty);
		#define cmdlog3dtr(TRANSFORM3D)					NSLog(@"[%@] (%s): transform3D:\nm11:%f   m12:%f   m13:%f   m14:%f\nm21:%f   m22:%f   m23:%f   m24:%f\nm31:%f   m32:%f   m33:%f   m44:%f\nm41:%f   m42:%f   m43:%f   m44:%f", self.class, _cmd, TRANSFORM3D.m11, TRANSFORM3D.m12, TRANSFORM3D.m13, TRANSFORM3D.m14, TRANSFORM3D.m21, TRANSFORM3D.m22, TRANSFORM3D.m23, TRANSFORM3D.m24, TRANSFORM3D.m31, TRANSFORM3D.m32, TRANSFORM3D.m33, TRANSFORM3D.m34, TRANSFORM3D.m41, TRANSFORM3D.m42, TRANSFORM3D.m43, TRANSFORM3D.m44);
		// use these in blocks to not retain self
		#define weaklog									NSLog(@"[%@] (%@)", weakSelf.class, NSStringFromSelector(_cmd));
		#define weaklogerr(OBJ, ERR)					NSLog(@"[%@] (%@): %@", weakSelf.class, NSStringFromSelector(_cmd), [NSString stringWithFormat:@"%@ (%@)", OBJ, ERR]);
		#define weaklogint(INT)							NSLog(@"[%@] (%@): %ld", weakSelf.class, NSStringFromSelector(_cmd), (long)INT);
		#define weaklogfloat(FLOAT)						NSLog(@"[%@] (%@): %lf", weakSelf.class, NSStringFromSelector(_cmd), (double)FLOAT);
		#define weaklogtext(TEXT,...)					NSLog(@"[%@] (%@): %@", weakSelf.class, NSStringFromSelector(_cmd), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogobj(OBJ)							NSLog(@"[%@] (%@): %@", weakSelf.class, NSStringFromSelector(_cmd), [NSString stringWithFormat:@"%@", OBJ]);
		#define weaklogretain(OBJ)						NSLog(@"[%@] (%@): %@", weakSelf.class, NSStringFromSelector(_cmd), [NSString stringWithFormat:@"(retain: %u) %@", [OBJ retainCount], OBJ]);
		#define weaklogframe(FRAME)						NSLog(@"[%@] (%@): frame: %@", weakSelf.class, NSStringFromSelector(_cmd), NSStringFromCGRect(FRAME));
		#define weaklogpoint(POINT)						NSLog(@"[%@] (%@): point: %@", weakSelf.class, NSStringFromSelector(_cmd), NSStringFromCGPoint(POINT));
		#define weaklogsize(SIZE)						NSLog(@"[%@] (%@): size: %@", weakSelf.class, NSStringFromSelector(_cmd), NSStringFromCGSize(SIZE));
		#define weaklogframetext(FRAME,TEXT,...)		NSLog(@"[%@] (%@): frame: %@ %@", weakSelf.class, NSStringFromSelector(_cmd), NSStringFromCGRect(FRAME), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogpointtext(POINT,TEXT,...)		NSLog(@"[%@] (%@): size: %@ %@", weakSelf.class, NSStringFromSelector(_cmd), NSStringFromCGPoint(POINT), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogsizetext(SIZE,TEXT,...)			NSLog(@"[%@] (%@): size: %@ %@", weakSelf.class, NSStringFromSelector(_cmd), NSStringFromCGSize(SIZE), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogaffinetr(AFFINE)					NSLog(@"[%@] (%s): affine:\na:%f   b:%f   tx:%f\nc:%f   d:%f   ty:%f", AFFINE.a, AFFINE.b, AFFINE.tx, AFFINE.c, AFFINE.d, AFFINE.ty);
		#define weaklog3dtr(TRANSFORM3D)				NSLog(@"[%@] (%s): transform3D:\nm11:%f   m12:%f   m13:%f   m14:%f\nm21:%f   m22:%f   m23:%f   m24:%f\nm31:%f   m32:%f   m33:%f   m44:%f\nm41:%f   m42:%f   m43:%f   m44:%f", weakSelf.class, _cmd, TRANSFORM3D.m11, TRANSFORM3D.m12, TRANSFORM3D.m13, TRANSFORM3D.m14, TRANSFORM3D.m21, TRANSFORM3D.m22, TRANSFORM3D.m23, TRANSFORM3D.m24, TRANSFORM3D.m31, TRANSFORM3D.m32, TRANSFORM3D.m33, TRANSFORM3D.m34, TRANSFORM3D.m41, TRANSFORM3D.m42, TRANSFORM3D.m43, TRANSFORM3D.m44);
	#else
		#define cmdlog									NSLog(@"[%@] (%@)", self.class, NSStringFromSelector(_cmd));
		#define cmdlogerr(OBJ, ERR)						NSLog(@"%@", [NSString stringWithFormat:@"%@ (%@)", OBJ, ERR]);
		#define cmdlogint(INT)							NSLog(@"%ld", (long)INT);
		#define cmdlogfloat(FLOAT)						NSLog(@"%lf", (double)FLOAT);
		#define cmdlogtext(TEXT,...)					NSLog(@"%@", (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogobj(OBJ)							NSLog(@"%@", [NSString stringWithFormat:@"%@", OBJ]);
		#define cmdlogretain(OBJ)						NSLog(@"%@", [NSString stringWithFormat:@"(retain: %u) %@", [OBJ retainCount], OBJ]);
		#define cmdlogframe(FRAME)						NSLog(@"frame: %@", NSStringFromCGRect(FRAME));
		#define cmdlogpoint(POINT)						NSLog(@"point: %@", NSStringFromCGPoint(POINT));
		#define cmdlogsize(SIZE)						NSLog(@"size: %@", NSStringFromCGSize(SIZE));
		#define cmdlogframetext(FRAME,TEXT,...)			NSLog(@"frame: %@ %@", NSStringFromCGRect(FRAME), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogpointtext(POINT,TEXT,...)			NSLog(@"size: %@ %@", NSStringFromCGPoint(POINT), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogsizetext(SIZE,TEXT,...)			NSLog(@"size: %@ %@", NSStringFromCGSize(SIZE), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define cmdlogaffinetr(AFFINE)					NSLog(@"affine:\n\a:%f   b:%f   tx:%f\n\c:%f   d:%f   ty:%f", AFFINE.a, AFFINE.b, AFFINE.tx, AFFINE.c, AFFINE.d, AFFINE.ty);
		#define cmdlog3dtr(TRANSFORM3D)					NSLog(@"transform3D:\nm11:%f   m12:%f   m13:%f   m14:%f\nm21:%f   m22:%f   m23:%f   m24:%f\nm31:%f   m32:%f   m33:%f   m44:%f\nm41:%f   m42:%f   m43:%f   m44:%f", TRANSFORM3D.m11, TRANSFORM3D.m12, TRANSFORM3D.m13, TRANSFORM3D.m14, TRANSFORM3D.m21, TRANSFORM3D.m22, TRANSFORM3D.m23, TRANSFORM3D.m24, TRANSFORM3D.m31, TRANSFORM3D.m32, TRANSFORM3D.m33, TRANSFORM3D.m34, TRANSFORM3D.m41, TRANSFORM3D.m42, TRANSFORM3D.m43, TRANSFORM3D.m44);
		// use these in blocks to not retain self
		#define weaklog									NSLog(@"[%@] (%@)", weakSelf.class, NSStringFromSelector(_cmd));
		#define weaklogerr(OBJ, ERR)					NSLog(@"%@", [NSString stringWithFormat:@"%@ (%@)", OBJ, ERR]);
		#define weaklogint(INT)							NSLog(@"%ld", (long)INT);
		#define weaklogfloat(FLOAT)						NSLog(@"%lf", (double)FLOAT);
		#define weaklogtext(TEXT,...)					NSLog(@"%@", (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogobj(OBJ)							NSLog(@"%@", [NSString stringWithFormat:@"%@", OBJ]);
		#define weaklogretain(OBJ)						NSLog(@"%@", [NSString stringWithFormat:@"(retain: %u) %@", [OBJ retainCount], OBJ]);
		#define weaklogframe(FRAME)						NSLog(@"frame: %@", NSStringFromCGRect(FRAME));
		#define weaklogpoint(POINT)						NSLog(@"point: %@", NSStringFromCGPoint(POINT));
		#define weaklogsize(SIZE)						NSLog(@"size: %@", NSStringFromCGSize(SIZE));
		#define weaklogframetext(FRAME,TEXT,...)		NSLog(@"frame: %@ %@", NSStringFromCGRect(FRAME), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogpointtext(POINT,TEXT,...)		NSLog(@"size: %@ %@", NSStringFromCGPoint(POINT), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogsizetext(SIZE,TEXT,...)			NSLog(@"size: %@ %@", NSStringFromCGSize(SIZE), (TEXT ? [NSString stringWithFormat:TEXT, ##__VA_ARGS__, nil] : nil));
		#define weaklogaffinetr(AFFINE)					NSLog(@"affine:\n\a:%f   b:%f   tx:%f\n\c:%f   d:%f   ty:%f", AFFINE.a, AFFINE.b, AFFINE.tx, AFFINE.c, AFFINE.d, AFFINE.ty);
		#define weaklog3dtr(TRANSFORM3D)				NSLog(@"transform3D:\nm11:%f   m12:%f   m13:%f   m14:%f\nm21:%f   m22:%f   m23:%f   m24:%f\nm31:%f   m32:%f   m33:%f   m44:%f\nm41:%f   m42:%f   m43:%f   m44:%f", TRANSFORM3D.m11, TRANSFORM3D.m12, TRANSFORM3D.m13, TRANSFORM3D.m14, TRANSFORM3D.m21, TRANSFORM3D.m22, TRANSFORM3D.m23, TRANSFORM3D.m24, TRANSFORM3D.m31, TRANSFORM3D.m32, TRANSFORM3D.m33, TRANSFORM3D.m34, TRANSFORM3D.m41, TRANSFORM3D.m42, TRANSFORM3D.m43, TRANSFORM3D.m44);
	#endif
#else
	#define cmdlog
	#define cmdlogerr(OBJ, ERR)
	#define cmdlogint(INT)
	#define cmdlogfloat(FLOAT)
	#define cmdlogtext(TEXT,...)
	#define cmdlogobj(OBJ)
	#define cmdlogretain(OBJ)
	#define cmdlogframe(FRAME)
	#define cmdlogpoint(POINT)
	#define cmdlogsize(SIZE)
	#define cmdlogframetext(FRAME,TEXT,...)
	#define cmdlogpointtext(POINT,TEXT,...)
	#define cmdlogsizetext(SIZE,TEXT,...)
	#define cmdlogaffinetr(AFFINE)
	#define cmdlog3dtr(TRANSFORM3D)
	// use these in blocks to not retain self
	#define weaklog
	#define weaklogerr(OBJ, ERR)
	#define weaklogint(INT)
	#define weaklogfloat(FLOAT)
	#define weaklogtext(TEXT,...)
	#define weaklogobj(OBJ)
	#define weaklogretain(OBJ)
	#define weaklogframe(FRAME)
	#define weaklogpoint(POINT)
	#define weaklogsize(SIZE)
	#define weaklogframetext(FRAME,TEXT,...)
	#define weaklogpointtext(POINT,TEXT,...)
	#define weaklogsizetext(SIZE,TEXT,...)
	#define weaklogaffinetr(AFFINE)
	#define weaklog3dtr(TRANSFORM3D)
#endif

#if LOG_ERR
	#define errlog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define errlog(TEXT,...)
#endif
#if LOG_URL
	#define urllog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define urllog(TEXT,...)
#endif
#if LOG_IAP
	#define iaplog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define iaplog(TEXT,...)
#endif
#if LOG_APNS
	#define apnslog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define apnslog(TEXT,...)
#endif
#if LOG_PD
	#define pdlog(TEXT,...)								cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define pdlog(TEXT,...)
#endif
#if LOG_RF
	#define rflog(TEXT,...)								cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define rflog(TEXT,...)
#endif
#if LOG_UI
	#define uilog(TEXT,...)								cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define uilog(TEXT,...)
#endif
#if LOG_DBG
	#define dbglog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define dbglog(TEXT,...)
#endif
#if LOG_LOG
	#define loglog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define loglog(TEXT,...)
#endif
#if LOG_TEST
	#define testlog(TEXT,...)							cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define testlog(TEXT,...)
#endif
#if LOG_SERVICE
	#define servicelog(TEXT,...)						cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define servicelog(TEXT,...)
#endif
#if LOG_EA
	#define ealog(TEXT,...)								cmdlogtext(TEXT, ##__VA_ARGS__);
#else
	#define ealog(TEXT,...)
#endif


#pragma mark -
#pragma mark Helper macros

// likely, unlikely
#if ENABLE_LIKELY_UNLIKELY
	#define likely(expr)								__builtin_expect((expr), !0)
	#define unlikely(expr)								__builtin_expect((expr), 0)
#else
	#define likely(expr)								(expr)
	#define unlikely(expr)								(expr)
#endif

// debugger
#define debugger()										{ kill( getpid(), SIGINT ) ; }
//#define debugger()										{	\
//	#if TARGET_IPHONE_SIMULATOR								\
//		asm("int3")											\
//	#else													\
//		asm("trap")											\
//	#endif													\
//}

// assert
#define assertlog(e, LOG)								{ if (unlikely(!(e))) { cmdlog(LOG); assert(e); } }


#pragma mark -
#pragma mark Shorthand helper methods

#define _nullref(EXPR, REF)								(_nil(EXPR) != NULL ? EXPR->REF : NULL)
#define _nsarray(OBJ,...)								[NSArray arrayWithObjects:OBJ, ##__VA_ARGS__, nil]
#define _nsmutarr(OBJ,...)								[NSMutableArray arrayWithObjects:OBJ, ##__VA_ARGS__, nil]
#define _nsdictionary(OBJ,...)							[NSDictionary dictionaryWithObjectsAndKeys:OBJ, ##__VA_ARGS__, nil]
#define _nsmutdict(OBJ,...)								[NSMutableDictionary dictionaryWithObjectsAndKeys:OBJ, ##__VA_ARGS__, nil]
#define _nsset(OBJ,...)									[NSSet setWithObjects:OBJ, ##__VA_ARGS__, nil]
#define _nsmutset(OBJ,...)								[NSMutableSet setWithObjects:OBJ, ##__VA_ARGS__, nil]


#pragma mark -
#pragma mark Quick helper methods

// round integer to multiple of a number
static inline NSUInteger _roundIntegerToMultiple(NSUInteger number, NSUInteger multiple) {
	if (number % multiple == 0) return number;
	return (((number + multiple / 2) / multiple) * multiple);
}

static inline NSUInteger _ceilIntegerToMultiple(NSUInteger number, NSUInteger multiple) {
	if (number % multiple == 0) return number;
	//return (number - number % multiple + multiple);
	return (((number + multiple) / multiple) * multiple);
}

static inline NSUInteger _floorIntegerToMultiple(NSUInteger number, NSUInteger multiple) {
	if (number % multiple == 0) return number;
	return ((number / multiple) * multiple);
}

// round integer to power of 2
static inline bool _isPowerOfTwo(NSUInteger number) {
	return ((number & (number - 1)) == 0);
}

static inline NSUInteger _roundIntegerToPowerOfTwo(NSUInteger number) {
	if (_isPowerOfTwo(number)) return number;
	return pow(2, round(log(number) / log(2)));
}

static inline NSUInteger _ceilIntegerToPowerOfTwo(NSUInteger number) {
	if (_isPowerOfTwo(number)) return number;
	int power = 2;
	while (number >>= 1) power <<= 1;
	return power;
}

static inline NSUInteger _floorIntegerToPowerOfTwo(NSUInteger number) {
	if (_isPowerOfTwo(number)) return number;
	int power = 1;
	while (number >>= 1) power <<= 1;
	return power;
}

// NSNull <-> "<null>" helper
static inline id _replaceNSNull(id object) {
	return ([object isEqual:[NSNull null]] ? @"<null>" : object);
}

static inline id _appendNSNull(id object) {
	return ([object isEqual:@"<null>"] ? [NSNull null] : object);
}

// radian <-> degree helper
static inline double _deg(double radian) {
	return (radian * (180.0 / M_PI));
}

static inline double _rad(double degree) {
	return (degree * (M_PI / 180.0));
}

// m/s <-> km/h helper
static inline double _ms(double kmh) {
	return (kmh / 3.6);
}

static inline double _kmh(double ms) {
	return (ms * 3.6);
}


#pragma mark -
#pragma mark Helper defines

// autoresizing mask predefines
#define UIAutoresizeMask								(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
#define UIFixedMask										(UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin)
#define UIIndependentMask								(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)

// line break mode compatibility defines
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
	#define UILineBreak									NSLineBreakMode
	#define UIWordWrapLineBreak							NSLineBreakByWordWrapping
	#define UICharacterWrapLineBreak					NSLineBreakByCharWrapping
	#define UIClipLineBreak								NSLineBreakByClipping
	#define UIHeadTruncationLineBreak					NSLineBreakByTruncatingHead
	#define UITailTruncationLineBreak					NSLineBreakByTruncatingTail
	#define UIMiddleTruncationLineBreak					NSLineBreakByTruncatingMiddle
	#define UIAlignment									NSTextAlignment
	#define UICenterAlignment							NSTextAlignmentCenter
	#define UILeftAlignment								NSTextAlignmentLeft
	#define UIRightAlignment							NSTextAlignmentRight
	#define UIJustifiedAlignment						NSTextAlignmentJustified
	#define UINaturalAlignment							NSTextAlignmentNatural
#else
	#define UILineBreak									UILineBreakMode
	#define UIWordWrapLineBreak							UILineBreakModeWordWrap
	#define UICharacterWrapLineBreak					UILineBreakModeCharacterWrap
	#define UIClipLineBreak								UILineBreakModeClip
	#define UIHeadTruncationLineBreak					UILineBreakModeHeadTruncation
	#define UITailTruncationLineBreak					UILineBreakModeTailTruncation
	#define UIMiddleTruncationLineBreak					UILineBreakModeMiddleTruncation
	#define UIAlignment									UITextAlignment
	#define UICenterAlignment							UITextAlignmentCenter
	#define UILeftAlignment								UITextAlignmentLeft
	#define UIRightAlignment							UITextAlignmentRight
	#define UIJustifiedAlignment						kCTJustifiedTextAlignment	// no such option prior to iOS 6.0 (compatibility: using CT type which has the same value)
	#define UINaturalAlignment							kCTNaturalTextAlignment		// no such option prior to iOS 6.0 (compatibility: using CT type which has the same value)
#endif


#pragma mark -
#pragma mark Variable argument handling

static BOOL (*objc_msgSend_arg_boolret)(id object, SEL cmd, id arg) = (BOOL (*)(id, SEL, id))&objc_msgSend;
static BOOL (*objc_msgSend_boolret)(id object, SEL cmd) = (BOOL (*)(id, SEL))&objc_msgSend;


static inline void dummy_warning_suppresser() {
	objc_msgSend_arg_boolret(nil, nil, nil);
	objc_msgSend_boolret(nil, nil);
}

#pragma mark -
#pragma mark Bit handling

/* Print n as a binary number */
typedef enum BinTetrades {
	b0000 = 0x00,
	b0001 = 0x01,
	b0010 = 0x02,
	b0011 = 0x03,
	b0100 = 0x04,
	b0101 = 0x05,
	b0110 = 0x06,
	b0111 = 0x07,
	b1000 = 0x08,
	b1001 = 0x09,
	b1010 = 0x0A,
	b1011 = 0x0B,
	b1100 = 0x0C,
	b1101 = 0x0D,
	b1110 = 0x0E,
	b1111 = 0x0F
} BinTetrades;

/* 1 nibble to 4 bits */
#define B4(lsn)																	(unsigned short)(b##lsn)
/* 2 nibbles to 8 bits */
#define B8(msn,lsn)																((unsigned short)B4(msn)<<4 | (unsigned short)B4(lsn))
/* 4 nibbles to 16 bits */
#define B16(msn,n2, n1,lsn)														((unsigned int)B8(msn,n2)<<8 | (unsigned int)B8(n1,lsn))
/* 8 nibbles to 32 bits */
#define B32(msn,n6, n5,n4, n3,n2, n1,lsn)										((unsigned long)B16(msn,n6, n5,n4)<<16 | (unsigned long)B16(n3,n2, n1,lsn))
/* 16 nibbles to 64 bits */
#define B64(msn,n14, n13,n12, n11,n10, n9,n8, n7,n6, n5,n4, n3,n2, n1,lsn)		((unsigned long long)B32(msn,n14, n13,n12, n11,n10, n9,n8)<<32 | (unsigned long long)B32(n7,n6, n5,n4, n3,n2, n1,lsn))


#define _setBit(STATE, BIT)														((STATE) |= (1 << (BIT)))
#define _clearBit(STATE, BIT)													((STATE) &= ~(1 << (BIT)))
#define _toggleBit(STATE, BIT)													((STATE) ^= (1 << (BIT)))
#define _checkBit(STATE, BIT)													((STATE) & (BIT))

#define _setFlag(STATE, FLAG)													((STATE) |= (FLAG))
#define _clearFlag(STATE, FLAG)													((STATE) &= ~(FLAG))
#define _toggleFlag(STATE, FLAG)												((STATE) ^= (FLAG))
#define _checkFlag(STATE, FLAG)													((STATE) & (FLAG))


#pragma mark -
#pragma mark Bits handling methods

#pragma GCC diagnostic ignored "-Wunused-function"
static void printbits(unsigned long long n) {
	unsigned long long i, step;
	
	if (0 == n) { /* For simplicity's sake, I treat 0 as a special case*/
		printf("0000\n");
		return;
	}
	
	i = (unsigned long long)1<<(sizeof(n) * 8 - 1);
	
	step = -1; /* Only print the relevant digits */
	step >>= 4; /* In groups of 4 */
	while (step >= n) {
		i >>= 4;
		step >>= 4;
	}
	
	/* At this point, i is the smallest power of two larger or equal to n */
	while (i > 0) {
		if (n & i)
			printf("1");
		else
			printf("0");
		i >>= 1;
	}
	printf("\n");
}
#pragma GCC diagnostic warning "-Wunused-function"


#pragma mark -
#pragma mark Safe helper methods

static inline id _nsnull(id object) {
	return [NSNull convertToNSNull:object];
}

static inline id _nil(id object) {
	return [NSNull convertFromNSNull:object];
}

static inline CGRect _safeframe(UIView *view) {
	return (_nil(view) != NULL ? view.frame : CGRectZero);
}

static inline CGRect _safebounds(UIView *view) {
	return (_nil(view) != NULL ? view.bounds : CGRectZero);
}

static inline id _safeexpr(id expression, id safe) {
	return (_nil(expression) != NULL ? expression : safe);
}

static inline NSString *_zerostr(NSString *string) {
	return (_nil(string) != NULL ? string : @"");
}

static inline NSNumber *_zeronum(NSNumber *number) {
	return (_nil(number) != NULL ? number : @0);
}

static inline NSNumber *_onenum(NSNumber *number) {
	return (_nil(number) != NULL ? number : @1);
}

static inline NSNumber *_yesnum(NSNumber *number) {
	return (_nil(number) != NULL ? number : @YES);
}

static inline NSNumber *_nonum(NSNumber *number) {
	return (_nil(number) != NULL ? number : @NO);
}

static inline NSDictionary *_zerodict(NSDictionary *dictionary) {
	return (_nil(dictionary) != NULL ? dictionary : @{});
}

static inline NSArray *_zeroarr(NSArray *array) {
	return (_nil(array) != NULL ? array : @[]);
}

static inline NSString *_nsstr(NSString *string, ...) {
	if (!string) return nil;
	va_list args;
	va_start(args, string);
	NSString *result = [[NSString alloc] initWithFormat:string arguments:args];
	va_end(args);
#if !__has_feature(objc_arc)
	return [result autorelease];
#else
	return result;
#endif
}

static inline NSString *_nmutsstr(NSString *string, ...) {
	if (!string) return nil;
	va_list args;
	va_start(args, string);
	NSString *result = [[NSMutableString alloc] initWithFormat:string arguments:args];
	va_end(args);
#if !__has_feature(objc_arc)
	return [result autorelease];
#else
	return result;
#endif
}


#pragma mark -
#pragma mark Safe getter methods

static inline NSString *_safestr(NSObject *obj) {
	if ([obj isKindOfClass:[NSString class]]) {
		return (NSString *)obj;
	}
	if ([obj isKindOfClass:[NSNumber class]]) {
		return [(NSNumber *)obj stringValue];
	}
	return nil;
}

static inline NSNumber *_safenum(NSObject *obj) {
	if ([obj isKindOfClass:[NSNumber class]]) {
		return (NSNumber *)obj;
	}
	if ([obj isKindOfClass:[NSString class]]) {
		return [(NSString *)obj numberValue];
	}
	return nil;
}

static inline NSURL *_safeurl(NSURL *obj) {
	if ([obj isKindOfClass:[NSURL class]]) {
		return (NSURL *)obj;
	}
	return nil;
}

static inline NSData *_safedata(NSObject *obj) {
	if ([obj isKindOfClass:[NSData class]]) {
		return (NSData *)obj;
	}
	return nil;
}

static inline NSDate *_safedate(NSObject *obj) {
	if ([obj isKindOfClass:[NSDate class]]) {
		return (NSDate *)obj;
	}
	return nil;
}

static inline NSArray *_safearray(NSObject *obj) {
	if ([obj isKindOfClass:[NSArray class]]) {
		return (NSArray *)obj;
	}
	return nil;
}

static inline NSDictionary *_safedict(NSObject *obj) {
	if ([obj isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary *)obj;
	}
	return nil;
}


#pragma mark -
#pragma mark Distance helper method

static inline double _distance(double from, double to) {
	if (from == to) return 0.0;
	if (from > 0.0 && to > 0.0) {
		if (from < to) return (to - from);
		else return -(from - to);
	}
	else if (from < 0.0 && to > 0.0) {
		return (to + fabs(from));
	}
	else if (from > 0.0 && to < 0.0) {
		return -(from + fabs(to));
	}
	else if (from < 0.0 && to < 0.0) {
		if (from < to) return (fabs(from) - fabs(to));
		else return -(fabs(to) - fabs(from));
	}
	return 0.0;
}


#pragma mark -
#pragma mark Coordinate helper methods

#define kEarthRadius		6378137.0

static inline double DistanceFrom(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
	double lat1 = c1.latitude;
	double lon1 = c1.longitude;
	double lat2 = c2.latitude;
	double lon2 = c2.longitude;
	double earthRadius = 6371.0;
	
	double factor = M_PI / 180.0;
	double dLat = (lat2-lat1) * factor;
	double dLon = (lon2-lon1) * factor;
	double a = sin(dLat/2.0) * sin(dLat/2.0) + cos(lat1*factor) * cos(lat2*factor) * sin(dLon/2.0) * sin(dLon/2.0);
	double c = 2.0 * atan2(sqrt(a), sqrt(1.0-a));
	
	return (earthRadius * c) * 1000.0;
}

static inline CGPoint ConvertMercatorToWGS84(CGPoint mercator) {
	double longitudeFactor = M_PI / 180.0 * kEarthRadius;
	double wgsLongitude = mercator.x / longitudeFactor;
	double wgsLatitude = (2.0 * atan(exp(mercator.y / kEarthRadius)) - M_PI_2) / (M_PI / 180.0);
	
	return CGPointMake(wgsLongitude, wgsLatitude);
}

static inline CGPoint ConvertWGS84ToMercator(CGPoint wgs84) {
	double longitudeFactor = M_PI / 180.0 * kEarthRadius;
	double sinLatitude = sin(wgs84.y * (M_PI / 180.0));
	double mercatorX = wgs84.x * longitudeFactor;
	double mercatorY = 0.5 * log((1.0 + sinLatitude) / (1.0 - sinLatitude)) * kEarthRadius;
	
	return CGPointMake(mercatorX, mercatorY);
}

//
// Convert latitude and longitude to pixel values at zoom level 20.
// At zoom level 0, Google displays the world in a single 256 pixel by 256 pixel tile:
// At zoom level 1, Google doubles the area of the map while keeping the tile size constant.
//
#define kMercatorOffset 268435456.0 /* (total pixels at zoom level 20) / 2 */
#define kMercatorRadius 85445659.44705395 /* MERCATOR_OFFSET / pi */

static inline double LatitudeToPixelSpaceY(double latitude) {
	return round(kMercatorOffset - kMercatorRadius * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

static inline double LongitudeToPixelSpaceX(double longitude) {
	return round(kMercatorOffset + kMercatorRadius * longitude * M_PI / 180.0);
}

static inline double PixelSpaceYToLatitude(double pixelY) {
	return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - kMercatorOffset) / kMercatorRadius))) * 180.0 / M_PI;
}

static inline double PixelSpaceXToLongitude(double pixelX) {
	return ((round(pixelX) - kMercatorOffset) / kMercatorRadius) * 180.0 / M_PI;
}


#if ENABLE_DEBUG_TEXTS
static NSString *const kLoremIpsum				= @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.";
// Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum."
static NSString *const kENPangram				= @"the quick brown fox jumps over the lazy dog, THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG";
static NSString *const kHUPangram				= @"jó foxim és don Quijote húszwattos lámpánál ülve egy pár bűvös cipőt készít, JÓ FOXIM ÉS DON QUIJOTE HÚSZWATTOS LÁMPÁNÁL ÜLVE EGY PÁR BŰVÖS CIPŐT KÉSZÍT";//@"árvíztűrő tükörfúrógép, ÁRVÍZTŰRŐ TÜKÖRFÚRÓGÉP";
static NSString *const kGEPangram				= @"victor jagt zwölf boxkämpfer quer über den großen sylter deich, VICTOR JAGT ZWÖLF BOXKÄMPFER QUER ÜBER DEN GROßEN SYLTER DEICH";
#endif
// charsets
static NSString *const kNormalCharSet			= @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
static NSString *const kIntegerCharSet			= @"1234567890";
static NSString *const kHexaCharSet				= @"1234567890ABCDEF";
static NSString *const kPhoneCharSet			= @"1234567890-/() ";
// e-mail
static NSString *const kEmailNameCharSet		= @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!#$%&'*+-/=?^_`{|}~.";
static NSString *const kEmailServerCharSet		= @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.";

