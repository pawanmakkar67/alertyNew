//
//  VerifyPhoneViewController.h
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GWCall.h"

@interface VerifyPhoneViewController : BaseViewController 

@property (nonatomic, strong) NSString* phoneNr;
@property (nonatomic, assign) BOOL showPermission;

@end
