//
//  BrowserViewController.h
//
//  Created by Balint Bence on 4/13/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerBase.h"


@interface BrowserViewController : ViewControllerBase <UIWebViewDelegate>
{
	BOOL _alreadyLoaded;
	BOOL _errored;
	NSString *_url;
}

@property (nonatomic,retain) IBOutlet UIWebView *webView;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *leftSpace;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic,retain) IBOutlet UIBarButtonItem *rightSpace;
@property (readwrite,assign,getter=isAlreadyLoaded) BOOL alreadyLoaded;
@property (readwrite,assign,getter=isErrored) BOOL errored;

- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forwardButtonPressed:(id)sender;

+ (BOOL) canBrowse;
- (void) openUrl:(NSString*)url;

@end
