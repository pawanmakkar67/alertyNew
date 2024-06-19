//
//  TVOutManager.h
//
//  Created by Balint Bence on 2/28/13.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractSingleton.h"
#if HAVE_CUSTOM_ALERT
#import "AlertView.h"
#endif


@interface TVOutManager : AbstractSingleton
#if HAVE_CUSTOM_ALERT
<CustomAlertViewDelegate>
#else
<UIAlertViewDelegate>
#endif
{
	// supported screens resoulutions alert
#if HAVE_CUSTOM_ALERT
	AlertView *_modesAlert;
#else
	UIAlertView *_modesAlert;
#endif
	// external or internal window according to the current hw setup
	UIWindow *_displayWindow;
}

@property (nonatomic,retain) IBOutlet UIWindow *internalWindow;
@property (nonatomic,retain) IBOutlet UINavigationController *internalNavigationController;
@property (nonatomic,retain) IBOutlet UIWindow *externalWindow;
@property (nonatomic,retain) IBOutlet UINavigationController *externalNavigationController;

+ (TVOutManager*) instance;

// reset manager
+ (void) reset;
+ (void) chooseDisplay;

@end
