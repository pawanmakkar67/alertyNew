//
//  VideoDetailsViewController.h
//  Alerty
//
//  Created by moni on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayerBaseViewController.h"

@interface VideoDetailsViewController : VideoPlayerBaseViewController

@property (nonatomic) NSInteger                         videoID;
@property (nonatomic, strong) NSString                  *date;

@end
