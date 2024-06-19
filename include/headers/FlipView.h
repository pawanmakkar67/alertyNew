//
//  FlipView.h
//
//  Created by Bence Balint on 2010.06.29..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class FlipView;

@protocol FlipViewDelegate <NSObject>
@optional
- (void) flipView:(FlipView*)flipView willFlipTo:(UIView*)view;
- (void) flipView:(FlipView*)flipView didFlipTo:(UIView*)view;
@end


@interface FlipView : UIView
{
	UIView *_headView;
	UIView *_tailView;
	UIButton *_flipButton;
	BOOL _showingTail;
	BOOL _disableFlipButton;
	BOOL _backFlipEnabled;
}

@property (readwrite,retain) IBOutlet UIView *headView;			// to have control over it in IB
@property (readwrite,retain) IBOutlet UIView *tailView;			// to have control over it in IB
@property (readwrite,retain) IBOutlet UIButton *flipButton;		// to have control over it in IB
@property (readwrite,assign) BOOL backFlipEnabled;
@property (readwrite,assign) BOOL disableFlipButton;

- (BOOL) isShowingHead;
- (void) flip;
- (void) flipToHead;
- (void) flipToTail;
- (UIView*) activeView;
- (UIView*) inactiveView;

@end
