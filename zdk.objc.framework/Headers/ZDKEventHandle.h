//
// ZDKEventHandle.h
// ZDK
//

#ifndef ZDKEventHandle_h
#define ZDKEventHandle_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKEventHandle <NSObject>

-(long int)eventHandle;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
