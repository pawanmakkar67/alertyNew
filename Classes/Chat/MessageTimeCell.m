//
//  MessageTimeCell.m
//  Maps
//
//  Created by Viking on 2017. 05. 09..
//  Copyright © 2017. MapsWithMe. All rights reserved.
//

#import "MessageTimeCell.h"

@interface MessageTimeCell()

@property (weak, nonatomic) IBOutlet UILabel *timeTitle;

@end

@implementation MessageTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDate:(NSDate *)date {
    _date = date;
    self.timeTitle.text = [MessageTimeCell timeLeftSinceDate:date];
}

+ (NSMutableString*) timeLeftSinceDate: (NSDate *) dateT {
  
  NSMutableString *timeLeft = [[NSMutableString alloc]init];
  NSDate *today =[NSDate date];
  NSInteger seconds = [today timeIntervalSinceDate:dateT];
  NSInteger days = (int) (floor(seconds / (3600 * 24)));
  if(days) seconds -= days * 3600 * 24;
  NSInteger hours = (int) (floor(seconds / 3600));
  if(hours) seconds -= hours * 3600;
  NSInteger minutes = (int) (floor(seconds / 60));
  if(minutes) seconds -= minutes * 60;
  if(days>0) {
    if (days==1) {
      [timeLeft appendString:@"yesterday"];
    }else if (days<7 && days>1) {
      [timeLeft appendString:[NSString stringWithFormat:@"%ld day(s) ago", (long)days]];
    }else if (days>7 && days<14){
      [timeLeft appendString:@"a week ago"];
    }else if (days>=14 && days<21){
      [timeLeft appendString:@"two weeks ago"];
    }else if (days>=21 && days<28){
      [timeLeft appendString:@"three weeks ago"];
    }else if (days>=28 && days<60){
      [timeLeft appendString:@"one month ago"];
    }else if (days>=60 && days<90){
      [timeLeft appendString:@"two months ago"];
    }else if (days>=90 && days<120){
      [timeLeft appendString:@"three months ago"];
    }else if (days>=120 && days<150){
      [timeLeft appendString:@"four months ago"];
    }else if (days>=150 && days<180){
      [timeLeft appendString:@"five months ago"];
    }else{
      [timeLeft appendString:@"more than 5 months ago"];
    }
  } else {
    if (hours) {
      [timeLeft appendString:[NSString stringWithFormat: @"%ld %@", (long)hours, NSLocalizedString(@"hours_ago", @"")]];
    } else if(minutes) {
      [timeLeft appendString: [NSString stringWithFormat: @"%ld %@",(long)minutes, NSLocalizedString(@"minutes_ago", @"")]];
    } else {
      [timeLeft appendString:NSLocalizedString(@"now", @"")];
    }
  }
  return timeLeft;
}

@end
