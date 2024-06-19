//
//  WebDetails.h
//
//  Created by Bence Balint on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "StatusView.h"


@class WebDetails;

@protocol WebDetailsDelegate <NSObject>
@optional
- (void) webDetailsDidStartLoad:(WebDetails*)webDetails;
- (void) webDetailsDidFinishLoad:(WebDetails*)webDetails;
- (void) webDetailsDidFailLoad:(WebDetails*)webDetails;
@end


@interface WebDetails : UIViewController <UIWebViewDelegate,
										  StatusViewDelegate,
										  StatusViewDataSource>
{
	id<WebDetailsDelegate> _webDelegate;
	UIWebView *_webView;
	UIImageView *_background;
	NSString *_url;
	StatusView *_statusView;
	DSStatus _status;
	
	UIBarButtonItem *_refreshButton;
	UIBarButtonItem *_backButton;
	
	BOOL _allowRefreshButton;
	BOOL _allowBackButton;
	BOOL _openRequestsInExternalBrowser;
	BOOL _alreadyLoaded;
	NSString *_htmlString;
	NSString *_baseUrl;
	BOOL _shouldAutorotate;
	BOOL _quietLoading;
}

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (readwrite,assign) IBOutlet id<WebDetailsDelegate> webDelegate;
@property (nonatomic,retain) IBOutlet UIImageView *background;
@property (readwrite,assign) BOOL scalePage;
@property (readwrite,assign) BOOL allowRefreshButton;
@property (readwrite,assign) BOOL allowBackButton;
@property (readwrite,assign) BOOL openRequestsInExternalBrowser;
@property (readwrite,assign) BOOL shouldAutorotate;
@property (readwrite,assign) BOOL quietLoading;

- (void) load:(NSString*)url;
- (void) loadHTML:(NSString*)html baseURL:(NSString*)url;
- (void) reload;
- (IBAction) refreshButtonPressed:(id)sender;
- (IBAction) doneButtonPressed:(id)sender;

@end


@interface WebDetails ()
@property (readwrite,retain) NSString *url;
@property (readwrite,retain) StatusView *statusView;
@property (readwrite,assign) DSStatus status;
@property (readwrite,retain) UIBarButtonItem *refreshButton;
@property (readwrite,retain) UIBarButtonItem *backButton;
@property (readwrite,retain) NSString *htmlString;
@property (readwrite,retain) NSString *baseUrl;
@property (readwrite,assign) BOOL alreadyLoaded;
- (void) showStatus:(BOOL)show;
- (void) refreshBackButton;
@end
