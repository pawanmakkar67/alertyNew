//
//  PlainSectionedDictionaryListDataParser.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListDataParser.h"


@interface PlainSectionedDictionaryListDataParser : ListDataParserBase
{
	NSMutableArray *_parsedHeaders;
	NSMutableArray *_parsedFooters;
}

@end