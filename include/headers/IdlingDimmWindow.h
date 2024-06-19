//
//  IdlingDimmWindow.h
//
//  Created by Bence Balint on 2010.12.07..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface IdlingDimmWindow : UIWindow
{
	NSTimer *_idleTimer;
	CGFloat _dimm;
	NSTimeInterval _batteryIdlingTime;
	NSTimeInterval _chargerIdlingTime;
	BOOL _dimmBySwipe;
	UIInterfaceOrientation _dimmOrinetation;
	CGPoint _swipeStart;
}

@property (nonatomic,retain) IBOutlet UIView *dimmView;
@property (readwrite,assign) CGFloat dimm;
@property (readwrite,assign) NSTimeInterval batteryIdlingTime;
@property (readwrite,assign) NSTimeInterval chargerIdlingTime;
@property (readwrite,assign) BOOL dimmBySwipe;
@property (readwrite,assign) UIInterfaceOrientation dimmOrinetation;

- (BOOL) isOnCharger;
- (NSTimeInterval) currentIdlingTimeInterval;
- (void) rescheduleIdlingTimer;
- (void) setIdlingTimeForBattery:(NSTimeInterval)battery andCharger:(NSTimeInterval)charger;

@end
