//
//  BatteryLevelView.h
//
//  Created by Balint Bence on 7/6/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BatteryLevelView : UIView
{
	UIImageView *_image;
}

@property (readwrite,retain) IBOutlet UIImageView *image;

@end
