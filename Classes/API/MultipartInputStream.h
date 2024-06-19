//
//  MultipartInputStream.h
//  Hirado
//
//  Created by Mekom on 2015.02.16.
//  Copyright (c) 2015 Mekom. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MultipartInputStream : NSInputStream
- (void)addPartWithName:(NSString *)name string:(NSString *)string;
- (void)addPartWithName:(NSString *)name data:(NSData *)data;
- (void)addPartWithName:(NSString *)name data:(NSData *)data contentType:(NSString *)type;
- (void)addPartWithName:(NSString *)name filename:(NSString*)filename data:(NSData *)data contentType:(NSString *)type;
- (void)addPartWithName:(NSString *)name path:(NSString *)path;
- (void)addPartWithName:(NSString *)name filename:(NSString *)filename path:(NSString *)path;
- (void)addPartWithName:(NSString *)name filename:(NSString *)filename stream:(NSInputStream *)stream streamLength:(NSUInteger)streamLength;

@property (nonatomic, readonly) NSString *boundary;
@property (nonatomic, readonly) NSUInteger length;

@end
