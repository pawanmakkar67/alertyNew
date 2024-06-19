//
//  PermissionsViewController.m
//  Alerty
//
//  Created by Viking on 2017. 03. 24..
//
//

#import "PermissionsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AlertyAppDelegate.h"
#import "AlertySettingsMgr.h"
#import "TutorialViewController.h"
@import AddressBook;

@interface PermissionsViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation PermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationItem.title = [NSLocalizedString(@"Permissions", @"Permissions") uppercaseString];

    self.descriptionLabel.text = [self.descriptionLabel.text stringByReplacingOccurrencesOfString:@"Alerty" withString:NSLocalizedStringFromTable(@"Alerty", @"Target", @"")];

    UIBarButtonItem *prevBtn =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;

    self.okButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.okButton.layer.cornerRadius = 4.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (IBAction)okPressed:(id)sender {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [self.locationManager requestAlwaysAuthorization];
}

- (void) closePressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) askForCameraPermission {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self askForSpeechRecognizerPermission];
        }];
    }];
}
- (void) askForSpeechRecognizerPermission {
    if (@available(iOS 10, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus granted) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self askForMicrophonePermission];
            }];
        }];
    } else {
        [self askForMicrophonePermission];
    }
}

- (void) askForMicrophonePermission {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [DataManager.sharedDataManager getMaps];
            [[AlertyAppDelegate sharedAppDelegate] registerNotifications];
            [[AlertyAppDelegate sharedAppDelegate] performSelector:@selector(networkChanged:) withObject:nil afterDelay:60.0];
            [[AlertyAppDelegate sharedAppDelegate].mainController dismissViewControllerAnimated:YES completion:^{
                if (![AlertySettingsMgr tutorialShown]) {
                    [AlertySettingsMgr setTutorialShown:YES];
                    TutorialViewController* tvc = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
                    tvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    tvc.completion = ^{
                        [[AlertyAppDelegate sharedAppDelegate].mainController dismissViewControllerAnimated:YES completion:nil];
                    };
                    [[AlertyAppDelegate sharedAppDelegate].mainController presentViewController:tvc animated:YES completion:nil];
                }
            }];
        }];
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    /*if (status != kCLAuthorizationStatusNotDetermined) {
        [self.locationManager stopUpdatingLocation];
    }*/

    if (status == kCLAuthorizationStatusNotDetermined) return;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self askForCameraPermission];
            }];
        });
    } else {
        [self askForCameraPermission];
    }
}

@end
