//
//  ManDownMgr.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CMMotionManager.h>

@protocol ManDownMgrDelegate <NSObject>
- (void) didDetectManDown;
@end

@interface ManDownMgr : NSObject

@property (nonatomic, weak) id<ManDownMgrDelegate> delegate;

- (id)initWithDelegate:(id<ManDownMgrDelegate>)delegate;
- (void) startManDown;
- (void) startManDownTest;
- (void) stopManDown;
- (BOOL) isRunning;

@end
