//
//  MWPools.h
//
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractSingleton.h"


@interface MWPoolBase : AbstractSingleton
{
	NSMutableDictionary *_pool;
	NSMutableDictionary *_kepts;
}

+ (id) instance;

+ (void) reset;
+ (void) resetNonKepts;
+ (BOOL) pushItem:(id)item forKey:(NSString*)key;
+ (BOOL) popItem:(NSString*)key;
+ (void) popAll;
+ (id) item:(NSString*)key;
+ (void) keep:(id)keeper key:(NSString*)key;
+ (void) unkeep:(id)keeper key:(NSString*)key;
+ (void) unkeepAll:(id)keeper;

@end


@interface MWDataPool : MWPoolBase {
}
@end


@interface MWStringPool : MWPoolBase {
}
@end


@interface MWArrayPool : MWPoolBase {
}
@end


@interface MWDictionaryPool : MWPoolBase {
}
@end


@interface MWMutableDataPool : MWPoolBase {
}
@end


@interface MWMutableStringPool : MWPoolBase {
}
@end


@interface MWMutableArrayPool : MWPoolBase {
}
@end


@interface MWMutableDictionaryPool : MWPoolBase {
}
@end


@interface MWImagePool : MWPoolBase {
}
@end

