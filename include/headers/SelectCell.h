//
//  SelectCell.h
//
//  Created by Bence Balint on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SelectCell : UITableViewCell
{
	BOOL _selectionShown;
}

@property (readwrite,assign,getter=isSelectionShown) BOOL selectionShown;
@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UIImageView *selectionImage;

- (void) setSelectionShown:(BOOL)selectionShown animated:(BOOL)animated;

@end
