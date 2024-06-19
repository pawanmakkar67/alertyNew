//
//  StatusCell.h
//
//  Created by Bence Balint on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDataSource.h"
#import "StripeCell.h"


@interface StatusCell : StripeCell
{
	UIActivityIndicatorView *_activityIndicator;
	UILabel *_titleLabel;
	DSStatus _status;
}

@property (readwrite,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (readwrite,retain) IBOutlet UILabel *titleLabel;

@property (readwrite,retain) NSString *title;
@property (readwrite,assign) DSStatus status;

@end
