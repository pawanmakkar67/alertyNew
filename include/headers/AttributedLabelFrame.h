//
//  AttributedLabelFrame.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CORE_TEXT
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreTextView.h"


@class AttributedLabelFrame;

@protocol AttributedLabelDelegate <NSObject>
@optional
- (NSAttributedString*) attributedLabelFor:(AttributedLabelFrame*)labelFrame;
@end


@interface AttributedLabelFrame : UILabel
{
	id<AttributedLabelDelegate> _attributedLabelDelegate;
	NSString *_originalText;
	CoreTextView *_internalCT;
	BOOL _autoresizeFrameHeight;
}

@property (nonatomic,assign) IBOutlet id<AttributedLabelDelegate> attributedLabelDelegate;
@property (nonatomic,assign) BOOL autoresizeFrameHeight;

// methods to override
- (void) initInternals;

// public methods
- (void) refreshText;
- (void) refreshText:(UIInterfaceOrientation)orientation;
- (CGSize) contentSize;
- (NSAttributedString *) attributedText;
- (void) setAttributedText:(NSAttributedString *)text;

@end


@interface AttributedLabelFrame ()
@property (readwrite,retain) CoreTextView *internalCT;
@end
#endif
