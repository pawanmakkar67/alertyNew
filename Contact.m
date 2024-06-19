//
//  Contact.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "Group.h"


@implementation Contact

@dynamic name;
@dynamic phone;
@dynamic row;
@dynamic status;
@dynamic type;
@dynamic groups;
@dynamic online;
@dynamic lastPosition;

- (NSString *)clearedPhoneNumber {
    NSString* phone = [self.phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return phone;
}

@end
