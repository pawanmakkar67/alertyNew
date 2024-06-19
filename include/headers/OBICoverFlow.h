
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ListBase.h"


@class OBICoverFlow;

@protocol OBICoverFlowDataSource <NSObject>
@required
- (NSInteger) numberOfCellsInCoverFlow:(OBICoverFlow *)coverFlow;
- (UITableViewCell *) coverFlow:(OBICoverFlow *)coverFlow cellForIndex:(NSInteger)index;
@end


@protocol OBICoverFlowDelegate <NSObject>
@required
- (CGSize) sizeOfCoversInCoverFlow:(OBICoverFlow *)coverFlow;
@optional
- (void) coverFlow:(OBICoverFlow *)coverFlow cellAtIndexDidBringToFront:(NSInteger)index;
- (void) coverFlow:(OBICoverFlow *)coverFlow accessoryButtonTappedWithIndex:(NSInteger)index;
- (void) coverFlow:(OBICoverFlow *)coverFlow didSelectCellAtIndex:(NSInteger)index;
@end


typedef enum {
	CFOutlookNokia,
	CFOutlookApple,
	CFOutlookPlain
} OBICoverFlowOutlook;


@interface OBICoverFlow : UIScrollView <ListUIProtocol,
										UIScrollViewDelegate>
{
	id<OBICoverFlowDelegate> _coverFlowDelegate;
	id<OBICoverFlowDataSource> _coverFlowDataSource;
	NSMutableArray *_cells;
	UITableViewCell *_lastSelectedCell;
	UIImageView *_animationImage;
	NSInteger _highlighted;
	NSInteger _overhead;
	NSInteger _firstDisplayed;
	NSInteger _lastDisplayed;
	CATransform3D _middleTransform;
	CATransform3D _leftTransform;
	CATransform3D _rightTransform;
	BOOL _kineticScrollingDisabled;
	BOOL _reloadOnFrameChangeDisabled;
	CGFloat _coverSpacing;
	CGFloat _middleZPosition;
	CGFloat _sideAngle;
	CGFloat _sideZPosition;
	CGFloat _sideXOffset;
	BOOL _scrollCallbacksDisabled;
	BOOL _editing;
}

@property (readwrite,assign) IBOutlet id<OBICoverFlowDelegate> coverFlowDelegate;
@property (readwrite,assign) IBOutlet id<OBICoverFlowDataSource> coverFlowDataSource;
@property (readwrite,assign) BOOL kineticScrollingDisabled;
@property (readwrite,assign) BOOL reloadOnFrameChangeDisabled;
@property (readonly,assign) NSInteger highlighted;
@property (readwrite,assign) CGFloat coverSpacing;
@property (readwrite,assign) CGFloat middleZPosition;
@property (readwrite,assign) CGFloat sideAngle;
@property (readwrite,assign) CGFloat sideZPosition;
@property (readwrite,assign) CGFloat sideXOffset;
@property (readwrite,assign) NSInteger overhead;
@property (readwrite,assign,getter=isEditing) BOOL editing;

- (void) reloadCellAtIndex:(NSInteger)index;
- (void) reloadCellsAtIndexes:(NSArray*)indexes;

- (void) setOutlook:(OBICoverFlowOutlook)outlook;

- (UITableViewCell *) cellAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *) cellAtIndex:(NSInteger)index;
- (UITableViewCell *) highlightedCell;
- (void) moveHighlightTo:(NSInteger)highlight animated:(BOOL)animated;

- (void) selectCellAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) deselectCellAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void) insertCellAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void) deleteCellAtIndex:(NSInteger)index animated:(BOOL)animated;

- (NSInteger) roughIndexForOffset:(CGFloat)offset;
- (NSInteger) roughIndexForPoint:(CGPoint)point;
- (UITableViewCell *) roughCellForPoint:(CGPoint)point;

// editing is not supported
// dequeueReusableCellWithIdentifier will always return nil

@end
