//
//  FunctionsViewController.m
//  Alerty
//
//  Created by Viking on 2017. 03. 20..
//
//

#import "FunctionsViewController.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"
#import "TimerViewController.h"
#import "MotionViewController.h"
#import "addAlarmVC.h"
#import "LAlarmConfirmVC.h"

@interface FunctionsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *manDownButton;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UIButton *followMeButton;
@property (weak, nonatomic) IBOutlet UIButton *homeAlarmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followMeBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manDownBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timerAlarmBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenLockBottomConstraint;
@end

@implementation FunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.accessibilityViewIsModal = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.manDownButton.selected = [AlertySettingsMgr hasManDownMgr];
    NSDate* date = [AlertySettingsMgr timer];
    self.timerButton.selected = (date && [date timeIntervalSinceNow] > 0);
    self.followMeButton.selected = [DataManager sharedDataManager].followMe;
    NSDate* homeDate = [AlertySettingsMgr homeTimer];
    self.homeAlarmButton.selected = (homeDate);

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 480) {
        self.followMeBottomConstraint.constant = -6;
        self.timerAlarmBottomConstraint.constant = -6;
        self.screenLockBottomConstraint.constant = -6;
        self.manDownBottomConstraint.constant = -6;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events
- (IBAction)backgroundTapped:(UITapGestureRecognizer *)sender {
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
}

- (IBAction)followMePressed:(id)sender {
    [[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController getInviteURLShortened];
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
}

- (IBAction)manDownPressed:(id)sender {
    BOOL manDownEnabled = !self.manDownButton.selected;
    self.manDownButton.selected = manDownEnabled;
    if (manDownEnabled) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Man down", @"") message:NSLocalizedString(@"Man down alert", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Adjust", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // go to settings
            MotionViewController* motionViewController = [[MotionViewController alloc] init];
            motionViewController.title = NSLocalizedString(@"Sensitivity", @"");
            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:motionViewController];
            nvc.navigationBarHidden = NO;
            nvc.navigationBar.translucent = NO;
            [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AlertySettingsMgr setManDownManager:YES];
            [[AlertyAppDelegate sharedAppDelegate] startManDown];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertySettingsMgr setManDownManager:manDownEnabled];
        [[AlertyAppDelegate sharedAppDelegate] stopManDown];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:manDownEnabled];
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
}

- (IBAction)timerAlarmPressed:(id)sender {
    TimerViewController* tvc = [[TimerViewController alloc] initWithNibName:@"TimerViewController" bundle:nil];
    tvc.title = [NSLocalizedString(@"Timer alarm", @"") uppercaseString];
    //[self.navigationController pushViewController:tvc animated:YES];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    nvc.navigationBarHidden = NO;
    nvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
}

- (IBAction)homeAlarmPressed:(id)sender {
    addAlarmVC* tvc = [[addAlarmVC alloc] initWithNibName:@"addAlarmVC" bundle:nil];
    tvc.title = [NSLocalizedString(@"Home alarm", @"") uppercaseString];
    //[self.navigationController pushViewController:tvc animated:YES];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    nvc.navigationBarHidden = NO;
    nvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
}

- (IBAction)LarmPressed:(id)sender {
    LAlarmConfirmVC* tvc = [[LAlarmConfirmVC alloc] initWithNibName:@"LAlarmConfirmVC" bundle:nil];
    tvc.title = @"";
    //[self.navigationController pushViewController:tvc animated:YES];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    nvc.navigationBarHidden = NO;
    nvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:nvc animated:YES completion:nil];
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
}

- (IBAction)lockScreenPressed:(id)sender {
    [[AlertyAppDelegate sharedAppDelegate].mainController showLockView:YES activeText:@""];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [[AlertyAppDelegate sharedAppDelegate].mainController hideFunctions];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

@end
