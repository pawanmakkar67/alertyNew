//
//  FBLikeButton.m
//  Alerty
//
//  Created by moni on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FBLikeButton.h"
#import "FacebookMgr.h"
#import "config.h"
#import "NSHelpers.h"
#import "AlertyAppDelegate.h"

@implementation FBLikeButton

@synthesize textColor = _textColor, buttonColor = _buttonColor, linkColor = _linkColor;

- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage andStyle:(FBLikeButtonStyle)style andColor:(FBLikeButtonColor)color 
{
    if ((self = [super initWithFrame:frame])) {
        NSString *styleQuery = (style==FBLikeButtonStyleButtonCount? @"button_count" : (style==FBLikeButtonStyleBoxCount? @"box_count" : @"standard"));
        NSString *colorQuery = (color==FBLikeButtonColorDark? @"dark" : @"light");
		NSString *locale = [AlertyAppDelegate locale];
        
        NSString *url = [NSString stringWithFormat:@"http://www.facebook.com/plugins/like.php?locale=%@&layout=%@&show_faces=false&width=%d&height=%d&action=like&colorscheme=%@&href=%@",
                        locale,
                        styleQuery, 
                        (int) frame.size.width, 
                        (int) frame.size.height, 
                        colorQuery, 
                        likePage];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 300)];
        [self addSubview:_webView];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:_webView 
                                                 selector:@selector(reload) 
                                                     name:FBLikeButtonLoginNotification 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginDialogSucceeded:)  
                                                     name:SFacebookLoginSucceededNotification object:nil];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)likePage{
    return [self initWithFrame:frame 
                        andUrl:likePage 
                      andStyle:FBLikeButtonStyleStandard 
                      andColor:FBLikeButtonColorLight];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *path = [[[[request URL] absoluteString] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	cmdlogtext(@"path : %@", path)
    if ([path rangeOfString:@"login.php"].location!=NSNotFound){
        [[FacebookMgr sharedFacebookMgr] login];
        return NO;
    }
    if (([path rangeOfString:@"/connect/"].location!=NSNotFound) || ([path rangeOfString:@"like.php"].location!=NSNotFound)){
        return YES;
    }
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

#pragma mark -
#pragma mark Login dialog notification

- (void) loginDialogSucceeded:(NSNotification *)notification
{
    [_webView reload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_webView name:FBLikeButtonLoginNotification object:nil];
    
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    [_webView release]; 
    _webView = nil;
    
    self.linkColor = nil;
    self.textColor = nil;
    self.buttonColor = nil;

    [super dealloc];
}

@end
