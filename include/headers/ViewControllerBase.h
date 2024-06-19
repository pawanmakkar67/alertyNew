//
//  ViewControllerBase.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitView.h"
#import "DimmView.h"


extern NSString *const ApplicationIsActiveAgainEvent;


@interface ViewControllerBase : UIViewController <UIScrollViewDelegate>
{
	WaitView *_waitView;
	DimmView *_dimmView;
	BOOL _dimmBackgroundOnEditing;
}

@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;					// UIScrollView for scrollable content
@property (nonatomic,retain) IBOutlet UIView *resizingView;						// UIView for resizable content (automatically set to scrollView in viewDidLoad)
@property (nonatomic,retain) IBOutlet UIButton *dismissButton;
@property (readwrite,retain) WaitView *waitView;
@property (readwrite,retain) DimmView *dimmView;
@property (readwrite,assign) BOOL dimmBackgroundOnEditing;

// dismiss action to override
- (IBAction)dismissButtonPressed:(id)sender;

// methods to override
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation shouldScrollToTop:(BOOL)scrollToTop;
- (void) initInternals;
- (CGRect) activeRectForScrolling;
- (BOOL) shouldShowDimmView;
- (NSArray*) viewsAboveDimm:(NSArray*)input;

// helper methods
- (BOOL) showWaitView:(BOOL)show animated:(BOOL)animated;
- (BOOL) showDimmView:(BOOL)show animated:(BOOL)animated;
- (BOOL) showDimmView:(BOOL)show animated:(BOOL)animated view:(UIView*)view aboves:(NSArray*)aboves;
- (BOOL) showDimmView:(BOOL)show animated:(BOOL)animated view:(UIView*)view belows:(NSArray*)belows;
- (BOOL) showDimmView:(BOOL)show animated:(BOOL)animated view:(UIView*)view relatives:(NSArray*)relatives below:(BOOL)below;
- (void) resizeContentForHeight:(CGFloat)height orientation:(UIInterfaceOrientation)interfaceOrientation;

// UI adjustment methods
- (void) adjustUIElements:(UIInterfaceOrientation)interfaceOrientation;
- (void) adjustUIElements:(UIInterfaceOrientation)interfaceOrientation dontResizeContentHeight:(BOOL)dontResize;	// auxiliary method to not resize ScrollView's content
- (void) adjustUIValues:(UIInterfaceOrientation)interfaceOrientation;

// notification methods to override
- (void) applicationIsActiveAgain:(NSNotification*)notification;

@end


@interface ViewControllerBase ()
- (void) initInternals;
// internal method to call
- (void) moveToActiveRectInternal:(NSValue*)rect;
@end
