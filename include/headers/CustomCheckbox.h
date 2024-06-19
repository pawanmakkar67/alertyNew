//
//  CustomCheckbox.h
//
//  Created by Bence Balint on 03/07/14.
//  Copyright (c) 2014 Bence Balint. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCheckbox : UIButton
{
}

@property (nonatomic, retain) IBOutlet UIImageView *bgImage;
@property (nonatomic, retain) IBOutlet UIImageView *onImage;
@property (nonatomic, retain) IBOutlet UIImageView *offImage;

- (BOOL) isOn;
- (void) turn:(BOOL)on animated:(BOOL)animated;

// methods to override
- (void) layoutForOnState:(BOOL)on;

@end


@interface CustomCheckbox ()
- (void) initInternals;
@end
