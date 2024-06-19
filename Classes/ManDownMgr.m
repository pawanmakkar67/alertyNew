//
//  ManDownMgr.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManDownMgr.h"
#import "NSHelpers.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"

@interface ManDownMgr()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) CMAcceleration old;
@property (nonatomic, assign) double tilt;
@property (nonatomic, assign) NSInteger tiltCounter;
@property (assign, nonatomic) BOOL manDownRunning;

@end

@implementation ManDownMgr

- (id)initWithDelegate:(id<ManDownMgrDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.tilt = 1.0;
        self.tiltCounter = 0;
    }
    return self;
}

- (void) startManDown {
	if ([self isRunning]) return;
	
	self.motionManager = [[CMMotionManager alloc] init];
	
	if (!_motionManager.accelerometerAvailable || (![AlertySettingsMgr hasManDownMgr] && ![AlertySettingsMgr hasPreactivation])) {
		self.motionManager = nil;
		return;
	}
	
	_motionManager.accelerometerUpdateInterval = kMDMAccelerometerUpdateInterval;
	self.manDownRunning = YES;
	
	cmdlogtext(@"starting man down manager..");
	
	NSOperationQueue *motionQueue = [[NSOperationQueue alloc] init];
	[_motionManager startAccelerometerUpdatesToQueue:motionQueue withHandler:^(CMAccelerometerData *data, NSError *error) {
		if (!self.manDownRunning)  {
			cmdlogtext(@"stopping man down manager..");
			[self.motionManager stopAccelerometerUpdates];
			self.motionManager = nil;
			return;
		}
		
		CMAcceleration acc = data.acceleration;
		double x = (self.old.x - acc.x) * (self.old.x - acc.x);
		double y = (self.old.y - acc.y) * (self.old.y - acc.y);
		double z = (self.old.z - acc.z) * (self.old.z - acc.z);
		self.old = data.acceleration;
		
		double _power = x + y + z;
        self.tilt = 0.9 * self.tilt + 0.1 * fabs(acc.y);
        
        NSLog(@"md %f %f", self.tilt, fabs(acc.y));
        
        if (!DataManager.sharedDataManager.sos) {
            @synchronized(self) {
                if (_power >= [AlertySettingsMgr manDownLevel] && [self.delegate respondsToSelector:@selector(didDetectManDown)]) {
                    [self performSelectorOnMainThread:@selector(callDelegateOnMainThread) withObject:nil waitUntilDone:NO];
                }
                
                if (AlertySettingsMgr.tiltEnabled) {
                    
                    NSInteger tiltValue = AlertySettingsMgr.tiltValue;
                    double level = 0.3826;
                    if (tiltValue == 1) level = 0.7071;
                    if (tiltValue == 2) level = 0.9238;
                    if (self.tilt < level) {
                        if (self.tiltCounter <= 80) {
                            self.tiltCounter++;
                        }
                        if (self.tiltCounter == 80) {
                            [self performSelectorOnMainThread:@selector(callDelegateOnMainThread) withObject:nil waitUntilDone:NO];
                        }
                        //UIImpactFeedbackGenerator* generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
                        //[generator impactOccurred];
                        //UINotificationFeedbackGenerator* generator = [[UINotificationFeedbackGenerator alloc] init];
                        //[generator notificationOccurred:UINotificationFeedbackTypeError];
                        //let generator = UIImpactFeedbackGenerator(style: .heavy)
                        //generator.impactOccurred()
                        //AudioServicesPlaySystemSound(1520);
                        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                    } else {
                        self.tiltCounter = 0;
                    }
                }
            }
		}
	}];
}

- (void) startManDownTest {
	if ([self isRunning]) return;
	
	self.motionManager = [[CMMotionManager alloc] init];
	
	if (!_motionManager.accelerometerAvailable) {
		self.motionManager = nil;
		return;
	}
	
	_motionManager.accelerometerUpdateInterval = kMDMAccelerometerUpdateInterval;
	self.manDownRunning = YES;
	
	cmdlogtext(@"starting man down manager..");
	
	NSOperationQueue *motionQueue = [[NSOperationQueue alloc] init];
	[_motionManager startAccelerometerUpdatesToQueue:motionQueue withHandler:^(CMAccelerometerData *data, NSError *error) {
		if (!self.manDownRunning)  {
			cmdlogtext(@"stopping man down manager..");
			[self.motionManager stopAccelerometerUpdates];
			self.motionManager = nil;
			return;
		}
		
		CMAcceleration acc = data.acceleration;
		double x = (self.old.x - acc.x) * (self.old.x - acc.x);
		double y = (self.old.y - acc.y) * (self.old.y - acc.y);
		double z = (self.old.z - acc.z) * (self.old.z - acc.z);
		self.old = data.acceleration;
		
		double _power = x + y + z;
		//NSString* s = [NSString stringWithFormat:@"%f", _power];
		//NSLog(@"%@", s);
		
		@synchronized(self) {
			if (_power >= [AlertySettingsMgr manDownLevel] && [self.delegate respondsToSelector:@selector(didDetectManDown)]) {
				[self performSelectorOnMainThread:@selector(callDelegateOnMainThread) withObject:nil waitUntilDone:NO];
			}
		}
	}];
}

- (void) callDelegateOnMainThread {
	[self.delegate didDetectManDown];
}

- (void) stopManDown {
	self.manDownRunning = NO;
}

- (BOOL) isRunning {
	return self.manDownRunning;
}

@end
