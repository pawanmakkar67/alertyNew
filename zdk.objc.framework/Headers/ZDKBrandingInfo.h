//
// ZDKBrandingInfo.h
// ZDK
//

#ifndef ZDKBrandingInfo_h
#define ZDKBrandingInfo_h

#import <Foundation/Foundation.h>
#import "ZDKZHandle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKBrandingInfo <ZDKZHandle>

@property(nonatomic) NSString*  _Nullable callNavigationPage;

@property(nonatomic) NSString*  _Nullable serviceName;

@property(nonatomic) NSString*  _Nullable defaultContactImage;

@property(nonatomic) NSString*  _Nullable brandingImage;

@property(nonatomic) NSString*  _Nullable ringtone;

-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
