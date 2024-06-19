//
//  ListDataParser.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ListDataParser <NSObject>
@required
- (void) parse:(id)data;
- (NSMutableArray*) items;
- (NSInteger) total;
- (void) cleanup;
@end


@protocol PlainSectionedListDataParser <ListDataParser>
@required
- (NSMutableArray*) headers;
- (NSMutableArray*) footers;
@end


@interface ListDataParserBase : NSObject <ListDataParser>
{
	NSMutableArray *_parsedItems;
	NSInteger _parsedTotal;
}

@end


@interface ListDataParserBase ()
@property (readwrite,retain) NSMutableArray *parsedItems;
@property (readwrite,assign) NSInteger parsedTotal;
@end
