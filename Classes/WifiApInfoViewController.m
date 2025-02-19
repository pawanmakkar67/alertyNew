//
//  WifiApInfoViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WifiApInfoViewController.h"
#import "config.h"
#import "WifiApMgr.h"
#import "NSExtensions.h"
#import "AlertySettingsMgr.h"
#import "GeoAddress.h"

#import "HoshiTextField.h"
@import Proximiio;
@import ProximiioMapbox;
@import Mapbox;

@interface WifiApInfoViewController () <MGLMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet HoshiTextField *bssidTextField;
@property (weak, nonatomic) IBOutlet HoshiTextField *locationTextField;
@property (weak, nonatomic) IBOutlet HoshiTextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIView *mapContainer;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, assign) BOOL isDelete;
@property (nonatomic, strong) NSURLConnection *wifiAddRequest;

@property (strong, nonatomic) GeoAddress* geoAddress;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property (nonatomic, strong) MGLMapView* mapView;
@property (nonatomic, strong) ProximiioMapbox* mapBoxHelper;

@end

@implementation WifiApInfoViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    addButton.enabled = NO;
	[self.navigationItem setRightBarButtonItem:addButton];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
    BOOL isBeacon = self.beaconId.length || [self.wifiAp.type integerValue] == kWifiAPTypeBeaconPrivate || [self.wifiAp.type integerValue] == kWifiAPTypeBeaconCompany;
    self.bssidTextField.placeholder = isBeacon ? @"Beacon" : @"BSSID";
    
    self.locationTextField.placeholder = NSLocalizedString(@"Location", @"");
    
    self.addressTextField.placeholder = NSLocalizedString(@"Address", @"Address");
    
    //NSURL* styleURL = [NSURL URLWithString:@"https://portal.getalerty.com/style2.json"];
    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    //self.mapView.tintColor = [UIColor colorNamed:@"color_separator"];
    [self.mapContainer insertSubview:self.mapView atIndex:0];
    
    if (self.mapView) {
        ProximiioMapboxConfiguration* configuration = [[ProximiioMapboxConfiguration alloc] initWithToken:Proximiio.sharedInstance.token];
        configuration.showUserLocation = NO;
        self.mapBoxHelper = [[ProximiioMapbox alloc] init];
        [self.mapBoxHelper setupWithMapView:self.mapView configuration:configuration];
        self.mapBoxHelper.followingUser = NO;
        [self.mapBoxHelper initialize:^(enum ProximiioMapboxAuthorizationResult result) {
            //[self.mapBoxHelper floorAt:1];
            //[self.mapView setStyleURL:styleURL];
        }];
    }
	
	// reload wifi fo
	[self reloadWifiInfo];
	//self.wifiApDescTextField.delegate = self;
	
	self.bssidTextField.enabled = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.mapContainer.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) closePressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadWifiInfo {
	// fetch bssid of wifi
	NSString *bssid = [WifiApMgr fetchBSSIDInfo];
	NSString *ssid = [WifiApMgr fetchSSIDInfo];
	
	if( self.isNew ) {
		self.wifiAp = [[AlertyDBMgr sharedAlertyDBMgr] temporaryWifiAP];
		
        if (self.beaconId) {
            self.wifiAp.bssid = self.beaconId;
            self.wifiAp.name = nil; //@"";//self.beaconId;
        } else {
            // set bssid
            self.wifiAp.bssid = bssid != nil ? bssid : @"x";
            self.wifiAp.name = ssid != nil ? ssid : @"";
        }
        
		// get location
		[self.activityIndicatorView startAnimating];
		self.view.alpha = 0.5f;
		self.view.opaque = NO;
		self.view.userInteractionEnabled = NO;
    } else {
        self.addressTextField.text = self.wifiAp.info;
        //self.addressLabel.text = self.wifiAp.info;
    }
	
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //  100;
    [self.locationManager startUpdatingLocation];

    [DataManager sharedDataManager].chosenLocation = CLLocationCoordinate2DMake([self.wifiAp.locationLat doubleValue], [self.wifiAp.locationLon doubleValue]);
    
    self.locationTextField.text = self.wifiAp.name;
    //self.wifiApDescTextField.text = self.wifiAp.name;
    self.navigationItem.rightBarButtonItem.enabled = (self.wifiAp.name.length > 0);
    [self.mapView setCenterCoordinate:[DataManager sharedDataManager].chosenLocation zoomLevel:14.0 animated:YES];
    
	//[self.bssidLabel setText:self.wifiAp.bssid];
    self.bssidTextField.text = self.wifiAp.bssid;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.isDelete = NO;
    if (self.wifiAp != nil && ![self.wifiAp.name isEqualToString:@""]) {
        self.navigationItem.title = self.wifiAp.name;
    }
}

#pragma mark - Button listeners

- (IBAction) closeView:(id)sender {
	[_locationManager stopUpdatingLocation];
	[self save];
}

- (IBAction) deleteWifiAp:(id)sender {
	if (!self.isNew) {
		[[AlertyDBMgr sharedAlertyDBMgr] delWifiAP:self.wifiAp];
	}
    _isDelete = YES;
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) setEditable:(id)sender {
//	_editable = !_editable;
//	self.wifiApInfoTextView.editable = _editable;
//	self.wifiApNameTextField.enabled = _editable;
//	UIBarButtonItem *btn = (UIBarButtonItem *)sender;
//	btn.title = _editable ? NSLocalizedString(@"Done", @"") : NSLocalizedString(@"Edit", @"");
//	if( _editable ) {
//		self.wifiApInfoTextView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
//		[self.wifiApNameTextField setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
//		self.apNameLabel.textColor = [UIColor whiteColor];
//		self.apDescriptionLabel.textColor = [UIColor whiteColor];
//		self.wifiApInfoTextView.textColor = [UIColor blackColor];
//		self.wifiApNameTextField.textColor = [UIColor blackColor];
//	}
//	else {
//		self.wifiApInfoTextView.backgroundColor = [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.0f];
//		[self.wifiApNameTextField setBackgroundColor:[UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.0f]];
//		self.apNameLabel.textColor = [UIColor whiteColor];
//		self.apDescriptionLabel.textColor = [UIColor whiteColor];
//		self.wifiApInfoTextView.textColor = [UIColor whiteColor];
//		self.wifiApNameTextField.textColor = [UIColor whiteColor];
//	}
}

