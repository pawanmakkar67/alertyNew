//
//  IndoorLocationingViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IndoorLocationingViewController.h"
#import "DataManager.h"
#import "config.h"
#import "WifiApMgr.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"
#import "DevicesViewController.h"
#import "NSExtensions.h"

@interface IndoorLocationingViewController()

@property (nonatomic, strong) UITableView *wifiapsTableView;
@property (nonatomic, strong) NSArray *wifiaps;
@property (nonatomic, strong) UISlider *askNetworkSwitchButton;
@property (nonatomic, strong) WifiAP* currentWifiAp;
@property (nonatomic, strong) WifiApInfoViewController *wifiApInfoViewController;

@end

@implementation IndoorLocationingViewController


#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = [NSLocalizedString(@"Indoor locationing", @"") uppercaseString];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	[self.wifiapsTableView setBackgroundView:nil];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWifiAp)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	self.askNetworkSwitchButton = [[UISlider alloc] initWithFrame:CGRectMake(300.0 - 60.0, (44.0 - 30.0) / 2.0, 60.0, 30.0)];
    [self.askNetworkSwitchButton setValue:[AlertySettingsMgr askNetwork] ? 1 : 0 animated:YES];
	[self.askNetworkSwitchButton addTarget:self action:@selector(askNetworkDidChange:) forControlEvents:UIControlEventValueChanged];
    self.askNetworkSwitchButton.tintColor = [REDESIGN_COLOR_GREEN colorWithAlphaComponent:0.6];
    self.askNetworkSwitchButton.thumbTintColor = REDESIGN_COLOR_GREEN;
    self.askNetworkSwitchButton.maximumValue = 1.0;
    self.askNetworkSwitchButton.continuous = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadWifiAps)
                                                 name:kSyncFinishedNotification object:nil];

    self.wifiapsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.wifiapsTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void) closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) startScan {
    DevicesViewController* dvc = [[DevicesViewController alloc] initWithNibName:@"DevicesViewController" bundle:nil];
    //[self presentViewController:dvc animated:YES completion:nil];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self reloadWifiAps];
	
	BOOL hasReturnedFromAdd = _wifiApInfoViewController != nil && _wifiApInfoViewController.isNew && _currentWifiAp;

	if (hasReturnedFromAdd) {
		// returns from adding a wifi ap
		/*if (![AlertySettingsMgr indoorLocVCBubble1Shown]) {
			[self showBubbleViewInView:self.view
							  withText:NSLocalizedString(@"This is the WiFi you're currently connected to. The description and position of it will be displayed in the alerts you send.", @"IndoorLocationingVC bubble")
							atPosition:CGPointMake(10,200)
						  withArrowAtX:25.0
			 ];
			[AlertySettingsMgr setIndoorLocVCBubble1Shown:YES];
		}*/
	}
	else {
		
		//int offsetX = self.view.frame.size.width - 70;
		
		// view is shown
		if (![WifiApMgr isConnectedToWifiAP]) {
			/*if (![AlertySettingsMgr indoorLocVCBubble2Shown]) {
				[self showBubbleViewInView:self.view
								  withText:NSLocalizedString(@"To use indoor positioning you must be connected to a WiFi.",@"IndoorLocationingVC bubble")
								atPosition:CGPointMake(offsetX-160,0)
							  withArrowAtX:offsetX
				 ];
				[AlertySettingsMgr setIndoorLocVCBubble2Shown:YES];
			}*/
		}
		else {
			/*if (![AlertySettingsMgr indoorLocVCBubble3Shown]) {
				[self showBubbleViewInView:self.view
								  withText:NSLocalizedString(@"To get a more accurate position when indoors, add the position of the WiFi you're currently connected to here.", @"IndoorLocationingVC bubble")
								atPosition:CGPointMake(offsetX-160,0)
							  withArrowAtX:offsetX
				 ];
				[AlertySettingsMgr setIndoorLocVCBubble3Shown:YES];
			}*/
		}
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([AlertyAppDelegate sharedAppDelegate].showIndoorPositioning) {
		[self performSelector:@selector(addWifiAp) withObject:nil afterDelay:0.1];
		[AlertyAppDelegate sharedAppDelegate].showIndoorPositioning = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AlertyAppDelegate.sharedAppDelegate startSignificantLocationService];
}

- (void) editWifiAp:(WifiAP *)wifiap {
	self.wifiApInfoViewController = [[WifiApInfoViewController alloc] init];
	self.wifiApInfoViewController.wifiAp = wifiap;
	self.wifiApInfoViewController.isNew = NO;
	[self.navigationController pushViewController:_wifiApInfoViewController animated:YES];
}

- (void)reloadWifiAps
{
	// set current wifi ap
	_currentWifiAp = [WifiApMgr currentWifiAp];
	
	BOOL connectedToWifi = [WifiApMgr isConnectedToWifiAP];
	BOOL isWifiAdded = _currentWifiAp != nil;
	BOOL addButtonEnabled = connectedToWifi ? (isWifiAdded ? NO : YES) : NO;
	
	[self.navigationItem.rightBarButtonItem setEnabled:addButtonEnabled];
	
	// reload wifiaps
	self.wifiaps = [[AlertyDBMgr sharedAlertyDBMgr] getAllWifiAPs];
	
	NSLog(@"wifiaps : %@", self.wifiaps);
	
	// reload tv
	[self.wifiapsTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_currentWifiAp == nil ? 3 : 4);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 0;
    if (section == 1) return 1;
	if (_currentWifiAp) {
		return section == 2 ? 1 : [_wifiaps count];
	}
    return [_wifiaps count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 || indexPath.section == 1) return NO;
	BOOL shouldDelete = _currentWifiAp ? indexPath.section == 3 : indexPath.section == 2;
	if (shouldDelete) {
		WifiAP *wifiap = [self.wifiaps objectAtIndex:indexPath.row];
        NSInteger type = [wifiap.type integerValue];
		shouldDelete &= (type == kWifiAPTypeUser || type == kWifiAPTypeBeaconPrivate);
	}
	return shouldDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 || indexPath.section == 1) return;
	BOOL shouldDelete = _currentWifiAp ? indexPath.section == 3 : indexPath.section == 2;
	if (editingStyle == UITableViewCellEditingStyleDelete && shouldDelete) {
		WifiAP *wifiap = [self.wifiaps objectAtIndex:indexPath.row];
		[[AlertyDBMgr sharedAlertyDBMgr] delWifiAP:wifiap];
		[self reloadWifiAps];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FacebookCell"];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FacebookCell"];
		}
		//cell.textLabel.text = NSLocalizedString(@"Display a request to save the current access point that the phone is connected to.", @"");
       // cell.textLabel.textColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 250, 70)];
        label.text =  NSLocalizedString(@"Display a request to save the current access point that the phone is connected to.", @"");
        label.textColor = [UIColor colorNamed:@"color_text"];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        label.numberOfLines = 0;

        [cell.contentView addSubview:label];
		cell.accessoryView = self.askNetworkSwitchButton;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];
        //cell.textLabel.frame = CGRectMake(20, 0, 284, 20);

       /* cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];*/
		return cell;
	}
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WifiApCell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WifiApCell"];
	}
	cell.textLabel.textColor = [UIColor colorNamed:@"color_text"];
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
	cell.backgroundColor = [UIColor clearColor];
	
	WifiAP *w = (_currentWifiAp && indexPath.section == 2) ? _currentWifiAp : [_wifiaps objectAtIndex:indexPath.row];
	cell.textLabel.text = w.name;
    cell.textLabel.numberOfLines = 0;
	cell.accessoryView.hidden = ([w.type intValue] != kWifiAPTypeUser);
    cell.detailTextLabel.textColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
	cell.detailTextLabel.text = w.info;

    [self addSeparator:cell];
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) return nil;
    if (section == 1) return NSLocalizedString(@"Add network", @"Add network");;
	if (_currentWifiAp && section == 2)
		return NSLocalizedString(@"Active WiFi", @"");
	else {
		if([_wifiaps count] > 0)
			return NSLocalizedString(@"Saved positions", @"");
		else
			return NSLocalizedString(@"No position added", @"");
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) return 90;
    return 60.0;
}


