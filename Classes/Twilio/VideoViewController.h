//
//  VideoViewController.h
//  ObjCVideoQuickstart
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoViewController : UIViewController

@property (strong, nonatomic) NSString* recipient;
@property (strong, nonatomic) NSString* phoneNr;
@property (strong, nonatomic) NSString* roomName;
@property (strong, nonatomic) NSString* token;
@property (assign, nonatomic) BOOL startIncomingCall;
@property (strong, nonatomic) NSString* alertUserId;

- (void)callRejected;
- (void)callEnded;

@end
