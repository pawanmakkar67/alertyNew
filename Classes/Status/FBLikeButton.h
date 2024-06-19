//
//  FBLikeButton.h
//  Alerty
//
//  Created by moni on 9/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FBLikeButtonLoginNotification @"FBLikeLoginNotification"

typedef enum {
    FBLikeButtonStyleStandard,
    FBLikeButtonStyleButtonCount,
    FBLikeButtonStyleBoxCount
} FBLikeButtonStyle;

typedef enum {
    FBLikeButtonColorLight,
    FBLikeButtonColorDark
} FBLikeButtonColor;

@interface FBLikeButton : UIView <UIWebViewDelegate>{
    UIWebView   *_webView;
    
    UIColor     *_textColor;
    UIColor     *_linkColor;
    UIColor     *_buttonColor;
}
@property(nonatomic, retain) UIColor   *textColor;
@property(nonatomic, retain) UIColor   *linkColor;
@property(nonatomic, retain) UIColor   *buttonColor;

- (id) initWithFrame:(CGRect)frame andUrl:(NSString *)likePage andStyle:(FBLikeButtonStyle)style andColor:(FBLikeButtonColor)color;
- (id) initWithFrame:(CGRect)frame andUrl:(NSString *)likePage;

@end
