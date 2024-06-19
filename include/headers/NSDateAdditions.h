//
//  NSDateAdditions.h
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


static const int32_t KReferenceDateYear		= 1970;
static const int32_t KReferenceDateMonth	= 1;
static const int32_t KReferenceDateDay		= 1;


@interface NSDate (ExtendedMethods)

- (NSNumber*) number;
- (NSNumber*) millisecondsNumber;
- (double) timestamp;
- (double) millisecondsTimestamp;

+ (NSDate*) dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
					hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
			  fractional:(NSTimeInterval)fractional;
+ (NSDate*) dateWithYear:(NSInteger)year week:(NSInteger)week weekday:(NSInteger)weekday
					hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
			  fractional:(NSTimeInterval)fractional;
+ (NSDate*) dateWithLocalizedDateString:(NSString*)localeFormattedString;
+ (NSDate*) dateWithLocalizedTimeString:(NSString*)localeFormattedString;
+ (NSDate*) dateWithLocalizedDateTimeString:(NSString*)localeFormattedString;
- (NSString*) toLocalizedDateOnlyString;
- (NSString*) toLocalizedTimeOnlyString;
- (NSString*) toLocalizedDateTimeString;

+ (NSDate*) now;
+ (NSDate*) nulltime;
+ (double) timestamp;
+ (double) millisecondsTimestamp;
+ (NSDate*) reference;
+ (NSDate*) today;
+ (NSDate*) yesterday;
- (NSDate*) yearPreciseDate;
- (NSDate*) monthPreciseDate;
- (NSDate*) dayPreciseDate;
- (NSDate*) hourPreciseDate;
- (NSDate*) minutePreciseDate;
- (NSDate*) secondPreciseDate;

+ (NSDate*) tomorrow;
+ (NSString*) timeZone;
- (NSDate*) addDays:(NSInteger)days;
- (NSDate*) addHours:(NSInteger)hours;
- (NSDate*) addMinutes:(NSInteger)minutes;
- (NSDate*) addSeconds:(NSInteger)seconds;
- (NSDate*) addFractional:(NSTimeInterval)fractional;
- (NSString*) toString:(NSString*)separator datesep:(NSString*)datesep reverse:(BOOL)reverse timesep:(NSString*)timesep fractional:(BOOL)fractional;
- (NSString*) dateToString:(NSString*)separator reverse:(BOOL)reverse;
- (NSString*) timeToString:(NSString*)separator fractional:(BOOL)fractional;
- (NSDateComponents*) components:(NSUInteger)unitFlags;
- (NSInteger) year;
- (NSInteger) month;
- (NSInteger) day;
- (NSInteger) hour;
- (NSInteger) minute;
- (NSInteger) second;
- (NSTimeInterval) fractional;
- (NSDate*) convertToUTC;
- (NSDate*) convertFromUTC;
- (NSDate*) utcDate;
- (NSDate*) localDate;
- (int64_t) seconds;
- (int64_t) milliseconds;
- (int64_t) microseconds;
- (NSString*) relativeFormattedString;
+ (NSDate*) dateFromString:(NSString*)string;
+ (NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format;
+ (NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format timeZoneAbbreviation:(NSString*)abbreviation;
+ (NSDate*) dateFromString:(NSString*)string withFormat:(NSString*)format timeZone:(NSTimeZone*)zone;
+ (NSString*) stringFromDate:(NSDate*)date;
+ (NSString*) stringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*) stringFromDate:(NSDate*)date withFormat:(NSString*)format timeZoneAbbreviation:(NSString*)abbreviation;
+ (NSString*) stringFromDate:(NSDate*)date withFormat:(NSString*)format timeZone:(NSTimeZone*)zone;
- (NSString*) string;
- (NSString*) stringWithFormat:(NSString*)format;
- (NSString*) stringWithFormat:(NSString*)format timeZoneAbbreviation:(NSString*)abbreviation;
- (NSString*) stringWithFormat:(NSString*)format timeZone:(NSTimeZone*)zone;
+ (NSDate*) dateFromRFC1123String:(NSString*)string;
+ (NSDate*) dateFromRFC850String:(NSString*)string;
- (NSString*) rfc1123String;
- (NSString*) rfc850String;

@end
