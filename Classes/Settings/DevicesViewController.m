//
//  DevicesViewController.m
//  azonositas
//
//  Created by Mekom Ltd. on 18/12/14.
//  Copyright (c) 2014 Mekom Ltd. All rights reserved.
//

#import "DevicesViewController.h"
#import "WifiApInfoViewController.h"
#import "AlertySettingsMgr.h"
#import "MeasuredBeacon.h"
#import "AlertyAppDelegate.h"
#import "NSExtensions.h"
@import Proximiio;

@interface DevicesViewController () <UITextFieldDelegate, ProximiioDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<ProximiioIBeacon*>* beacons;
//@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) CLBeaconRegion* region;
@property (strong, nonatomic) UILabel* header;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITextField *agingTextField;

@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = NSLocalizedString(@"Beacons", @"");
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	self.beacons = [[NSMutableArray alloc] init];
    
    self.header = [[UILabel alloc] init];
    self.header.backgroundColor = [UIColor clearColor];
    self.header.text = [NSLocalizedString(@"Select a beacon", @"") uppercaseString];
    self.header.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
    self.header.font = [UIFont systemFontOfSize:14];
    self.header.frame = CGRectMake(15, 10, 300, 27);
    self.header.numberOfLines = 1;
	
	// This location manager will be used to demonstrate how to range beacons.
	//self.locationManager = [[CLLocationManager alloc] init];
	//self.locationManager.delegate = self;
	
	//NSString* bt = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    NSString* bt = @"FDA50693-A4E2-4FB1-AFCF-C6EB07647825";
    NSString* kontaktio = @"F7826DA6-4FA2-4E98-8024-BC5B71E0893E";

	//NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:bt];
	//self.region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
    
    [Proximiio.sharedInstance addCustomiBeaconUUID:bt];
    
    //Kontakt.io's standard beacon UUID
    [[Proximiio sharedInstance] addCustomiBeaconUUID:@"F7826DA6-4FA2-4E98-8024-BC5B71E0893E"];
    
    [Proximiio.sharedInstance addCustomiBeaconUUID:kontaktio];
    [Proximiio.sharedInstance enable];
    
    self.agingTextField.text = [NSString stringWithFormat:@"%.0f", 100.0 * [AlertySettingsMgr aging]];
}

- (void) closePressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.beacons = [[NSMutableArray alloc] init];
    [self.tableView reloadData];

    Proximiio.sharedInstance.delegate = self;
    [Proximiio.sharedInstance resetAndRefresh];
    [Proximiio.sharedInstance startUpdating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	//[self.locationManager stopRangingBeaconsInRegion:self.region];
    [Proximiio.sharedInstance stopUpdating];
    Proximiio.sharedInstance.delegate = AlertyAppDelegate.sharedAppDelegate;
    [AlertyAppDelegate.sharedAppDelegate startSignificantLocationService];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

#pragma mark - IBActions

- (IBAction)backClicked:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.beacons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float padding = 16;
    return self.header.frame.size.height + padding;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.bounds.size.width, self.header.frame.size.height);
    [header addSubview:self.header];
    [self.activityIndicator setFrame:CGRectMake(tableView.bounds.size.width - 30, 5, 20, 20)];
    [header addSubview:self.activityIndicator];
    header.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellDeviceNibID = @"cellDevice";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellDeviceNibID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellDeviceNibID];
	}
	
    ProximiioIBeacon *beacon = self.beacons[indexPath.row];
    NSString* bssid = [NSString stringWithFormat:@"%d:%d", beacon.major, beacon.minor];
    NSString* title = nil;
    NSArray* wifiaps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
    for (int i=0; i<wifiaps.count; i++) {
        WifiAP* ap = [wifiaps objectAtIndex:i];
        if ([bssid compare:ap.bssid] == NSOrderedSame) {
            title = [NSString stringWithFormat:@"%@ - %@", ap.name, ap.bssid];
            break;
        }
    }
    if (!title) title = [NSString stringWithFormat:NSLocalizedString(@"Unsaved beacon - %@", @"Unsaved beacon - %@"), bssid];
    
    NSString* subtitle = [NSString stringWithFormat:NSLocalizedString(@"Distance: %.2fm", @"Distance: %.2fm"), beacon.distance];
    //NSString* subtitle = [NSString stringWithFormat:@"Distance: %.2fm (raw) %.2fm (filtered)", beacon.accuracy, mb.accuracy];
	//NSString* title = [NSString stringWithFormat:@"major: %d minor: %d távolság: %.2fm", [beacon.major intValue], [beacon.minor intValue], beacon.accuracy];
	[cell.textLabel setText:title];
	[cell.textLabel setTextColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]];
    cell.detailTextLabel.text = subtitle;
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:200.0/255.0 alpha:1.0];
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView = nil;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProximiioIBeacon *beacon = self.beacons[indexPath.row];
    NSString* bssid = [NSString stringWithFormat:@"%d:%d", beacon.major,beacon.minor];
    
    WifiApInfoViewController* apInfoViewController = [[WifiApInfoViewController alloc] init];
    apInfoViewController.wifiAp = nil;
    apInfoViewController.isNew = YES;
    apInfoViewController.beaconId = bssid;
    NSArray* wifiaps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
    for (int i=0; i<wifiaps.count; i++) {
        WifiAP* ap = [wifiaps objectAtIndex:i];
        if ([bssid compare:ap.bssid] == NSOrderedSame) {
            if ([ap.type integerValue] == kWifiAPTypeBeaconPrivate) {
                apInfoViewController.wifiAp = ap;
                apInfoViewController.isNew = NO;
                break;
            }
            return;
        }
    }
    [self.navigationController pushViewController:apInfoViewController animated:YES];
	//[self dismissViewControllerAnimated:YES completion:nil];
}

