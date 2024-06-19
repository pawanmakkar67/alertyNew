//
//  TabBarHidingNavigationController.h
//
//  Created by Balint Bence on 4/13/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TabBarHidingNavigationController : UINavigationController
{
	NSArray *_managedViewControllerClasses;
	BOOL _manageTabBar;
	BOOL _hideTabBar;
}

@property (readwrite,retain) NSArray *managedViewControllerClasses;		// view controller classes that must be checked during [push|pop]ViewController calls
@property (readwrite,assign) BOOL manageTabBar;							// turn on tab bar visibility management
@property (readwrite,assign) BOOL hideTabBar;							// set hide or show for manager view controller classes

@end
