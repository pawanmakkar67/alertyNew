//
//  HelperFactory.h
//  ZDK
//
//  Created by Georgi Ivanov on 8/25/16.
//  Copyright © 2016 Securax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZDKContext;
@protocol ZDKLog;

NS_ASSUME_NONNULL_BEGIN

@interface HelperFactory : NSObject

+(instancetype)sharedInstance;

@property(nonatomic, readonly) id<ZDKContext> context;
@property(nonatomic, readonly) id<ZDKLog> log;

@end

NS_ASSUME_NONNULL_END
