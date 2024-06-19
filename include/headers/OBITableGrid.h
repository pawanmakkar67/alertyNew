//
//  OBITableGrid.h
//
// Copyright (c) 2008-2010 Bence Balint
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ListBase.h"


@class OBITableGrid;

@protocol OBITableGridDataSource <NSObject>
@required
- (NSInteger) numberOfCellsInTableGrid:(OBITableGrid *)tableGrid;
- (NSInteger) numberOfRowsInTableGrid:(OBITableGrid *)tableGrid;
- (NSInteger) numberOfColumnsInTableGrid:(OBITableGrid *)tableGrid;
- (UITableViewCell *) tableGrid:(OBITableGrid *)tableGrid cellForIndexPath:(NSIndexPath *)indexPath;
@end


@protocol OBITableGridDelegate <NSObject>
@required
- (CGFloat) widthOfCellInTableGrid:(OBITableGrid *)tableGrid;
- (CGFloat) heightOfCellInTableGrid:(OBITableGrid *)tableGrid;
@optional
- (void) tableGrid:(OBITableGrid *)tableGrid accessoryButtonTappedWithIndexPath:(NSIndexPath *)indexPath;
- (void) tableGrid:(OBITableGrid *)tableGrid didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface OBITableGrid : UIScrollView <ListUIProtocol,
										UIScrollViewDelegate>
{
	id<OBITableGridDelegate> _tableGridDelegate;
	id<OBITableGridDataSource> _tableGridDataSource;
	NSMutableArray *_cells;
	NSMutableArray *_oldCells;
	UITableViewCell *_lastSelectedCell;
	
	BOOL _kineticScrollingDisabled;
	BOOL _scrollCallbacksDisabled;
	NSInteger _firstColumn;
	NSInteger _lastColumn;
	NSInteger _firstDisplayedColumn;
	NSInteger _lastDisplayedColumn;
	
	BOOL _editing;
//	NSTimeInterval _deceleratingTime;
//	CGFloat _deceleratingOffset;
}

@property (readwrite,assign) IBOutlet id<OBITableGridDelegate> tableGridDelegate;
@property (readwrite,assign) IBOutlet id<OBITableGridDataSource> tableGridDataSource;
@property (readwrite,assign) BOOL kineticScrollingDisabled;

- (void) reloadData;
- (void) reloadDataAsNext;
- (void) reloadDataAsPrevious;
- (void) reloadCellsAtIndexPaths:(NSArray *)indexPaths animated:(BOOL)animated;

- (UITableViewCell *) cellAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) cellForPoint:(CGPoint)point;

- (NSIndexPath *) indexPathForCell:(UITableViewCell *)cell;
- (NSIndexPath *) indexPathForPoint:(CGPoint)point;
- (NSIndexPath *) indexPathForItemIndex:(NSInteger)index;

- (NSInteger) itemIndexForCell:(UITableViewCell *)cell;
- (NSInteger) itemIndexAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) itemIndexForPoint:(CGPoint)point;
- (NSInteger) absoluteItemIndexAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger) absoluteItemIndexForPoint:(CGPoint)point;

- (void) selectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (void) deselectCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (NSInteger) itemsPerPage;

// editing is not supported
// dequeueReusableCellWithIdentifier will always return nil

@end
