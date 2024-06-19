//
//  SBRadioButton.h
//
//  Created by Balint Bence on 3/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "SBCheckbox.h"


extern NSString *const SBRadioButtonDidChangeNotification;
extern NSString *const SBRadioButtonGroupNameKey;
extern NSString *const SBRadioButtonObjectKey;


@interface SBRadioButton : SBCheckbox
{
	NSString *_radioGroupName;
}

@property (readwrite,retain) NSString *radioGroupName;

@end