/*#pragma mark - Location manager delegate

- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region {

    for (MeasuredBeacon* bc in self.beacons) {
        bc.accuracy = 1.2 * bc.accuracy;
        if (bc.accuracy > 500) {
            [self.beacons removeObject:bc];
            break;
        }
    }
    for (NSInteger i=0; i<beacons.count; i++) {
        CLBeacon* beacon = beacons[i];
        BOOL found = NO;
        for (NSInteger j=0; j<self.beacons.count; j++) {
            MeasuredBeacon* bc = self.beacons[j];
            if (beacon.major.integerValue == bc.beacon.major.integerValue &&
                beacon.minor.integerValue == bc.beacon.minor.integerValue) {
                if (beacon.accuracy >= 0.0) {
                    bc.accuracy = (1.0 - [AlertySettingsMgr aging]) * bc.accuracy / 1.2 + [AlertySettingsMgr aging] * beacon.accuracy;
                }
                bc.beacon = beacon;
                found = YES;
                break;
            }
        }
        if (!found && beacon.accuracy >= 0.0) {
            MeasuredBeacon* mb = [[MeasuredBeacon alloc] init];
            mb.beacon = beacon;
            mb.accuracy = beacon.accuracy;
            [self.beacons addObject:mb];
        }
    }
	[self.tableView reloadData];
    
    [self.beacons sortUsingComparator:^NSComparisonResult(MeasuredBeacon*  _Nonnull mb1, MeasuredBeacon*  _Nonnull mb2) {
        if (mb1.accuracy > mb2.accuracy) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (mb1.accuracy < mb2.accuracy) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status != kCLAuthorizationStatusNotDetermined) {
		[self.locationManager startRangingBeaconsInRegion:self.region];
	}
}*/

#pragma mark UITextFieldDelegate

- (IBAction)agingChanged:(id)sender {
    NSInteger value = [self.agingTextField.text integerValue];
    [AlertySettingsMgr setAging:value/100.0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ProximiioDelegate

- (void)proximiioFoundiBeacon:(ProximiioIBeacon *)beacon {
    BOOL found = NO;
    for (ProximiioIBeacon* b in self.beacons) {
        if (beacon.minor == b.minor && beacon.major == b.major) {
            found = YES;
            break;
        }
    }
    if (!found) {
        [self.beacons addObject:beacon];
    }
    [self.tableView reloadData];
}

- (void)proximiioLostiBeacon:(ProximiioIBeacon *)beacon {
    [self.beacons removeObject:beacon];
    [self.tableView reloadData];
}

- (void)proximiioUpdatediBeacon:(ProximiioIBeacon *)beacon {
    [self.tableView reloadData];
}

- (void)proximiioFoundEddystoneBeacon:(ProximiioEddystoneBeacon *)beacon {
}

- (void)proximiioUpdatedEddystoneBeacon:(ProximiioEddystoneBeacon *)beacon {
}

- (void)proximiioLostEddystoneBeacon:(ProximiioEddystoneBeacon *)beacon {
}

@end
