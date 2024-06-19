//
//  NSArrayXMLAdditions.h
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


@interface NSArray (XMLExtension)

+ (NSMutableArray*) xmlEncapsulateNodes:(NSArray*)array name:(NSString*)name params:(NSDictionary*)params value:(id)value;

- (NSDictionary*) xmlAddContainer:(NSString*)name params:(NSDictionary*)params value:(id)value;
- (NSArray*) xmlNames;								// non recursive
- (NSArray*) xmlValues;								// non recursive
- (NSArray*) xmlChildrenByName:(NSString*)name;		// just look up in xmlChildren
// recursive methods
- (NSArray*) xmlRemoveNodesByName:(NSString*)name;
- (NSArray*) xmlAddNodesByName:(NSString*)name node:(NSDictionary*)node;
- (NSArray*) xmlNodesByName:(NSString*)name;
- (NSArray*) xmlParamsByName:(NSString*)name;
- (NSArray*) xmlValuesByName:(NSString*)name;
- (id) xmlFirstValueByName:(NSString*)name;
- (NSDictionary*) xmlFirstNodeByName:(NSString*)name;
- (NSArray*) xmlValuesByName:(NSString*)name addNSNulls:(BOOL)addnsnulls;
+ (NSArray*) xmlRemoveNodesByName:(NSString*)name inArray:(NSArray*)array;
+ (NSArray*) xmlAddNodesByName:(NSString*)name inArray:(NSArray*)array node:(NSDictionary*)node;
+ (NSArray*) xmlNodesByName:(NSString*)name inArray:(NSArray*)array;
+ (NSArray*) xmlNodesByName:(NSString*)name inArray:(NSArray*)array firstMatch:(BOOL)firstMatch;
+ (NSArray*) xmlParamsByName:(NSString*)name inArray:(NSArray*)array;
+ (NSArray*) xmlValuesByName:(NSString*)name inArray:(NSArray*)array addNSNulls:(BOOL)addnsnulls;
+ (NSArray*) xmlValuesByName:(NSString*)name inArray:(NSArray*)array addNSNulls:(BOOL)addnsnulls firstMatch:(BOOL)firstMatch;
- (NSArray*) xmlValuesMatchFor:(SEL)selector;
- (NSArray*) xmlValuesMatchFor:(SEL)selector arg:(id)arg;
+ (NSArray*) xmlValuesMatchFor:(SEL)selector inArray:(NSArray*)array firstMatch:(BOOL)firstMatch;
+ (NSArray*) xmlValuesMatchFor:(SEL)selector arg:(id)arg inArray:(NSArray*)array firstMatch:(BOOL)firstMatch;
+ (NSArray*) xmlValuesMatchFor:(SEL)selector arg:(id)arg usearg:(BOOL)usearg inArray:(NSArray*)array firstMatch:(BOOL)firstMatch;
+ (NSComparisonResult) xmlCompareArray:(NSArray*)array1 withArray:(NSArray*)array2;
- (NSArray*) xmlNodesByValueName:(NSString*)nodeName value:(id)value;
+ (NSArray*) xmlNodesByValueName:(NSString*)nodeName value:(id)value inArray:(NSArray*)array;
// these will add NSNulls if xmlValue or xmlParam: gives nil
- (NSArray*) xmlNodeParamsForNodes:(NSString*)nodeName param:(NSString*)paramName;
- (NSArray*) xmlNodeValuesForNodes:(NSString*)nodeName value:(NSString*)valueName;
+ (NSArray*) xmlNodeParamsForNodes:(NSString*)nodeName param:(NSString*)paramName inArray:(NSArray*)array;
+ (NSArray*) xmlNodeValuesForNodes:(NSString*)nodeName value:(NSString*)valueName inArray:(NSArray*)array;

@end
