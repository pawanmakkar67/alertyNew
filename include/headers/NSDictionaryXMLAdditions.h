//
//  NSDictionaryAdditions.h
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


@interface NSDictionary (XMLExtension)

+ (NSMutableArray*) xmlWithSimpleDictionary:(NSDictionary*)dictionary;

+ (NSMutableDictionary*) xmlMutableNodeWithName:(NSString*)name params:(NSDictionary*)params value:(id)value children:(NSArray*)children;
+ (NSMutableDictionary*) xmlMutableNodeWithName:(NSString*)name params:(NSDictionary*)params value:(id)value children:(NSArray*)children addNSNulls:(BOOL)addnsnulls;
+ (NSDictionary*) xmlNodeWithName:(NSString*)name params:(NSDictionary*)params value:(id)value children:(NSArray*)children;
+ (NSDictionary*) xmlNodeWithName:(NSString*)name params:(NSDictionary*)params value:(id)value children:(NSArray*)children addNSNulls:(BOOL)addnsnulls;
+ (NSMutableDictionary*) xmlMakeNodeWithName:(NSString*)name params:(NSDictionary*)params value:(id)value children:(NSArray*)children addNSNulls:(BOOL)addnsnulls asMutable:(BOOL)asmutable;

- (NSDictionary*) xmlAddContainer:(NSString*)name params:(NSDictionary*)params value:(id)value;
- (NSDictionary*) xmlAddSubContainer:(NSString*)name params:(NSDictionary*)params value:(id)value;
- (NSArray*) xmlNames;								// non recursive
- (NSArray*) xmlValues;								// non recursive
- (NSDictionary*) xmlEntry;							// the first cheildren of the root xml node
- (NSString*) xmlContainer;							// name of the xmlEntry
- (id) xmlParam:(NSString*)param;
- (NSDictionary*) xmlParams;
- (NSArray*) xmlChildren;
- (NSArray*) xmlChildrenByName:(NSString*)name;		// just look up in xmlChildren
- (NSString*) xmlName;
- (id) xmlValue;
// recursive methods
- (NSDictionary*) xmlRemoveNodesByName:(NSString*)name;
- (NSDictionary*) xmlAddNodesByName:(NSString*)name node:(NSDictionary*)node;
- (NSArray*) xmlNodesByName:(NSString*)name;
- (NSArray*) xmlParamsByName:(NSString*)name;
- (NSArray*) xmlValuesByName:(NSString*)name;
- (NSArray*) xmlValuesByName:(NSString*)name addNSNulls:(BOOL)addnsnulls;
- (id) xmlFirstValueByName:(NSString*)name;
- (NSDictionary*) xmlFirstNodeByName:(NSString*)name;
+ (NSDictionary*) xmlRemoveNodesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary;
+ (NSDictionary*) xmlAddNodesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary node:(NSDictionary*)node;
+ (NSArray*) xmlNodesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary;
+ (NSArray*) xmlNodesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary firstMatch:(BOOL)firstMatch;
+ (NSArray*) xmlParamsByName:(NSString*)name inDictionary:(NSDictionary*)dictionary;
+ (NSArray*) xmlValuesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary addNSNulls:(BOOL)addnsnulls;
+ (NSArray*) xmlValuesByName:(NSString*)name inDictionary:(NSDictionary*)dictionary addNSNulls:(BOOL)addnsnulls firstMatch:(BOOL)firstMatch;
- (NSArray*) xmlValuesMatchFor:(SEL)selector;
- (NSArray*) xmlValuesMatchFor:(SEL)selector arg:(id)arg;
+ (NSArray*) xmlValuesMatchFor:(SEL)selector inDictionary:(NSDictionary*)dictionary firstMatch:(BOOL)firstMatch;
+ (NSArray*) xmlValuesMatchFor:(SEL)selector arg:(id)arg inDictionary:(NSDictionary*)dictionary firstMatch:(BOOL)firstMatch;
+ (NSArray*) xmlValuesMatchFor:(SEL)selector arg:(id)arg usearg:(BOOL)usearg inDictionary:(NSDictionary*)dictionary firstMatch:(BOOL)firstMatch;
+ (NSComparisonResult) xmlCompareDictionary:(NSDictionary*)dictionary1 withDictionary:(NSDictionary*)dictionary2;
- (NSArray*) xmlNodesByValueName:(NSString*)nodeName value:(id)value;
+ (NSArray*) xmlNodesByValueName:(NSString*)nodeName value:(id)value inDictionary:(NSDictionary*)dictionary;
// these will add NSNulls if xmlValue or xmlParam: gives nil
- (NSArray*) xmlNodeParamsForNodes:(NSString*)nodeName param:(NSString*)paramName;
- (NSArray*) xmlNodeValuesForNodes:(NSString*)nodeName value:(NSString*)valueName;
+ (NSArray*) xmlNodeParamsForNodes:(NSString*)nodeName param:(NSString*)paramName inDictionary:(NSDictionary*)dictionary;
+ (NSArray*) xmlNodeValuesForNodes:(NSString*)nodeName value:(NSString*)valueName inDictionary:(NSDictionary*)dictionary;

@end
