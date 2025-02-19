//
//  addAlarmVC.m
//  Alerty
//
//  Created by moni on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZopierCallVW.h"
//#import "AlertySettingsMgr.h"
//#import "AlertyAppDelegate.h"
#import "AlertyAppDelegate.h"
#import <Alerty-Swift.h>


@interface ZopierCallVW ()


@property (weak, nonatomic) IBOutlet UIButton *callHangupBtn;
@property (weak, nonatomic) IBOutlet UILabel *callingNumber;


@end

@implementation ZopierCallVW

#pragma mark - Overrides


- (void)viewDidLoad {
    [super viewDidLoad];
    _callingNumber.text = currentNo;
    [_callHangupBtn setTitle:@"Hang Up" forState:UIControlStateNormal];

}

-(void)startCall
{
    
    [_callHangupBtn setTitle:@"Hang Up" forState:UIControlStateNormal];

}

-(void)endCall
{
    
    if ([[AlertyAppDelegate sharedAppDelegate].contextM isInCall]== YES) {
//        [_callHangupBtn setTitle:@"Dail" forState:UIControlStateNormal];
        [[AlertyAppDelegate sharedAppDelegate].contextM hangupCall];
    }
    
    [self dismissScreen];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}




- (IBAction)HangupBtn:(UIButton *)sender {
    if ([_callHangupBtn.titleLabel.text isEqual: @"Dail"]) {
        [self startCall];
    }
    else {
        [self endCall];
    }
}

- (IBAction)cancelbtn:(UIButton *)sender {
    if ([[AlertyAppDelegate sharedAppDelegate].contextM isInCall]== YES) {
//        [_callHangupBtn setTitle:@"Dail" forState:UIControlStateNormal];
        [[AlertyAppDelegate sharedAppDelegate].contextM hangupCall];
    }

        [self dismissScreen];
}


- (void)dismissScreen {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
