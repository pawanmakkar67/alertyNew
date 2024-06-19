//
//  BaseViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "NSExtensions.h"
#import "AlertyAppDelegate.h"

@interface BaseViewController ()
@property (nonatomic, strong) TouchView *touchView;
- (void) showTouchView:(BOOL)show;
@end

@implementation BaseViewController

@synthesize touchView = _touchView;
@synthesize waitView = _waitView;

#pragma mark - Overrides

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		//self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:31.0/255.0 alpha:1.0];
        self.navigationController.navigationBar.barTintColor = REDESIGN_COLOR_NAVIGATIONBAR;
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]}];
	} else {
		self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	}
}



/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}*/

#pragma mark - Private methods

- (void) showTouchView:(BOOL)show {
	@synchronized(self) {
		if (show) {
			if (!_touchView) {
				self.touchView = [[TouchView alloc] initWithFrame:self.view.bounds];
				[_touchView setDelegate:self];
				[self.view addSubview:_touchView];
			}
			[_touchView setHidden:NO];
			[self.view bringSubviewToFront:_touchView];
		}
		else {
			[_touchView setHidden:YES];
		}
	}
}

#pragma mark - TapViewDelegate

- (void) didTouchView:(TouchView*)view {
	// hide touchview, cancel all bubbleviews
	[self showTouchView:NO];
}

#pragma mark - Public methods

#pragma mark - WaitView

// waitview originally by Bence Balint
- (void) showWaitView:(BOOL)show animated:(BOOL)animated {
	@synchronized(self) {
		if (!!_waitView.alpha == show) return;
		if (show) {
			// show WaitView
			if (!_waitView) {
				self.waitView = [NSBundle loadNibNamed:@"WaitView" firstClass:[WaitView class]];
			}
			_waitView.autoresizingMask = UIAutoresizeMask;
			_waitView.frame = self.view.bounds;
			[self.view addSubview:_waitView];
			if (animated) {
				_waitView.alpha = 0.0;
				[UIView animateWithDuration:(animated ? 0.3 : 0.0)
									  delay:0.2
									options:UIViewAnimationOptionBeginFromCurrentState
								 animations:^{
									 _waitView.alpha = 1.0;
								 }
								 completion:nil
				 ];
			}
			else {
				_waitView.alpha = 1.0;
			}
//			if (![_waitView.indicatorView isAnimating]) {
//				[_waitView.indicatorView startAnimating];
//			}
		}
		else {
			// hide WaitView
			if (animated) {
				_waitView.alpha = 1.0;
				[UIView animateWithDuration:(animated ? 0.3 : 0.0)
									  delay:0.0
									options:UIViewAnimationOptionBeginFromCurrentState
								 animations:^{
									 _waitView.alpha = 0.0;
								 }
								 completion:nil
				 ];
			}
			else {
				_waitView.alpha = 0.0;
			}
//			if ([_waitView.indicatorView isAnimating]) {
//				[_waitView.indicatorView stopAnimating];
//			}
		}
	}
}

- (void) showAlert:(NSString*)caption :(NSString*)message :(NSString *)cancelButton {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:caption message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelButton) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleCancel handler:nil]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end
