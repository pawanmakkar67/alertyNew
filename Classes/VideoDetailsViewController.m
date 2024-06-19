//
//  VideoDetailsViewController.m
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoDetailsViewController.h"
#import "config.h"
#import "UIApplicationAdditions.h"
#import "MapViewController.h"
#import "AlertySettingsMgr.h"
#import "AlertyAppDelegate.h"
#import "MobileInterface.h"
#import <Alerty-Swift.h>

@interface VideoDetailsViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicator;
@property (nonatomic, strong) UITableView               *videoTable;
@property (nonatomic, strong) NSMutableArray            *videoData;
@property (nonatomic, strong) NSString                  *alertPolyline;
@property (nonatomic, strong) NSDictionary              *bounds;
@property (nonatomic, strong) NSNumber                    *latitude;
@property (nonatomic, strong) NSNumber                    *longitude;
@property (nonatomic, strong) NSString                  *tracking;
@property (weak, nonatomic) IBOutlet UIButton *playMovieButton;
@property (weak, nonatomic) IBOutlet UIButton *showMapButton;
@property (nonatomic, assign) long                        longDescription;
@property (nonatomic, assign) NSInteger mapId;

@end

@implementation VideoDetailsViewController

#pragma mark - Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.videoData = [NSMutableArray array];
    [self getVideoInfo];
	
	self.title = self.date;
    
    self.playMovieButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.playMovieButton.layer.cornerRadius = 4.0;
    self.showMapButton.backgroundColor = REDESIGN_COLOR_BUTTON;
    self.showMapButton.layer.cornerRadius = 4.0;
    
    [self.videoTable registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"VideoTableViewCell"];
}

#pragma mark - Private methods

- (BOOL) hasVideo {
    
    if ([self.videoURLString length] == 0) {
        return  false;
    }
    else if ([self.videoURLString isEqualToString:@"<null>"])
    {
        return  false;
    }
	return ([[self.videoURLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0);
}

- (BOOL) hasMapData {
	return ((self.alertPolyline && self.bounds) || (self.longitude.doubleValue != 0.0 && self.latitude.doubleValue != 0.0));
}

#pragma mark - Video button callback

- (void)didPressVideoButton:(id)sender {
	[self playVideo];
}

#pragma mark - getList

- (void) getVideoInfo {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityIndicator startAnimating];

    long uid = [AlertySettingsMgr userID];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_DATA, uid, (long)self.videoID];
    [MobileInterface getJsonObject:url completion:^(NSDictionary *result, NSString *errorMessage) {
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.activityIndicator stopAnimating];

            if (result) {
                [self evaluateList:result];
            } else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Communication", @"") message:NSLocalizedString(@"Network communication error occured.", @"") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }];
}

- (void) evaluateList:(NSDictionary *)dict {

    [self.videoData removeAllObjects];
    
	self.longDescription = -1;
	
	NSString* description = nil;
	NSString* accuracy = nil;
	NSString* address = dict[@"Alert"];
    if ([address isKindOfClass:NSString.class]) {
        NSRange index = [address rangeOfString:@"+/-"];
        long location = index.location;
        if (index.length > 0) {
            accuracy = [[NSString alloc] initWithString:[address substringWithRange:NSMakeRange(location, address.length-location)]];
            address = [address substringWithRange:NSMakeRange(0, location-1)];
            index = [accuracy rangeOfString:@"["];
            if (index.length > 0) {
                description = [accuracy substringFromIndex:index.location+1];
                description = [description substringToIndex:description.length-1];
                accuracy = [accuracy substringToIndex:index.location-1];
            }
        } else {
            index = [address rangeOfString:@"["];
            if (index.length > 0) {
                description = [address substringFromIndex:index.location+1];
                description = [description substringToIndex:description.length-1];
                if (index.location <= 1) {
                    address = nil;
                } else {
                    address = [address substringToIndex:index.location-1];
                }
            }
        }
    } else {
        address = nil;
    }
    
    NSString* source = nil;
    switch ([dict[VIDEO_SOURCE] integerValue]) {
        case ALERT_SOURCE_BUTTON: source = NSLocalizedString(@"ALERT_SOURCE_BUTTON", @""); break;
        case ALERT_SOURCE_MANDOWN: source = NSLocalizedString(@"ALERT_SOURCE_MANDOWN", @""); break;
        case ALERT_SOURCE_TIMER: source = NSLocalizedString(@"ALERT_SOURCE_TIMER", @""); break;
        case ALERT_SOURCE_PEBBLE: source = NSLocalizedString(@"ALERT_SOURCE_PEBBLE", @""); break;
        case ALERT_SOURCE_EXTERNAL_BUTTON: source = NSLocalizedString(@"ALERT_SOURCE_EXTERNAL_BUTTON", @""); break;
        case ALERT_SOURCE_WEB: source = NSLocalizedString(@"ALERT_SOURCE_WEB", @""); break;
        case ALERT_SOURCE_TWILIO: source = NSLocalizedString(@"ALERT_SOURCE_TWILIO", @""); break;
        default: break;
    }
    
	if (address) {
		NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Address", @""), @"title",
                                                                    address, @"value", nil];
		[self.videoData addObject:item];
    }
	if (description) {
        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Location", @""), @"title", description, @"value", nil];
        [self.videoData addObject:item];
        if (description.length > 20) self.longDescription = self.videoData.count - 1;
    }
    
    if (source) {
        NSString* extra = dict[VIDEO_EXTRA];
        if (extra && extra.length) {
            source = [NSString stringWithFormat:@"%@ - %@", source, extra];
        }
        NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Alarm type", @""), @"title", source, @"value", nil];
        [self.videoData addObject:item];
    }
    
	if (accuracy) {
		NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Accuracy", @""), @"title", accuracy, @"value", nil];
		[self.videoData addObject:item];
    }
	
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Time sent: ", @""), @"title", [self displayDate:dict[@"Start"]], @"value", nil];
    [self.videoData addObject:item];

    item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Accepted: ", @""), @"title", 
                                        [self displayDate:dict[@"AcceptTime"]], @"value", nil];
    [self.videoData addObject:item];

    item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Accepted by: ", @""), @"title", 
                                                     dict[@"AcceptedBy"], @"value", nil];
    [self.videoData addObject:item];

    item = [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"Time canceled: ", @""), @"title", 
                                        [self displayDate:dict[@"End"]], @"value", nil];
    [self.videoData addObject:item];
    self.videoURLString = [NSString stringWithFormat:@"%@", dict[@"VideoUrl"]];

