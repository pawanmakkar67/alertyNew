//
//  HeadsetViewController.m
//  Alerty
//
//  Created by moni on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeadsetViewController.h"
#import "AlertyViewController.h"
#import "AlertyAppDelegate.h"
#import "MainController.h" 
#import "UIDeviceAdditions.h"
#import "AlertySettingsMgr.h"
#import <QuartzCore/QuartzCore.h>
#import "HeadsetTableViewCell.h"
#import "NSExtensions.h"
#import <fliclib/fliclib.h>
#import <flic2lib/flic2lib.h>

#if !(TARGET_IPHONE_SIMULATOR)
@interface HeadsetViewController () <SCLFlicButtonDelegate, SCLFlicManagerDelegate, FLICButtonDelegate>
@property (strong, nonatomic) SCLFlicButton* pendingButton;
#else
@interface HeadsetViewController ()
#endif

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AVAudioPlayer* audioPlayer;
@property (strong, nonatomic) NSTimer* timeoutTimer;

@property (strong, nonatomic) UIView* scanningPane;
@property (strong, nonatomic) UIView* connectingPane;
@property (strong, nonatomic) UIView* connectedPane;
@property (strong, nonatomic) UIView* notFoundPane;
@property (strong, nonatomic) UIView* privatePane;
@property (strong, nonatomic) UIView* noBluetoothPane;
@property (strong, nonatomic) UIView* currentPane;
@property (strong, nonatomic) NSTimer* scanningTimer;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@property (strong, nonatomic) UIAlertController* alert;

@end

@implementation HeadsetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [FLICManager configureWithDelegate:nil buttonDelegate:self background:YES];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HeadsetTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"HeadsetTableViewCell"];
    
#if !(TARGET_IPHONE_SIMULATOR)
    [[SCLFlicManager sharedManager] onLocationChange];
#endif
	
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"trick" ofType: @"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	
	[self.navigationItem setTitle:[NSLocalizedString(@"Accessories", @"Accessories") uppercaseString]];
    
    [self createPaneViews];
    
    self.testButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.testButton.layer.cornerRadius = 4.0;
}

- (void) closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
	
    [self.audioPlayer play];
    
    [self.tableView reloadData];
}

- (void) viewDidDisappear:(BOOL) animated {
    [super viewDidDisappear:animated];
    [self resignFirstResponder];

    [self.scanningTimer invalidate];
    self.scanningTimer = nil;
}

#pragma mark - IBActions

-(IBAction) closeHeadsetSettingsView:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction) testHeadset:(id)sender {
	
    self.timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(cancelHeadsetTest:) userInfo:self repeats:NO];
	
    self.alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Test mode!", @"") message:NSLocalizedString(@"Please use your accessory to test the functionality with Alerty.", @"") preferredStyle:UIAlertControllerStyleAlert];
    [self.alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self resetHeadsetSettings];
        [self showAlert:NSLocalizedString(@"UnsuccessfulTest", @"")
                                    :NSLocalizedString(@"The test was canceled.", @"")
                                    :@"OK"];
        
    }]];
    [self presentViewController:self.alert animated:true completion:nil];
    
#if !(TARGET_IPHONE_SIMULATOR)
    NSArray* keys = [SCLFlicManager sharedManager].knownButtons.allKeys;
    for (int i=0; i<keys.count; i++) {
        for(id key in [SCLFlicManager sharedManager].knownButtons)
        {
            SCLFlicButton *button = [SCLFlicManager sharedManager].knownButtons[key];
            //[button setMode:SCLFlicButtonModeForeground];
            button.delegate = self;
            [button connect];
        }
    }
    for (FLICButton* button in FLICManager.sharedManager.buttons) {
        button.delegate = self;
        [button connect];
    }
#endif
}

- (void) showSuccessfulTest {
    [self resetHeadsetSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlert:NSLocalizedString(@"The test was successful!", @"")
                   :NSLocalizedString(@"Your device is connected to the phone and is working with Alerty.", @"")
                   :@"OK"];
}

