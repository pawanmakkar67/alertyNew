//
//  CoreTextView.h
//
//  Created by Bence Balint on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LibraryConfig.h"
#if HAVE_CORE_TEXT
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@interface CoreTextView : UIView
{
	NSAttributedString *_attributedText;
	CTTextAlignment _textAlignment;
	CTLineBreakMode _lineBreakMode;
	CGFloat _firstLineHeadIndent;
	CGFloat _headIndent;
	CGFloat _tailIndent;
	CGFloat _defaultTabInterval;
	CGFloat _lineHeightMultiple;
	CGFloat _maximumLineHeight;
	CGFloat _minimumLineHeight;
	CGFloat _lineSpacing;
	CTWritingDirection _baseWritingDirection;
}

@property(readwrite,retain) NSAttributedString *attributedText;
@property(readwrite,assign) CTTextAlignment textAlignment;
@property(readwrite,assign) CTLineBreakMode lineBreakMode;
@property(readwrite,assign) CGFloat firstLineHeadIndent;
@property(readwrite,assign) CGFloat headIndent;
@property(readwrite,assign) CGFloat tailIndent;
@property(readwrite,assign) CGFloat defaultTabInterval;
@property(readwrite,assign) CGFloat lineHeightMultiple;
@property(readwrite,assign) CGFloat maximumLineHeight;
@property(readwrite,assign) CGFloat minimumLineHeight;
@property(readwrite,assign) CGFloat lineSpacing;
@property(readwrite,assign) CTWritingDirection baseWritingDirection;

@end
#endif
