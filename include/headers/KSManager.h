//
//  KSManager.h
//
//  Created by Balint Bence on 7/4/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractSingleton.h"


@interface KSManager : AbstractSingleton
{
}

+ (void) reset;
+ (void) check:(NSString*)url interval:(NSTimeInterval)interval;

@end