- (void) addSeparator:(UIView*)cell {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0];
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:view];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.wifiapsTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 1) return;
	
	WifiAP *w = (_currentWifiAp && indexPath.section == 2) ? _currentWifiAp : [_wifiaps objectAtIndex:indexPath.row];
	if( [w.type intValue] == kWifiAPTypeUser || [w.type intValue] == kWifiAPTypeBeaconPrivate ) {
		[self editWifiAp:w];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 0.0;
    if (section == 1) return 70;
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 0, 284, 52);
    label.textColor = [UIColor colorNamed:@"color_text"];
    label.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    label.text = [[tableView.dataSource tableView:tableView titleForHeaderInSection:section] uppercaseString];

    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, tableView.bounds.size.width, 70);

    UIView *viewI = [[UIView alloc] init];
    viewI.frame = CGRectMake(10, 10, tableView.bounds.size.width-20, 52);
    viewI.backgroundColor = REDESIGN_COLOR_CANCEL;
    viewI.layer.cornerRadius = 8.0;

   /* if (section == 0) return nil;
    if (section == 1) {
        label.text = [NSLocalizedString(@"Add network", @"Add network") uppercaseString];
        [viewI addSubview:label];
    }
    if (_currentWifiAp && section == 2){
         label.text = [NSLocalizedString(@"Active WiFi", @"") uppercaseString];
        [viewI addSubview:label];
    }
    else {
        if([_wifiaps count] > 0){
            label.text = [NSLocalizedString(@"Saved positions", @"") uppercaseString];
            [viewI addSubview:label];
        }
        else{
            label.text = [NSLocalizedString(@"No position added", @"") uppercaseString];
        }
    }*/

    [viewI addSubview:label];

    [header addSubview:viewI];

	
    return header;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) return 100.0;
	return 0.0;
}*/

