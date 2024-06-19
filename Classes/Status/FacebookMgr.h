//
//  FacebookMgr.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookMgr : NSObject <FBSessionDelegate, FBRequestDelegate>

@property (nonatomic, retain) Facebook *facebook;

+ (FacebookMgr *)sharedFacebookMgr;

- (void) restoreSession;
- (void) login;
- (void) logout;
- (NSString*) accessToken;

- (void) sendStatusUpdate:(NSString *)update;
- (void) sendStatusUpdate:(NSString *)update imageUrl:(NSString *)imageUrl linkUrl:(NSString *)linkUrl;

@end
