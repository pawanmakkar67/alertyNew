//
//  ArrayListDataSource.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListDataSource.h"


@interface ArrayListDataSource : ListDataSourceBase
{
	BOOL _createListItems;
}

@property (readwrite,assign) BOOL createListItems;

@end