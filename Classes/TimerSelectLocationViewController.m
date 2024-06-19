//
//  TimerSelectLocationViewController.m
//  Alerty
//
//  Created by Viking on 2018. 02. 14..
//

#import "TimerSelectLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HoshiTextField.h"
#import "AlertyAppDelegate.h"
#import "AlertySettingsMgr.h"

@import Proximiio;
@import ProximiioMapbox;
@import Mapbox;

@interface TimerSelectLocationViewController () <UITextFieldDelegate, MGLMapViewDelegate>

@property (strong, nonatomic) CLGeocoder* geocoder;
@property (weak, nonatomic) IBOutlet HoshiTextField *location;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong) MGLMapView* mapView;
@property (nonatomic, strong) ProximiioMapbox* mapBoxHelper;
@property (weak, nonatomic) IBOutlet UIView *mapContainer;

@end

@implementation TimerSelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.geocoder = [[CLGeocoder alloc] init];
    self.saveButton.layer.cornerRadius = 4.0;
    self.saveButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.location.text = AlertySettingsMgr.timerAddress;

    self.mapView = [[MGLMapView alloc] initWithFrame:self.mapContainer.bounds];
    self.mapView.delegate = self;
    [self.mapContainer insertSubview:self.mapView atIndex:0];
    
    if (self.mapView) {
        ProximiioMapboxConfiguration* configuration = [[ProximiioMapboxConfiguration alloc] initWithToken:Proximiio.sharedInstance.token];
        configuration.showUserLocation = NO;
        self.mapBoxHelper = [[ProximiioMapbox alloc] init];
        [self.mapBoxHelper setupWithMapView:self.mapView configuration:configuration];
        self.mapBoxHelper.followingUser = NO;
        [self.mapBoxHelper initialize:^(enum ProximiioMapboxAuthorizationResult result) {
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.mapView.frame = self.mapContainer.bounds;
}

#pragma mark - MGLMapViewDelegate

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
    
    NSNumber* latitude = AlertySettingsMgr.timerLatitude;
    NSNumber* longitude = AlertySettingsMgr.timerLongitude;
    if (latitude && longitude) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue) zoomLevel:19.0 animated:YES];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            NSArray<MGLStyleLayer*>* layers = self.mapView.style.layers;
            if (layers.count) {
                [timer invalidate];
                for (MGLStyleLayer* layer in layers) {
                    layer.visible = true;
                }
            }
        }];
    }];
}

- (IBAction)updatePressed:(id)sender {
    [self.activityIndicator startAnimating];
    CLCircularRegion* region = [[CLCircularRegion alloc] initWithCenter:self.mapView.userLocation.coordinate radius:1000.0 identifier:@"1"];
    [self.geocoder geocodeAddressString:self.location.text inRegion:region completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [self.activityIndicator stopAnimating];
        CLPlacemark* placemark = placemarks.firstObject;
        if (placemark) {
            [self.mapView setCenterCoordinate:placemark.location.coordinate animated:YES];
        }
    }];
}

- (IBAction)showMyLocationPressed:(id)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (IBAction)savePressed:(id)sender {
    [self.delegate locationSelected:self.location.text latitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self updatePressed:nil];
    return NO;
}

@end