- (void) addWifiAp:(BOOL)company {
	// fill out remaining bits of wifiap
	self.wifiAp.name = self.locationTextField.text;
	self.wifiAp.info = self.addressTextField.text;
	self.wifiAp.locationLat = [NSNumber numberWithDouble:[DataManager sharedDataManager].chosenLocation.latitude];
	self.wifiAp.locationLon = [NSNumber numberWithDouble:[DataManager sharedDataManager].chosenLocation.longitude];
    if (self.beaconId) {
        self.wifiAp.type = [NSNumber numberWithInt:company ? kWifiAPTypeBeaconCompany : kWifiAPTypeBeaconPrivate];
    } else {
        self.wifiAp.type = [NSNumber numberWithInt:company ? kWifiAPTypeCompany : kWifiAPTypeUser];
    }
	// store wifiap
	[[AlertyDBMgr sharedAlertyDBMgr] addWifiAP:self.wifiAp];
}

- (void) addWifiApToServer:(BOOL)addToCompany {
	long userId = addToCompany ? [AlertySettingsMgr userID] : -1;
	NSString *urlString = [NSString stringWithFormat:ADD_WIFI_URL, [self.wifiAp.name urlEncodedString], [self.wifiAp.info urlEncodedString], self.wifiAp.bssid, [self.wifiAp.locationLat doubleValue], [self.wifiAp.locationLon doubleValue], userId];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	self.wifiAddRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) save {
	/* why?
	for (WifiAP* wifiap in [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs]) {
		if ([[self.wifiAp bssid] isEqualToString:wifiap.bssid]) {
			[self.navigationController popViewControllerAnimated:YES];
			return;
		}
	}*/
	
	CLLocationCoordinate2D center = self.mapView.centerCoordinate;
	[DataManager sharedDataManager].chosenLocation = center;

	if (self.locationTextField.text.length > 0) {
		if (self.isNew && [AlertySettingsMgr isBusinessVersion]) {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save to private", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.wifiAp.bssid != nil && self.wifiAp.bssid.length > 0) {
                    [self addWifiAp:NO];
                    [self addWifiApToServer:NO];
                }
                [AlertySettingsMgr setIndoorLocationing:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save to company", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.wifiAp.bssid != nil && self.wifiAp.bssid.length > 0) {
                    [self addWifiAp:YES];
                    [self addWifiApToServer:YES];
                }
                [AlertySettingsMgr setIndoorLocationing:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];

			return;
		}
		if( !self.isNew ) {
			[self storeWifiAp];
			[self addWifiApToServer:NO];
		}
		else if (self.wifiAp.bssid != nil && self.wifiAp.bssid.length > 0) {
			[self addWifiAp:NO];
			[self addWifiApToServer:NO];
		}
		[AlertySettingsMgr setIndoorLocationing:YES];
        [self.navigationController popViewControllerAnimated:YES];
	}
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.wifiAddRequest = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.wifiAddRequest = nil;
    
    [Proximiio.sharedInstance resetAndRefresh];
}

- (void) storeWifiAp {
	// config wifiap
	self.wifiAp.name = self.locationTextField.text;
	self.wifiAp.info = self.addressTextField.text;
	self.wifiAp.locationLat = [NSNumber numberWithDouble:(float)[DataManager sharedDataManager].chosenLocation.latitude];
	self.wifiAp.locationLon = [NSNumber numberWithDouble:(float)[DataManager sharedDataManager].chosenLocation.longitude];
	
	// store wifiap
	[[AlertyDBMgr sharedAlertyDBMgr] saveManagedObjectContext];
}

#pragma mark locationmanager

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.isNew) {
        self.view.alpha = 1.0f;
        self.view.opaque = YES;
        self.view.userInteractionEnabled = YES;
        [self.activityIndicatorView stopAnimating];
        
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Could not find location.", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* location = locations.firstObject;
    if (location) {
        [DataManager sharedDataManager].chosenLocation = location.coordinate;
        if (self.isNew) {
            self.view.alpha = 1.0f;
            self.view.opaque = YES;
            self.view.userInteractionEnabled = YES;
            [self.activityIndicatorView stopAnimating];
            [self.mapView setCenterCoordinate:[DataManager sharedDataManager].chosenLocation zoomLevel:14.0 animated:YES];
            
            self.geoAddress = [[GeoAddress alloc] init];
            self.geoAddress.delegate = self.addressTextField;
            [self.geoAddress getGeoAddressByCoordinate:location.coordinate];
        }
        [_locationManager stopUpdatingLocation];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length = textField.text.length - range.length + string.length;
    if (length > 60) {
        return NO;
    }
    
    if (textField == self.locationTextField) {
        self.navigationItem.rightBarButtonItem.enabled = (length > 0);
    }
    return YES;
}

- (IBAction)myPositionPressed:(id)sender {
    [self.mapView setCenterCoordinate:[DataManager sharedDataManager].chosenLocation zoomLevel:14.0 animated:YES];
}

#pragma mark - MGLMapViewDelegate

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
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

@end
