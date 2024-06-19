//
//  StatusCellCGDraw.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDataSource.h"
#import "StripeCellCGDraw.h"


@interface StatusCellCGDraw : StripeCellCGDraw
{
	UIActivityIndicatorView *_activity;
	NSString *_title;
	DSStatus _status;
}

@property (readwrite,retain) NSString *title;
@property (readwrite,assign) DSStatus status;

@end
