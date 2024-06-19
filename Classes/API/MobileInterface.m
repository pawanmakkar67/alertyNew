//
//  MobileInterface.m
//

#import "MobileInterface.h"
#import "MultipartInputStream.h"
#import "MyLocation.h"
#import "AlertySettingsMgr.h"

@implementation MobileInterface


+ (void)keepAlive:(MyLocation *)lastLocation
           source: (NSString*)source
       completion:(void (^)(BOOL success))completion {
    
    long state = (long)UIDevice.currentDevice.batteryState;
    if (state == UIDeviceBatteryStateUnknown) state = 4;
    float battery = 100.0f * [UIDevice currentDevice].batteryLevel;
    
    NSString* url = [NSString stringWithFormat:HOME_URL @"/ws/keepalive.php?id=%ld&battery_status=%ld&battery=%.0f&signal=0&source=%@",
                     (long)AlertySettingsMgr.userID,
                     state,
                     battery,
                     source];
    if (AlertySettingsMgr.lastPositionEnabled && lastLocation) {
        url = [url stringByAppendingFormat:@"&latitude=%.6f&longitude=%.6f", lastLocation.latitude, lastLocation.longitude];
    }

    url = [url stringByAppendingFormat:@"&active=%i", UIApplication.sharedApplication.applicationState == UIApplicationStateActive ? 1 : 0];
    
    [MobileInterface getJsonObject:url completion:^(NSDictionary *result, NSString *errorMessage) {
        completion(!errorMessage);
    }];
}

+ (NSURLSessionTask *)getJsonObject:(NSString*)url completion:(void (^)(NSDictionary* result, NSString *errorMessage))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error.localizedDescription);
            }
            return;
        }
        
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil) {
                        if (completion != nil) {
                            completion(nil, json[@"message"]);
                        }
                        return;
                    }
                }
            } else {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil && [json isKindOfClass:NSDictionary.class]) {
                        if (completion != nil) {
                            completion(json, nil);
                        }
                        return;
                    }
                }
            }
        }
        
        if (completion != nil) {
            completion(nil, nil);
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionTask *)getJsonArray:(NSString*)url completion:(void (^)(NSArray* result, NSString *errorMessage))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error.localizedDescription);
            }
            return;
        }
        
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil) {
                        if (completion != nil) {
                            completion(nil, json[@"message"]);
                        }
                        return;
                    }
                }
            } else {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSArray *json = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&jsonError];
                    if (jsonError == nil) {
                        if (completion != nil) {
                            completion(json, nil);
                        }
                        return;
                    }
                }
            }
        }
        
        if (completion != nil) {
            completion(nil, nil);
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionTask *)submitScreenshot:(UIImage*)image alertID:(NSInteger)alertID completion:(void (^)(BOOL success, NSString *errorMessage))completion {

    NSDictionary* files = @{ @"image" : image };
    MultipartInputStream *body = [self httpBodyStreamWithFiles:files
                                                    parameters:@{ @"alertID": [NSString stringWithFormat:@"%ld", (long)alertID] }];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:SCREENSHOT_URL]];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [body boundary]] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBodyStream:body];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            if (completion != nil) {
                completion(NO, error.localizedDescription);
            }
            return;
        }
        
        if ([response isKindOfClass:NSHTTPURLResponse.class])
        {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil) {
                        if (completion != nil) {
                            completion(NO, json[@"message"]);
                        }
                        return;
                    }
                }
            } else {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil) {
                        if ([json[@"success"] boolValue]) {
                            if (completion != nil) {
                                completion(YES, nil);
                            }
                        } else {
                            if (completion != nil) {
                                completion(NO, @"Ismeretlen hiba");
                            }
                        }
                        return;
                    }
                }
            }
        }
        
        if (completion != nil) {
            completion(NO, nil);
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (MultipartInputStream *)httpBodyStreamWithFiles:(NSDictionary *)files parameters:(NSDictionary *)parameters {
    MultipartInputStream *body = [[MultipartInputStream alloc] init];
    
    for (NSString *key in parameters.allKeys) {
        NSString *value = parameters[key];
        [body addPartWithName:key string:value];
    }
    
    for (NSString *key in files.allKeys) {
        id value = files[key];
        if ([value isKindOfClass:[NSString class]]) {
            [body addPartWithName:key path:value];
        }
        if ([value isKindOfClass:[UIImage class]]) {
            NSData *data = UIImageJPEGRepresentation(value, 0.9);
            //[body addPartWithName:key data:data];
            [body addPartWithName:key filename:@"image.jpg" data:data contentType:@"image/jpeg"];
        }
    }
    
    return body;
}

+ (NSURLSessionTask *)post:(NSString*)url body:(NSDictionary*)body completion:(void (^)(NSDictionary* result, NSString *errorMessage))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString* post = @"";
    for (NSString* key in body.allKeys) {
        NSString* value = [body[key] stringValue];
        value = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        if (post.length) post = [post stringByAppendingString:@"&"];
        post = [post stringByAppendingFormat:@"%@=%@", key, value];
    }
    NSString* userId = [NSString stringWithFormat:@"%ld", (long)[AlertySettingsMgr userID]];
    if (![userId  isEqual: @""]) {
        NSString* key = @"userid";
        post = [post stringByAppendingFormat:@"%@=%@", key, userId];
    }

    NSData* postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%ld", postData.length];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error.localizedDescription);
            }
            return;
        }
        
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil) {
                        if (completion != nil) {
                            completion(nil, json[@"message"]);
                        }
                        return;
                    }
                }
            } else {
                if (data != nil && data.length > 0) {
                    NSError *jsonError = nil;
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:kNilOptions
                                          error:&jsonError];
                    if (jsonError == nil) {
                        if (completion != nil) {
                            completion(json, nil);
                        }
                        return;
                    }
                }
            }
        }
        
        if (completion != nil) {
            completion(nil, nil);
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (NSURLSessionTask *)postForString:(NSString*)url body:(NSDictionary*)body completion:(void (^)(NSString* result, NSString *errorMessage))completion {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString* post = @"";
    for (NSString* key in body.allKeys) {
        NSString* value = [body[key] stringValue];
        value = [value stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        if (post.length) post = [post stringByAppendingString:@"&"];
        post = [post stringByAppendingFormat:@"%@=%@", key, value];
    }
    NSData* postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%ld", postData.length];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error != nil) {
            if (completion != nil) {
                completion(nil, error.localizedDescription);
            }
            return;
        }
        
        if ([response isKindOfClass:NSHTTPURLResponse.class]) {
            NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
            if (statusCode != 200) {
                if (data != nil && data.length > 0) {
                    if (completion != nil) {
                        completion(nil, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    }
                }
            } else {
                if (completion != nil) {
                    completion([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], nil);
                }
            }
            return;
        }
        
        if (completion != nil) {
            completion(nil, nil);
        }
    }];
    [dataTask resume];
    return dataTask;
}

@end
