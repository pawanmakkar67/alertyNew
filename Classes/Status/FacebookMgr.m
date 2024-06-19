//
//  FacebookMgr.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookMgr.h"
#import "NSStringAdditions.h"
#import "SynthesizeSingleton.h"
#import "config.h"
#import "NSHelpers.h"

@interface FacebookMgr()
@end

@implementation FacebookMgr

SYNTHESIZE_SINGLETON_FOR_CLASS(FacebookMgr);

@synthesize facebook = _facebook;

#pragma mark - Overrides

- (id)init {
    self = [super init];
    if (self) {
        self.facebook = [[[Facebook alloc] initWithAppId:kFacebookAPPID andDelegate:self] autorelease];
		[self restoreSession];
    }
    return self;
}

- (void)dealloc {
	[_facebook release];

    [super dealloc];
}

#pragma mark - Public methods

- (void) restoreSession {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if( [defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"] ) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}
}

- (void) login {
	if( ![self.facebook isSessionValid] ) {
		NSArray *permissions = [[NSArray alloc] initWithObjects:
								@"publish_stream",
								@"read_stream",
								@"offline_access",
								nil];
		[self.facebook authorize:permissions];
		[permissions release];
	}
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName:SFacebookLoginSucceededNotification object:nil];
	}
}

- (void) logout {
	[self.facebook logout];
}

- (void) sendStatusUpdate:(NSString *)update {
	[self sendStatusUpdate:update imageUrl:nil linkUrl:nil];
}

- (void) sendStatusUpdate:(NSString *)update imageUrl:(NSString *)imageUrl linkUrl:(NSString *)linkUrl {
	NSMutableDictionary *params = [NSMutableDictionary dictionary];
	
	[params setObject:update forKey:@"description"];
	
	if (imageUrl) [params setObject:imageUrl forKey:@"picture"];
	if (linkUrl) [params setObject:linkUrl forKey:@"link"];
	
	[self.facebook requestWithGraphPath:@"me/feed"
							  andParams:params
						  andHttpMethod:@"POST"
							andDelegate:self];
}

#pragma mark - FBSessionDelegate

- (void)fbDidLogin
{
	cmdlog
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SFacebookLoginSucceededNotification object:nil];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	cmdlog
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"FBAccessTokenKey"];
	[defaults removeObjectForKey:@"FBExpirationDateKey"];
	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:SFacebookLoggedOutNotification object:nil];
}

- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
	cmdlog
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogout
{
	cmdlog
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"FBAccessTokenKey"];
	[defaults removeObjectForKey:@"FBExpirationDateKey"];
	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:SFacebookLoggedOutNotification object:nil];
}

- (void)fbSessionInvalidated
{
	cmdlog
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"FBAccessTokenKey"];
	[defaults removeObjectForKey:@"FBExpirationDateKey"];
	[defaults synchronize];
	[[NSNotificationCenter defaultCenter] postNotificationName:SFacebookLoggedOutNotification object:nil];
}

- (NSString*)accessToken {
	return self.facebook.accessToken;
}

#pragma mark - FBRequestDelegate

- (void)requestLoading:(FBRequest *)request
{
	cmdlogtext(@"requestLoading");
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	cmdlogtext(@"request didReceiveResponse");
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	cmdlogtext(@"request didFailWithError");
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	cmdlogtext(@"request didLoad");
}

- (void)request:(FBRequest *)request didLoadRawResponse:(NSData *)data
{
	cmdlogtext(@"request didLoadRawResponse");
}

@end
