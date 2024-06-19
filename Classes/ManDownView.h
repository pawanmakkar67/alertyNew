//
//  ManDownView.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 11/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ManDownView;

@protocol ManDownViewDelegate <NSObject>
@required
- (void) didFinishTimer;
- (void) didCancelTimer:(NSNumber*)isTimer;
- (void) didCancelAlarm:(NSNumber*)isAlarm;
- (void) closeManDown;
@end

@interface ManDownView : UIView

@property (nonatomic, assign) BOOL stopTimerOnCancel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) id<ManDownViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (assign, nonatomic) BOOL isTimer;
@property (assign, nonatomic) BOOL isAlarm;


- (IBAction)cancelButtonPressed:(id)sender;

+ (ManDownView*) manDownView:(BOOL)isTimer;
+ (ManDownView*) manDownViewHome:(BOOL)isAlarm;


- (void) showInView:(UIView *)view;
- (void) stopCountDown;

@end
