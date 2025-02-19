//
// ZDKZHandle.h
// ZDK
//

#ifndef ZDKZHandle_h
#define ZDKZHandle_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKZHandle <NSObject>

-(long int)handle;
-(void)initialize;
-(void)releaseReference;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
