//
// ZDKOSCallCoordinator.h
// ZDK
//

#ifndef ZDKOSCallCoordinator_h
#define ZDKOSCallCoordinator_h

#import <Foundation/Foundation.h>
#import "ZDKCallMediaChannel.h"
#import "ZDKBrandingInfo.h"
#import "ZDKOSCallRepresentative.h"
#import "ZDKZHandle.h"
#import "ZDKBrandingInfo.h"
@protocol ZDKBrandingInfo;
#import "ZDKOSCallRepresentative.h"
@protocol ZDKOSCallRepresentative;

NS_ASSUME_NONNULL_BEGIN

@protocol ZDKOSCallCoordinator <ZDKZHandle>

-(id<ZDKOSCallRepresentative>)requestNewOutgoingCall:(NSString*)peerName callMedia:(ZDKCallMediaChannel)callMedia brandingInfo:(id<ZDKBrandingInfo> _Nullable)brandingInfo ;
-(id<ZDKOSCallRepresentative>)requestNewIncomingCall:(NSString*)peerName peerNumber:(NSString*)peerNumber callDetails:(NSString* _Nullable)callDetails callMedia:(ZDKCallMediaChannel)callMedia ringTimeout:(int)ringTimeout brandingInfo:(id<ZDKBrandingInfo> _Nullable)brandingInfo ;
-(NSString*)handlesDescription;

@end

NS_ASSUME_NONNULL_END

#endif
