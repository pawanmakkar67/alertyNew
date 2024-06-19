//
//  SignInViewController.h
//  Koponyeg
//
//  Created by Mekom Ltd. on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "BaseViewController.h"
#import "GWCall.h"

@interface SignInViewController : BaseViewController

// enterprise properties

@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, assign) BOOL businessLogin;
@property (nonatomic, assign) BOOL personalLogin;

@end
