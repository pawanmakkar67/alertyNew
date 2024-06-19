//
//  MWMutableDictionaryStorePlainSectionedListDataSource.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListDataSource.h"


@interface MWMutableDictionaryStorePlainSectionedListDataSource : PlainSectionedListDataSourceBase
{
	NSString *_name;
	BOOL _createListItems;
}

@end


@interface MWMutableDictionaryStorePlainSectionedListDataSource ()
@property (readwrite,retain) NSString *name;
@property (readwrite,assign) BOOL createListItems;
@end