/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
    if (section == 0) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 10, self.view.frame.size.width - 30.0, 35);
        label.textColor = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"Scans the vicinity for beacons. Select and give each of them a name and a position.", @"");
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        [view addSubview:label];
        
        self.saveButton.frame = CGRectMake(17, 55, 219, 32);
        self.searchButton.frame = CGRectMake(17 + 17 + 219, 55, 50, 32);
        [view addSubview:self.searchButton];
        [view addSubview:self.saveButton];

        return view;
    }
    return nil;
}*/

#pragma mark - WifiApCellDelegate

- (void) deleteWifiAp:(int)rowNumber {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Delete AP?", @"") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WifiAP *wifiAP = [_wifiaps objectAtIndex:rowNumber];
        [[AlertyDBMgr sharedAlertyDBMgr] delWifiAP:wifiAP];
        [self reloadWifiAps];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"No", @"") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void) addWifiAp {
	_wifiApInfoViewController = [[WifiApInfoViewController alloc] init];
	_wifiApInfoViewController.wifiAp = nil;
	_wifiApInfoViewController.isNew = YES;
	[self.navigationController pushViewController:_wifiApInfoViewController animated:YES];
}


#pragma mark - UIButton target handlers

-(void) askNetworkDidChange:(id)sender {
    BOOL askNetwork = self.askNetworkSwitchButton.value > 0.5f;
	[AlertySettingsMgr setAskNetwork:askNetwork];
    self.askNetworkSwitchButton.value = askNetwork ? 1.0f : 0.0f;
}

@end
