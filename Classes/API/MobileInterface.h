//
//  MobileInterface.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MyLocation;
@interface MobileInterface : NSObject

+ (void)keepAlive:(MyLocation *)lastLocation source: (NSString*)source completion:(void (^)(BOOL success))completion;

+ (NSURLSessionTask *)getJsonObject:(NSString*)url completion:(void (^)(NSDictionary* result, NSString *errorMessage))completion;

+ (NSURLSessionTask *)getJsonArray:(NSString*)url completion:(void (^)(NSArray* result, NSString *errorMessage))completion;

+ (NSURLSessionTask *)submitScreenshot:(UIImage*)image alertID:(NSInteger)alertID completion:(void (^)(BOOL success, NSString *errorMessage))completion;

+ (NSURLSessionTask *)post:(NSString*)url body:(NSDictionary*)body completion:(void (^)(NSDictionary* result, NSString *errorMessage))completion;

+ (NSURLSessionTask *)postForString:(NSString*)url body:(NSDictionary*)body completion:(void (^)(NSString* result, NSString *errorMessage))completion;

@end


