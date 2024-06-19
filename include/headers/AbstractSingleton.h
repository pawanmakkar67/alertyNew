//
//  AbstractSingleton.h
//  
//  Created by Bence Balint on 5/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AbstractSingleton : NSObject
{
}

+ (id)singleton;
+ (id)singletonWithZone:(NSZone*)zone;

// designated initializer, subclasses must implement and call supers implementation
- (id)initSingleton;

@end
