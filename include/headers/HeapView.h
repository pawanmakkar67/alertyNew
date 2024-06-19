//
//  HeapView.h
//  HeapView
//
//  Created by Balint Bence on 4/13/11.
//  Copyright 2011 Viking Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBButton.h"


typedef enum {
	HVMinimumFit,
	HVEqualFit,
	HVMarginFit,
	HVArchFit,
	HVBorderFit,
	HVSimpleLeftFit,
	HVSimpleRightFit,
	HVSimpleUpFit,
	HVSimpleDownFit,
	HVSimpleUpAndLeftFit,
	HVAlignedLeftFit,
	HVAlignedRightFit
} HVFitMethod;


@class HeapView;

@protocol HeapViewDelegate <NSObject>
@optional
- (void) heapView:(HeapView*)heapView didSelectButtonAtIndexPath:(NSIndexPath*)indexPath;
@end


@interface HeapView : UIView <SBButtonDelegate>
{
	id<HeapViewDelegate> _heapViewDelegate;
	NSArray *_buttons;
	CGSize _itemSize;
	NSInteger _itemBias;
	HVFitMethod _fitMethod;
}

@property (readwrite,assign) IBOutlet id<HeapViewDelegate> heapViewDelegate;
@property (readwrite,retain) NSArray *buttons;
@property (readwrite,assign) CGSize itemSize;
@property (readwrite,assign) NSInteger itemBias;
@property (readwrite,assign) HVFitMethod fitMethod;

+ (id) heapViewWithFrame:(CGRect)frame
				 buttons:(NSArray*)buttons
				itemSize:(CGSize)itemSize
			   fitMethod:(HVFitMethod)fitMethod;

- (void) reloadData;

- (SBButton*) buttonAtIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*) indexPathOfButton:(SBButton*)button;

- (void) selectButton:(SBButton*)button;
- (void) selectButton:(SBButton*)button autoDeselect:(BOOL)autoDeselect;
- (void) deselectButton:(SBButton*)button;

@end
