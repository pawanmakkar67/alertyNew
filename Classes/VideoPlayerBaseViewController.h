//
//  VideoPlayerBaseViewController.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/30/13.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VideoPlayerBaseViewController : BaseViewController

@property (nonatomic, strong) NSString *videoURLString;

- (void) playVideo;

@end