- (void) resetHeadsetSettings {
    [_timeoutTimer invalidate];
    _timeoutTimer = nil;
	[[AlertyAppDelegate sharedAppDelegate].mainController.alertyViewController enableHeadsetForEmergency];
    
#if !(TARGET_IPHONE_SIMULATOR)
    NSArray* keys = [SCLFlicManager sharedManager].knownButtons.allKeys;
    for (int i=0; i<keys.count; i++) {
        for(id key in [SCLFlicManager sharedManager].knownButtons)
        {
            SCLFlicButton *button = [SCLFlicManager sharedManager].knownButtons[key];
            button.delegate = [AlertyAppDelegate sharedAppDelegate];
            [button connect];
        }
    }
    for (FLICButton* button in FLICManager.sharedManager.buttons) {
        button.delegate = [AlertyAppDelegate sharedAppDelegate];
        [button connect];
    }
#endif
}

- (void) cancelHeadsetTest:(id)sender {
	[self resetHeadsetSettings];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlert:NSLocalizedString(@"UnsuccessfulTest", @"")
								:NSLocalizedString(@"Please check that the headset is working and that the Bluetooth is enabled and try again.", @"")
								:@"OK"];
}

#pragma mark -

- (BOOL) canBecomeFirstResponder {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_timeoutTimer invalidate];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#if !(TARGET_IPHONE_SIMULATOR)
    if (section == 0) {
        NSDictionary* buttons = [SCLFlicManager sharedManager].knownButtons;
        return buttons.allKeys.count;
    } else if (section == 1) {
        return FLICManager.sharedManager.buttons.count;
    } else {
        return 1;
    }
#else 
    return 0;
#endif
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
#if !(TARGET_IPHONE_SIMULATOR)
    return (indexPath.section != 2);
#else
    return NO;
