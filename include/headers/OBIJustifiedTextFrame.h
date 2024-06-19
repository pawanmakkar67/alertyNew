//
//  OBIJustifiedTextFrame.h
//
//  Created by Bence Balint on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OBIJustifiedTextFrame : UIView
{
	NSString *_text;
	UIFont *_font;
	UIColor *_color;
	BOOL _tailTruncation;
}

@property (readwrite,retain) NSString *text;
@property (readwrite,retain) UIFont *font;
@property (readwrite,retain) UIColor *color;
@property (readwrite,assign) BOOL tailTruncation;

@end