//    self.videoURLString = [NSString stringWithFormat:"%@", dict[@"VideoUrl"];
    self.alertPolyline = [dict objectForKey:VIDEO_POLYLINE];
    self.bounds = [dict objectForKey:VIDEO_MAP_BOUNDS];
	self.latitude = [dict objectForKey:VIDEO_STARTLAT];
	self.longitude = [dict objectForKey:VIDEO_STARTLONG];
	self.tracking = dict[@"tracking"];

    self.mapId = [dict[@"map"] integerValue];
    
    [self.videoTable reloadData];
	
    self.playMovieButton.enabled = [self hasVideo];
    self.showMapButton.enabled = [self hasMapData];
}

- (NSString *) displayDate:(NSString *)dateStr {
    if ([dateStr isKindOfClass:NSNull.class]) return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.videoData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	VideoTableViewCell *cell = (VideoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCell" forIndexPath:indexPath];
    cell.item = self.videoData[indexPath.row];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [VideoTableViewCell heightForWidth:tableView.frame.size.width item:self.videoData[indexPath.row]];
}

#pragma mark - IBActions

- (IBAction) backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressPlayMovieButton:(id)sender {
	[self playVideo];
}

- (IBAction)didPressShowMapButton:(id)sender {
	if (![self hasMapData])	return;
	
	MapViewController *mvc = [[MapViewController alloc] init];
	mvc.bounds = self.bounds;
	mvc.polyline = self.alertPolyline;
	NSDictionary* item = [self.videoData objectAtIndex:1];
	mvc.startDate = [item objectForKey:@"value"];
	item = [self.videoData objectAtIndex:4];
	mvc.cancelDate = [item objectForKey:@"value"];
	mvc.videoURLString = [NSString stringWithString:self.videoURLString];
	mvc.startLatitude = self.latitude;
	mvc.startLongitude = self.longitude;
	mvc.tracking = self.tracking;
    mvc.mapId = self.mapId;
	[self.navigationController pushViewController:mvc animated:YES];
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