#endif
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
#if !(TARGET_IPHONE_SIMULATOR)
    if (indexPath.section == 0) {
        NSDictionary* buttons = [SCLFlicManager sharedManager].knownButtons;
        SCLFlicButton* button = [buttons objectForKey:[buttons.allKeys objectAtIndex:indexPath.row]];
        [SCLFlicManager sharedManager].delegate = self;
        [[SCLFlicManager sharedManager] forgetButton:button];
    } else if (indexPath.section == 1) {
        [FLICManager.sharedManager forgetButton:FLICManager.sharedManager.buttons[indexPath.row] completion:^(NSUUID * _Nonnull uuid, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
#endif
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HeadsetTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HeadsetTableViewCell" forIndexPath:indexPath];
#if !(TARGET_IPHONE_SIMULATOR)
    if (indexPath.section == 0) {
        NSDictionary* buttons = [SCLFlicManager sharedManager].knownButtons;
        NSArray* keys = buttons.allKeys;
        SCLFlicButton* button = [buttons objectForKey:[keys objectAtIndex:indexPath.row]];
        BOOL connected = button.connectionState == SCLFlicButtonConnectionStateConnected;
        [cell.statusLabel setText:connected ? NSLocalizedString(@"Connected", @"") : NSLocalizedString(@"Not connected", @"")];
        cell.titleLabel.text = NSLocalizedString(@"flic_button", @"");
        cell.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        //cell.titleLabel.textColor = [UIColor whiteColor];
        cell.subtitleLabel.text = button.userAssignedName;
    } else if (indexPath.section == 1) {
        FLICButton* button = FLICManager.sharedManager.buttons[indexPath.row];
        BOOL connected = button.state == FLICButtonStateConnected;
        [cell.statusLabel setText:connected ? NSLocalizedString(@"Connected", @"") : NSLocalizedString(@"Not connected", @"")];
        cell.titleLabel.text = NSLocalizedString(@"flic_button", @"");
        cell.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        //cell.titleLabel.textColor = [UIColor whiteColor];

        cell.subtitleLabel.text = button.batteryVoltage < 2.6 ? NSLocalizedString(@"FLIC_BATTERY_LOW", @"") : NSLocalizedString(@"FLIC_BATTERY_NORMAL", @"");
    } else {
        cell.titleLabel.text = NSLocalizedString(@"Add Flic", @"Add Flic");
        cell.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
        //cell.titleLabel.textColor = [UIColor whiteColor];


    }
#endif
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#if !(TARGET_IPHONE_SIMULATOR)
    NSDictionary* buttons = [SCLFlicManager sharedManager].knownButtons;
    if (indexPath.row == [buttons allKeys].count) {
        
        if (FLICManager.sharedManager.state != FLICManagerStatePoweredOn) {
            [self setPane:self.noBluetoothPane];
            return;
        }
        
        [[FLICManager sharedManager] scanForButtonsWithStateChangeHandler:^(FLICButtonScannerStatusEvent event) {
            // You can use these events to update your UI.
            switch (event) {
                case FLICButtonScannerStatusEventDiscovered:
                    [self setPane:self.connectingPane];
                    break;
                case FLICButtonScannerStatusEventConnected:
                    break;
                case FLICButtonScannerStatusEventVerified:
                    break;
                case FLICButtonScannerStatusEventVerificationFailed:
                    break;
                default:
                    break;
            }
        } completion:^(FLICButton *button, NSError *error) {
            NSLog(@"Scanner completed with error: %@", error);
            if (!error)
            {
                NSLog(@"Successfully verified: %@, %@, %@", button.name, button.bluetoothAddress, button.serialNumber);
                // Listen to single click only.
                button.triggerMode = FLICButtonTriggerModeClick;
                [button connect];
                [self.scanningTimer invalidate];
                self.scanningTimer = nil;
                
                //button.delegate = [AlertyAppDelegate sharedAppDelegate];
                //dispatch_async(dispatch_get_main_queue(), ^{
                if (self.currentPane) [self setPane:self.connectedPane];
                [self.tableView reloadData];
                //});
            }
        }];

        [self setPane:self.scanningPane];
        [SCLFlicManager sharedManager].delegate = self;
        [SCLFlicManager.sharedManager startScan];
    
        self.scanningTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(scanTimeOver) userInfo:nil repeats:NO];
    }
#endif
}

#pragma mark - FlicManagerDelegate

#if !(TARGET_IPHONE_SIMULATOR)

- (void) flicManager:(SCLFlicManager *) manager didDiscoverButton:(SCLFlicButton *) button withRSSI:(NSNumber *) RSSI {
    
    [self setPane:self.connectingPane];
    
    button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndHold;
    button.delegate = self; //[AlertyAppDelegate sharedAppDelegate];
    [button connect];
    [self.scanningTimer invalidate];
    self.scanningTimer = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

/* I think this is not called at all with the new SDK */
- (void) flicManager:(SCLFlicManager * _Nonnull) manager didGrabFlicButton:(SCLFlicButton * _Nullable) button withError: (NSError * _Nullable) error {
    
    [self setPane:self.connectingPane];

    button.triggerBehavior = SCLFlicButtonTriggerBehaviorClickAndHold;
    button.delegate = self; //[AlertyAppDelegate sharedAppDelegate];
    [button connect];
    [self.scanningTimer invalidate];
    self.scanningTimer = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [SCLFlicManager sharedManager].delegate = [AlertyAppDelegate sharedAppDelegate];
}

- (void) flicManager:(SCLFlicManager *)manager didChangeBluetoothState: (SCLFlicManagerBluetoothState) state {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void) flicManager:(SCLFlicManager *)manager didForgetButton:(NSUUID *)buttonIdentifier error:(NSError *)error {
    [SCLFlicManager sharedManager].delegate = [AlertyAppDelegate sharedAppDelegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#endif

#pragma mark SCLFlicButtonDelegate

#if !(TARGET_IPHONE_SIMULATOR)
- (void) flicButtonDidConnect:(SCLFlicButton *)button {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void) flicButtonIsReady:(SCLFlicButton *)button {
    button.delegate = [AlertyAppDelegate sharedAppDelegate];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.currentPane) [self setPane:self.connectedPane];
    });
}

- (void) flicButton:(SCLFlicButton *)button didFailToConnectWithError:(NSError *)error {
}

- (void) flicButton:(SCLFlicButton * _Nonnull) button didReceiveButtonClick:(BOOL) queued age: (NSInteger) age {
    [self showSuccessfulTest];
}

#pragma mark - FLICButtonDelegate

- (void)buttonDidConnect:(FLICButton *)button {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)buttonIsReady:(FLICButton *)button {
}

- (void)button:(FLICButton *)button didReceiveButtonClick:(BOOL)queued age:(NSInteger)age {
    [self showSuccessfulTest];
}

- (void)button:(FLICButton *)button didFailToConnectWithError:(NSError * _Nullable)error {
}

- (void)button:(nonnull FLICButton *)button didDisconnectWithError:(NSError * _Nullable)error {
}

#endif

#pragma mark Adding Flic

- (UIView *)createViewWithDictionary:(NSDictionary *)dictionary;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 330.0)];
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(115.0, 0.0, 90.0, 62.0)];
    icon.contentMode = UIViewContentModeCenter;
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0.0, 62.0, 320.0, 268.0)];
    background.backgroundColor = [UIColor whiteColor];
    
    UIButton *mainImage = [UIButton buttonWithType:UIButtonTypeCustom];
    mainImage.frame = CGRectMake(85.0, 120.0, 150.0, 150.0);
    mainImage.contentMode = UIViewContentModeScaleAspectFill;
    [mainImage addTarget:self action:@selector(mainImageTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0.0, 61.0, 320.0, 50.0)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 75.0, 304.0, 21.0)];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    
    UILabel *bottomText = [[UILabel alloc] initWithFrame:CGRectMake(8.0, 271.0, 304.0, 59.0)];
    bottomText.font = [UIFont systemFontOfSize:15.0];
    bottomText.textAlignment = NSTextAlignmentCenter;
    bottomText.numberOfLines = 2;
    
    UITextView *mainText = [[UITextView alloc] initWithFrame:CGRectMake(40.0, 169.0, 240.0, 89.0)];
    mainText.backgroundColor = [UIColor clearColor];
    mainText.editable = NO;
    mainText.userInteractionEnabled = NO;
    
    UIButton *topRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topRightButton.frame = CGRectMake(270.0, 61.0, 50.0, 50.0);
    topRightButton.imageView.contentMode = UIViewContentModeCenter;
    [topRightButton addTarget:self action:@selector(topRightButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *bottomRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomRightButton.frame = CGRectMake(195.0, 290.0, 115.0, 25.0);
    [bottomRightButton setTitleColor:[UIColor colorWithWhite:0.29 alpha:1.0] forState:UIControlStateNormal];
    [bottomRightButton addTarget:self action:@selector(bottomRightButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    bottomRightButton.contentHorizontalAlignment = UIViewContentModeRight;
    [bottomRightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(125.0, 290.0, 70.0, 25.0);
    [bottomButton setTitleColor:[UIColor colorWithWhite:0.29 alpha:1.0] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(bottomButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [bottomButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    bar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    icon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mainImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    mainText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    bottomText.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    topRightButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    bottomRightButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    bottomButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    if(dictionary[@"icon"])
    {
        icon.image = dictionary[@"icon"];
    }
    
    if(dictionary[@"mainImage"])
    {
        [mainImage setImage:dictionary[@"mainImage"] forState:UIControlStateNormal];
    }
    
    if(dictionary[@"barBackground"])
    {
        bar.backgroundColor = dictionary[@"barBackground"];
    }
    
    if(dictionary[@"title"])
    {
        title.text = dictionary[@"title"];
    }
    
    if(dictionary[@"bottomText"])
    {
        bottomText.text = dictionary[@"bottomText"];
    }
    
    if(dictionary[@"mainText"])
    {
        mainText.attributedText = dictionary[@"mainText"];
        mainText.font = [UIFont systemFontOfSize:18.0];
        mainText.textAlignment = NSTextAlignmentCenter;
    }
    
    if(dictionary[@"topRightButton"])
    {
        [topRightButton setImage:dictionary[@"topRightButton"] forState:UIControlStateNormal];
    }
    
    if(dictionary[@"bottomRightButton"])
    {
        [bottomRightButton setTitle:dictionary[@"bottomRightButton"] forState:UIControlStateNormal];
    } else {
        bottomRightButton.hidden = YES;
    }
    
    if(dictionary[@"bottomButton"])
    {
        [bottomButton setTitle:dictionary[@"bottomButton"] forState:UIControlStateNormal];
    } else {
        bottomButton.hidden = YES;
    }
    
    if([dictionary[@"iconAnimation"] isEqualToString:@"grow"])
    {
        CABasicAnimation *searchingAnimationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        searchingAnimationScale.duration = 1.0;
        searchingAnimationScale.toValue = @1.2;
        searchingAnimationScale.repeatCount = HUGE_VALF;
        searchingAnimationScale.autoreverses = YES;
        searchingAnimationScale.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.32 :0.00 :0.08 :1.00];
        
        CABasicAnimation *searchingAnimationY = [CABasicAnimation animationWithKeyPath:@"position.y"];
        searchingAnimationY.duration = 1.0;
        searchingAnimationY.toValue = @(icon.layer.position.y-5.0);
        searchingAnimationY.repeatCount = HUGE_VALF;
        searchingAnimationY.autoreverses = YES;
        searchingAnimationY.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.33 :0.18 :0.13 :1.00];
        
        [icon.layer addAnimation:searchingAnimationScale forKey:@"scale"];
        [icon.layer addAnimation:searchingAnimationY forKey:@"y"];
    }
    
    [view addSubview:icon];
    [view addSubview:background];
    [view addSubview:mainImage];
    [view addSubview:bar];
    [view addSubview:title];
    [view addSubview:bottomText];
    [view addSubview:mainText];
    [view addSubview:topRightButton];
    [view addSubview:bottomRightButton];
    [view addSubview:bottomButton];
    
    return view;
}

- (void)createPaneViews; {
    
    // scanning pane
    self.scanningPane = [self createViewWithDictionary:@{
        @"title": NSLocalizedString(@"Searching for new Flics", @""),
        @"bottomText": NSLocalizedString(@"Click the Flic you want to add once", @""),
        @"mainImage": [UIImage imageNamed:@"flic_search"],
        @"barBackground": [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0],
        @"icon": [UIImage imageNamed:@"flic_search_icon"],
        @"topRightButton": [UIImage imageNamed:@"flic_close"],
        @"iconAnimation": @"grow"
    }];
    
    // connecting pane
    
    self.connectingPane = [self createViewWithDictionary:@{
        @"title": NSLocalizedString(@"Found new Flic, connecting", @""),
        @"mainImage": [UIImage imageNamed:@"flic_connecting"],
        @"bottomText": NSLocalizedString(@"This can take a few seconds", @""),
        @"barBackground": [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0],
        @"icon": [UIImage imageNamed:@"flic_connecting_icon"]
    }];
    
    // connected pane
    
    self.connectedPane = [self createViewWithDictionary:@{
        @"title": NSLocalizedString(@"Connected", @""),
        @"mainImage": [UIImage imageNamed:@"flic_connected"],
        @"bottomText": NSLocalizedString(@"Tap to add Flic", @""),
        @"barBackground": [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1.0],
        @"icon": [UIImage imageNamed:@"flic_connected_icon"],
        @"topRightButton": [UIImage imageNamed:@"flic_close"]
    }];
    
    // connection error pane
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18.0], NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2 alpha:1.0]};
    
    // not found pane
    
    self.notFoundPane = [self createViewWithDictionary:@{
        @"barBackground": [UIColor colorWithRed:255.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1.0],
        @"title": NSLocalizedString(@"Couldn’t find any new Flics", @""),
        @"mainText": [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Make sure your Flic is within reach when you click it", @"")],
        /*@"bottomRightButton": NSLocalizedString(@"TRY AGAIN", @""),*/
        @"bottomButton": NSLocalizedString(@"CLOSE", @""),
        @"topRightButton": [UIImage imageNamed:@"flic_info"]
    }];
    
    // private pane
    
    self.privatePane = [self createViewWithDictionary:@{
        @"icon": [UIImage imageNamed:@"flic_locked_icon"],
        @"title": NSLocalizedString(@"Your Flic is in Private Mode", @""),
        @"barBackground": [UIColor colorWithRed:255.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1.0],
        @"mainImage": [UIImage imageNamed:@"flic_search"],
        @"bottomText": NSLocalizedString(@"FLIC_PRIVATE", @""),
        @"topRightButton": [UIImage imageNamed:@"flic_close"]
    }];
    
    // no bluetooth pane
    
    self.noBluetoothPane = [self createViewWithDictionary:@{
        @"icon": [UIImage imageNamed:@"flic_no_bluetooth_icon"],
        @"barBackground": [UIColor colorWithRed:255.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1.0],
        @"title": NSLocalizedString(@"Bluetooth is OFF", @""),
        @"mainText": [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Turn on Bluetooth and try again.", @"") attributes:attributes],
        @"topRightButton": [UIImage imageNamed:@"flic_close"]
    }];
}

- (void)setPane:(UIView*)pane; {
    if(pane == self.currentPane) {
        return;
    }
    
    CGRect frame = pane.frame;
    frame.origin.y = self.view.frame.size.height - pane.frame.size.height;
    frame.size.width = self.view.frame.size.width;
    pane.frame = frame;
    
    if(self.currentPane)
    {
        UIView *oldPane = self.currentPane;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^
         {
            [oldPane removeFromSuperview];
        }];
        
        CABasicAnimation *slideOut = [CABasicAnimation animationWithKeyPath:@"position.x"];
        slideOut.duration = 0.8;
        slideOut.toValue = @(-90.0/2.0);
        slideOut.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.60 :0.00 :0.40 :1.00];
        slideOut.fillMode = kCAFillModeForwards;
        slideOut.removedOnCompletion = NO;
        
        CABasicAnimation *slideIn = [CABasicAnimation animationWithKeyPath:@"position.x"];
        slideIn.duration = 0.5;
        slideIn.fromValue = @(self.currentPane.layer.position.x + self.currentPane.frame.size.width);
        slideIn.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.60 :0.00 :0.40 :1.00];
        slideIn.removedOnCompletion = YES;
        
        [self.currentPane.layer addAnimation:slideOut forKey:@"slideOut"];
        
        self.currentPane = pane;
        self.currentPane.hidden = NO;
        [self.view addSubview:self.currentPane];
        [self.currentPane.layer removeAllAnimations];
        [self.currentPane.layer addAnimation:slideIn forKey:@"slideIn"];
        
        [CATransaction commit];
    }
    else
    {
        self.currentPane = pane;
        [self.currentPane.layer removeAllAnimations];
        [self.view addSubview:self.currentPane];
    }
}

- (void)topRightButtonTouched {
    if (self.currentPane == self.scanningPane ||
        self.currentPane == self.connectedPane ||
        self.currentPane == self.privatePane ||
        self.currentPane == self.noBluetoothPane) {
        [self.currentPane removeFromSuperview];
        self.currentPane = nil;
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Couldn't find any flics", @"") message:NSLocalizedString(@"FLIC_INFO", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)bottomButtonTouched {
    [self.currentPane removeFromSuperview];
    self.currentPane = nil;
}

- (void)mainImageTouched {
    [self.currentPane removeFromSuperview];
    self.currentPane = nil;
}

- (void)bottomRightButtonTouched {
}

- (void)scanTimeOver {
    [self.scanningTimer invalidate];
    self.scanningTimer = nil;
    
#if !(TARGET_IPHONE_SIMULATOR)
    if (self.currentPane == self.scanningPane) {
        
        [FLICManager.sharedManager stopScan];
        
        NSUInteger buttons = [SCLFlicManager.sharedManager stopScan];
        if (buttons) {
            [self setPane:self.privatePane];
            
            [SCLFlicManager.sharedManager startScan];
            self.scanningTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(scanTimeOver) userInfo:nil repeats:NO];
            
        } else {
            [self setPane:self.notFoundPane];
        }
    }
#endif
}

@end
