//
//  BaseViewController.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitView.h"
#import "TouchView.h"

@interface BaseViewController : UIViewController <TouchViewDelegate>

@property (nonatomic, strong) WaitView *waitView;

- (void) showWaitView:(BOOL)show animated:(BOOL)animated;

- (void) showAlert:(NSString*)caption :(NSString*)message :(NSString *)cancelButton;

@end
