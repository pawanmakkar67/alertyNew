//
//  XML.h
//
//  Created by Bence Balint on 10/13/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const XMLNameKey;
extern NSString *const XMLValueKey;
extern NSString *const XMLParamsKey;
extern NSString *const XMLChildrenKey;
extern NSString *const XMLValueEnumeratorNumberKey;


typedef id (^ConversionBlock)(id value, NSString *xmlpath);


@interface XML : NSObject <NSXMLParserDelegate>
{
	NSXMLParser *_parser;
	NSMutableDictionary *_dictionary;
	// during parsing
	NSMutableArray *_xmlpath;
	NSMutableDictionary *_element;
	// use minimal mem footprint (does not creates unnecessary nodes)
	BOOL _minimalRepresentation;
	// convert values for types by xmlpath
	ConversionBlock _conversionBlock;
}

+ (NSDictionary*) parseData:(NSData*)data;
+ (NSDictionary*) parseData:(NSData*)data minimalRepresentation:(BOOL)minimalRepresentation;
+ (NSDictionary*) parseData:(NSData*)data withConversionBlock:(ConversionBlock)conversionBlock;
+ (NSDictionary*) parseData:(NSData*)data withConversionBlock:(ConversionBlock)conversionBlock minimalRepresentation:(BOOL)minimalRepresentation;
+ (NSDictionary*) parseString:(NSString*)string;
+ (NSDictionary*) parseString:(NSString*)string minimalRepresentation:(BOOL)minimalRepresentation;
+ (NSDictionary*) parseString:(NSString*)string withConversionBlock:(ConversionBlock)conversionBlock;
+ (NSDictionary*) parseString:(NSString*)string withConversionBlock:(ConversionBlock)conversionBlock minimalRepresentation:(BOOL)minimalRepresentation;
+ (NSString*) stringRepresentation:(NSDictionary*)dictionary;
+ (NSString*) stringRepresentation:(NSDictionary*)dictionary indent:(NSInteger)indent copyheader:(BOOL)copyheader;
+ (NSString*) stringParams:(NSDictionary*)params;

+ (void) addXMLElemToDictionary:(NSMutableDictionary*)dictionary name:(NSString*)name value:(id)value;

@end


// XMLparam
//		name(NSString)
//		value(NSString)
// XMLnode
//		name(NSString)
//		value(NSString)
//		params(NSMutableDictionary)
//		children(NSArray)
//		valuepos(NSNumber)
