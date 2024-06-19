//
//  MessageTimeCell.h
//  Maps
//
//  Created by Viking on 2017. 05. 09..
//  Copyright © 2017. MapsWithMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTimeCell : UITableViewCell

@property (nonatomic, strong) NSDate* date;
+ (NSMutableString*) timeLeftSinceDate: (NSDate *) dateT;

@end
