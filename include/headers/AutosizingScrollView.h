//
//  AutosizingScrollView.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AutosizingScrollView : UIScrollView
{
	BOOL _dontAutosizeForContent;
}

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (readwrite, assign) BOOL dontAutosizeForContent;

@end


@interface AutosizingScrollView ()
- (void) initInternals;
@end
