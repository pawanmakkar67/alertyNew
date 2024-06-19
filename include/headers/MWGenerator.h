//
//  MWGenerator.h
//
//  Created by Balint Bence on 7/12/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractSingleton.h"


// 
// Usage:
// 
// [MWGenerator addUI:window frame:CGRectMake(20.0, 20.0, 88.0, 44.0)];
// 

@interface MWGenerator : AbstractSingleton
{
	NSThread *_memAllocThread;
	NSMutableData *_memAllocData;
	UIButton *_generateButton;
	UIButton *_cleanupButton;
}

+ (MWGenerator*) instance;

+ (void) generate;
+ (void) cleanup;
+ (void) cancel;
+ (void) addUI:(UIView*)view frame:(CGRect)frame;

@end
