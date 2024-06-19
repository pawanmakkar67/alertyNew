//
//  Message.h
//  Teqball
//
//  Created by mohamed souiden on 08/07/16.
//  Copyright © 2016 Teqball. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Message : NSObject

@property (strong, nonatomic) NSString* sid;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSDate* created;

@end
