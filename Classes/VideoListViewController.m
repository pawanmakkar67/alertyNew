//
//  VideoListViewController.m
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoListViewController.h"
#import "config.h"
#import "UIApplicationAdditions.h"
#import "VideoDetailsViewController.h"
#import "AlertySettingsMgr.h"
#import "NSExtensions.h"
#import "MobileInterface.h"

@interface VideoItem : NSObject

@property (nonatomic) NSInteger         itemID;
@property (nonatomic, strong) NSString  *videoTitle;
@property (nonatomic, strong) NSString  *dateAndTime;

- (id) initWithTitle:(NSString *)videoTitle itemID:(NSInteger)itemID date:(NSString *)dateAndTime;

@end

@interface VideoListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicator;
@property (nonatomic, strong) UITableView               *videoTable;
@property (nonatomic, strong) UIView                    *nodataView;
@property (nonatomic, strong) NSMutableArray            *videoList;

@end

@implementation VideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = [NSLocalizedString(@"History", @"") uppercaseString];
    
    UIBarButtonItem *prevBtn = [UIBarButtonItem barButton:[UIImage imageNamed:@"icon_back.png"] target:self action:@selector(closePressed)];
    self.navigationItem.leftBarButtonItem = prevBtn;
    
	self.videoList = [NSMutableArray array];
}

- (void) closePressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self getPreviousAlerts];
}

#pragma getList

- (void) getPreviousAlerts {

    long uid = [AlertySettingsMgr userID];
	NSString *url = [NSString stringWithFormat:GET_VIDEO_LIST, uid];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityIndicator startAnimating];
    [MobileInterface getJsonArray:url completion:^(NSArray *result, NSString *errorMessage) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.activityIndicator stopAnimating];
            if (result) {
                [self.videoList removeAllObjects];
                for (NSDictionary *item in result) {
                    VideoItem *video = [[VideoItem alloc] initWithTitle:item[VIDEO_TITLE]
                                                                 itemID:[item[VIDEO_ID] integerValue]
                                                                   date:item[VIDEO_DATE]];
                    [self.videoList addObject:video];
                }
                if ([self.videoList count] == 0) {
                    if (![self.view.subviews containsObject:self.nodataView]) {
                        CGRect frame = self.view.frame;
                        frame.origin.y = 0.0;
                        self.nodataView.frame = frame;
                        [self.view addSubview:self.nodataView];
                    }
                }
                else {
                    if ([self.view.subviews containsObject:self.nodataView]) {
                        [self.nodataView removeFromSuperview];
                    }
                    [self.videoTable reloadData];
                }
            } else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Communication", @"") message:NSLocalizedString(@"Network communication error occured.", @"") preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }];
}

#pragma mark - UITableDatabaseDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"VideoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
	cell.textLabel.textColor = [UIColor colorNamed:@"color_text"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	
    VideoItem* item = [self.videoList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.dateAndTime;
    cell.detailTextLabel.text = ((VideoItem *)[self.videoList objectAtIndex:indexPath.row]).videoTitle;
	
	cell.backgroundColor = [UIColor clearColor];
    [self addSeparator:cell];
    return cell;
}

- (void) addSeparator:(UIView*)cell {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, cell.frame.size.height-1, cell.frame.size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:48.0/255.0 blue:58.0/255.0 alpha:1.0];
    view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:view];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoDetailsViewController *vdvc = [[VideoDetailsViewController alloc] init];
    vdvc.videoID = ((VideoItem *)[self.videoList objectAtIndex:indexPath.row]).itemID;
    vdvc.date = ((VideoItem *)[self.videoList objectAtIndex:indexPath.row]).dateAndTime;
    [self.navigationController pushViewController:vdvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60.0f;
}

#pragma mark IBActions

- (IBAction) backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@implementation VideoItem

- (id) initWithTitle:(NSString *)videoTitle itemID:(NSInteger)itemID date:(NSString *)dateAndTime {
    self = [super init];
    if (self) {
        self.videoTitle = videoTitle;
        self.itemID = itemID;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:dateAndTime];
        [dateFormatter setDateFormat:@"dd MMMM yyyy - HH:mm"];
        self.dateAndTime = [dateFormatter stringFromDate:date];
        
        if ([videoTitle isKindOfClass:NSString.class]) {
            NSRange index = [videoTitle rangeOfString:@"["];
            if (index.location != NSNotFound) {
                NSString* desc = [videoTitle substringFromIndex:index.location+1];
                NSRange index2 = [desc rangeOfString:@"]"];
                if (index2.location != NSNotFound) {
                    desc = [[desc substringToIndex:index2.location] stringByTrimmingCharactersInSet:
                                                                    [NSCharacterSet whitespaceCharacterSet]];
                    self.videoTitle = [NSString stringWithFormat:@"%@\n%@", [videoTitle substringToIndex:index.location], desc];
                }
            }
        } else {
            self.videoTitle = @"";
        }
    }
    return self;
}


@end
