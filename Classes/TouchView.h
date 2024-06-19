//
//  TouchView.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 10/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchView;

@protocol TouchViewDelegate <NSObject>
- (void) didTouchView:(TouchView*)view;
@end

@interface TouchView : UIView
@property (nonatomic, weak) id<TouchViewDelegate> delegate;

@end
