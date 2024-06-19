//
//  RemoteObjectBase.h
//
//  Created by Bence Balint on 10/03/13.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWCall.h"
#import "NSMutableArrayAdditions.h"


@class RemoteObjectBase;

@protocol RemoteObjectDelegate <NSObject>
@optional
- (void) remoteObjectDidStart:(RemoteObjectBase*)remoteObject;
- (void) remoteObjectDidSucceed:(RemoteObjectBase*)remoteObject;
- (void) remoteObjectDidFail:(RemoteObjectBase*)remoteObject;
- (void) remoteObjectDidStop:(RemoteObjectBase*)remoteObject;
- (void) remoteObjectProgress:(RemoteObjectBase*)remoteObject;

- (void) remoteObjectInfoUpdateDidStart:(RemoteObjectBase*)remoteObject;
- (void) remoteObjectInfoUpdateDidSucceed:(RemoteObjectBase*)remoteObject;
- (void) remoteObjectInfoUpdateDidFail:(RemoteObjectBase*)remoteObject;
@end

// 'id obj' == 'RemoteObjectBase *obj'
typedef void (^CompletionBlock)(id obj, NSError *error);

@interface RemoteObjectBase : NSObject <GWCallDelegate>
{
	NSNonRetainingMutableArray *_remoteObjectDelegates;
	id _userInfo;
	GWCall *_infoCall;
	GWCall *_resourceCall;
	ConnectionInfo *_connectionInfo;
	
	void (^CompletionBlock)(RemoteObjectBase*, NSError*);
}

@property (readwrite,retain) NSNonRetainingMutableArray *remoteObjectDelegates;
@property (readwrite,retain) id userInfo;
@property (readwrite,retain) GWCall *resourceCall;
@property (readwrite,retain) ConnectionInfo *connectionInfo;

@property (nonatomic,copy) CompletionBlock completionBlock;

+ (id) remote:(id<RemoteObjectDelegate>)delegate url:(NSString*)url path:(NSString*)path userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;
+ (id) remote:(id<RemoteObjectDelegate>)delegate url:(NSString*)url path:(NSString*)path parameters:(NSDictionary*)parameters userInfo:(id)userInfo startImmediately:(BOOL)startImmediately;
// block code helpers
+ (id) url:(NSString*)url completion:(void (^)(id obj, NSError *error))completion;
+ (id) url:(NSString*)url parameters:(NSDictionary*)parameters completion:(void (^)(id obj, NSError *error))completion;
+ (id) url:(NSString*)url path:(NSString*)path completion:(void (^)(id obj, NSError *error))completion;
+ (id) url:(NSString*)url path:(NSString*)path parameters:(NSDictionary*)parameters completion:(void (^)(id obj, NSError *error))completion;
// handlers are live for the lifetime of the connection & process then autoreleased
+ (id) handle:(NSString*)url completion:(void (^)(id obj, NSError *error))completion;
+ (id) handle:(NSString*)url parameters:(NSDictionary*)parameters completion:(void (^)(id obj, NSError *error))completion;
+ (id) handle:(NSString*)url path:(NSString*)path completion:(void (^)(id obj, NSError *error))completion;
+ (id) handle:(NSString*)url path:(NSString*)path parameters:(NSDictionary*)parameters completion:(void (^)(id obj, NSError *error))completion;

- (void) addDelegate:(id<RemoteObjectDelegate>)delegate;
- (void) removeDelegate:(id<RemoteObjectDelegate>)delegate;
- (void) removeAllDelegates;

- (void) load;
- (NSError*) store;
- (void) stop;
- (void) pause;
- (void) cancel;
- (void) remove;
- (BOOL) isActive;
- (BOOL) isLoading;
- (BOOL) isCompleted;
- (BOOL) needUpdateServerInfo;
- (void) updateServerInfo;
- (BOOL) isUpdatingServerInfo;
// methods to override
- (NSError*) openResource;
- (void) downloadResource;
- (GWCall*) makeResourceCall;			// return appropriate GWCall
- (NSError*) processResponse;			// called if the resource call was successful
- (void) clearObject;					// called if the resource call failed

@end


@interface RemoteObjectBase ()
@property (readwrite,retain) GWCall *infoCall;
- (void) stop:(BOOL)notify;
- (void) cancelInfoCall;
- (void) cancelResourceCall;
- (void) notifyDelegateAboutStart;
- (void) notifyDelegateAboutSuccess;
- (void) notifyDelegateAboutFailure;
- (void) notifyDelegateAboutStop;
- (void) notifyDelegateAboutProgress;
- (void) notifyDelegateAboutInfoUpdateStart;
- (void) notifyDelegateAboutInfoUpdateSuccess;
- (void) notifyDelegateAboutInfoUpdateFailure;
@end
