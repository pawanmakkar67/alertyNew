//
//  VideoPlayerBaseViewController.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/30/13.
//
//

#import "VideoPlayerBaseViewController.h"
#import "config.h"
#import "NSExtensions.h"
@import AVKit;

@interface VideoPlayerBaseViewController() <AVPlayerViewControllerDelegate>
@end

@implementation VideoPlayerBaseViewController

#pragma mark - Overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void) playVideo {
    
    if ([[self.videoURLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return;
    }
    
    AVPlayer* player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoURLString]];
    AVPlayerViewController* controller = [[AVPlayerViewController alloc] init];
    controller.player = player;
    controller.showsPlaybackControls = NO;
    CGRect frame = CGRectMake (0, 0, self.view.frame.size.width, self.view.frame.size.height);
    controller.view.frame = frame;
    [player play];
    controller.showsPlaybackControls = YES;
    controller.delegate = self;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

@end
