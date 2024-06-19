//
//  AttributedTextFrame.h
//
//  Created by Balint Bence on 4/29/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CORE_TEXT
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CoreTextView.h"


@class AttributedTextFrame;

@protocol AttributedTextDelegate <NSObject>
@optional
- (NSAttributedString*) attributedTextFor:(AttributedTextFrame*)textFrame;
@end


@interface AttributedTextFrame : UITextView
{
	id<AttributedTextDelegate> _attributedTextDelegate;
	NSString *_originalText;
	CoreTextView *_internalCT;
	BOOL _autoresizeFrameHeight;
}

@property (nonatomic,assign) IBOutlet id<AttributedTextDelegate> attributedTextDelegate;
@property (nonatomic,assign) BOOL autoresizeFrameHeight;

// methods to override
- (void) initInternals;

// public methods
- (void) refreshText;
- (void) refreshText:(UIInterfaceOrientation)orientation;

- (CGSize)contentSize;
- (void)setContentSize:(CGSize)size;
- (NSAttributedString *) attributedText;
- (void) setAttributedText:(NSAttributedString *)text;

@end


@interface AttributedTextFrame ()
@property (readwrite,retain) CoreTextView *internalCT;
@end
#endif
