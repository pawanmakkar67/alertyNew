//
//  MotionViewController.m
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MotionViewController.h"
#import "AlertyViewController.h"
#import "AlertyAppDelegate.h"
#import "MainController.h" 
#import "UIDeviceAdditions.h"
#import "AlertySettingsMgr.h"
#import <QuartzCore/QuartzCore.h>
#import "NSExtensions.h"


@interface MotionViewController () <ManDownMgrDelegate>

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (nonatomic, strong) NSDate    *lastTimePressed;
@property (strong, nonatomic) IBOutlet UISlider *motionSlider;
@property (nonatomic, strong) ManDownMgr *manDownMgr;

@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSTimer* timeoutTimer;
@property (weak, nonatomic) IBOutlet UISwitch *tiltAngleSwitch;
@property (weak, nonatomic) IBOutlet UISlider *tiltAngleSlider;

@end


@implementation MotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height==568) {
		[self.motionSlider setMaximumValue:500.0];
	}

	[self.motionSlider setValue:[AlertySettingsMgr manDownLevel]];

    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"trick" ofType: @"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	
	_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    _isPlaying = NO;
	
    [self.navigationItem setTitle:[NSLocalizedString(@"Motion sensitivity", @"") uppercaseString]];

    self.testButton.layer.cornerRadius = 4.0;
    self.testButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    
    self.tiltAngleSwitch.on = AlertySettingsMgr.tiltEnabled;
    self.tiltAngleSlider.enabled = AlertySettingsMgr.tiltEnabled;
    self.tiltAngleSlider.value = AlertySettingsMgr.tiltValue;
}

- (void) closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    [_audioPlayer play];
}

- (void) viewDidDisappear:(BOOL) animated {
    [self.timeoutTimer invalidate];
    [super viewDidDisappear:animated];
}

#pragma mark -  IBActions

-(IBAction) closeHeadsetSettingsView:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)levelChanged:(id)sender {
	double level = self.motionSlider.value;
	[AlertySettingsMgr setManDownLevel:level];
}

- (IBAction) testHeadset:(id)sender {

    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(cancelHeadsetTest:) userInfo:self repeats:NO];
	
	/*self.headsetInstrTitle.text = NSLocalizedString(@"Test mode!", @"");
	self.headsetInstr.text = NSLocalizedString(@"Shake your phone to test the motion sensitivity", @"");
	self.headsetInstrButton.text = NSLocalizedString(@"Cancel", @"");*/

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Test mode!", @"")
                                                                   message:NSLocalizedString(@"Shake your phone to test the motion sensitivity", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"")
                                                 style:UIAlertActionStyleCancel
                                               handler:^(UIAlertAction * _Nonnull action) {
        [self resetHeadsetSettings];
        [self showAlert:NSLocalizedString(@"UnsuccessfulTest", @"")
                                    :NSLocalizedString(@"Press the test button again if you want to test motion sensitivity.", @"")
                                    :@"OK"];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
	[[AlertyAppDelegate sharedAppDelegate] stopManDownForTest];
	
	if( !self.manDownMgr ) {
		self.manDownMgr = [[ManDownMgr alloc] initWithDelegate:self];
	}
	[self.manDownMgr startManDownTest];
}

- (IBAction)tiltSwitchChanged:(id)sender {
    self.tiltAngleSlider.enabled = self.tiltAngleSwitch.isOn;
    [AlertySettingsMgr setTiltEnabled:self.tiltAngleSwitch.isOn];
}

- (IBAction)tiltSliderChanged:(id)sender {
    if (self.tiltAngleSlider.value < 0.5) {
        [self.tiltAngleSlider setValue:0.0f animated:YES];
        [AlertySettingsMgr setTiltValue:0];
    } else if (self.tiltAngleSlider.value >= 0.5 && self.tiltAngleSlider.value <= 1.5) {
        [self.tiltAngleSlider setValue:1.0f animated:YES];
        [AlertySettingsMgr setTiltValue:1];
    } else if (self.tiltAngleSlider.value > 1.5) {
        [self.tiltAngleSlider setValue:2.0f animated:YES];
        [AlertySettingsMgr setTiltValue:2];
    }
}


#pragma mark - Headset functions

- (void) resetHeadsetSettings {
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
	[self.manDownMgr stopManDown];
	self.manDownMgr = nil;
	[[AlertyAppDelegate sharedAppDelegate] startManDown];
}

- (void) cancelHeadsetTest:(id)sender {
    [self resetHeadsetSettings];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAlert:NSLocalizedString(@"UnsuccessfulTest", @"")
                                    :NSLocalizedString(@"Press the test button again if you want to test motion sensitivity.", @"")
                                    :@"OK"];
    }];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ManDownMgrDelegate

- (void) didDetectManDown {

    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
    [self.manDownMgr stopManDown];
    self.manDownMgr = nil;

    // vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

    [self dismissViewControllerAnimated:YES completion:^{
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"The test was successful!", @"")
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            [self resetHeadsetSettings];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

@end
