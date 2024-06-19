//
//  ListBase.h
//  LibLibrary
//
//  Created by Bence Balint on 11/7/12.
//
//

#import <Foundation/Foundation.h>
#import "ListUIProtocol.h"
#import "ListDataSource.h"
#import "StatusView.h"
#import "StripeCell.h"
#import "ListItem.h"


@interface ListBase : UIViewController <ListDataSourceDelegate,
										StatusViewDelegate,
										StatusViewDataSource>
{
	UIView<ListUIProtocol> *_interfaceView;
	id<ListDataSource> _listDataSource;
	StatusView *_statusView;
	BOOL _unselectableForCGDrawing;
	BOOL _shouldShowTableUnderStatus;
	BOOL _shouldShowFeaturedCell;
	BOOL _shouldShowStatusCell;
	BOOL _shouldShowEditingCell;
	BOOL _disableAutoDeselection;
	BOOL _editing;
	BOOL _editingSingleItem;
	BOOL _firstLoad;
	NSInteger _page;
	NSInteger _failbackPage;
}

@property (readwrite,retain) IBOutlet UIView<ListUIProtocol> *interfaceView;

@property (readwrite,retain) id<ListDataSource> listDataSource;
@property (readwrite,retain) StatusView *statusView;

@property (readwrite,assign) BOOL unselectableForCGDrawing;
@property (readwrite,assign) BOOL shouldShowTableUnderStatus;
@property (readwrite,assign) BOOL shouldShowFeaturedCell;
@property (readwrite,assign) BOOL shouldShowStatusCell;
@property (readwrite,assign) BOOL shouldShowEditingCell;
@property (readwrite,assign) BOOL disableAutoDeselection;
@property (readwrite,assign) BOOL editing;
@property (readonly,assign) BOOL editingSingleItem;
@property (readonly,assign) BOOL firstLoad;
@property (readwrite,assign) NSInteger page;
@property (readwrite,assign) NSInteger failbackPage;

- (void) initInternals;

- (IBAction) refreshButtonPressed:(id)sender;
- (IBAction) reloadButtonPressed:(id)sender;

- (void) setEditing:(BOOL)editing animated:(BOOL)animated;

// methods to override
- (Class) featuredClass:(NSIndexPath*)indexPath;
- (Class) cellClass:(NSIndexPath*)indexPath;
- (Class) statusClass:(DSStatus)status;
- (Class) editingClass:(NSIndexPath*)indexPath;
- (NSString*) featuredNib:(NSIndexPath*)indexPath;
- (NSString*) cellNib:(NSIndexPath*)indexPath;
- (NSString*) statusNib:(DSStatus)status;
- (NSString*) editingNib:(NSIndexPath*)indexPath;

- (NSString*) statusViewNib;

- (void) showStatus:(BOOL)show;

- (BOOL) needShowStatus;
- (BOOL) needFeaturedCell;
- (BOOL) needStatusCell;
- (BOOL) needEditingCell;

- (void) didSelectCell:(StripeCell*)cell;
- (void) didSelectItem:(ListItem*)item;

- (id<ListDataSourceBase>) dataSource;
- (id<ListDataParser>) dataParser;

- (id) refreshParam;
- (id) reloadParam;
- (id) loadNextParam;
- (id) lastLoadParam;

- (NSInteger) itemsPerPage;
- (NSInteger) currentPage;
- (BOOL) isPageLoaded:(NSInteger)page;

- (void) load:(id)param;
- (void) loadNext;
- (void) refresh;
- (void) reload;
- (void) retry;

// base helper methods to override
- (CGFloat) widthForCellAtIndexPath:(NSIndexPath *)indexPath transposeIndexes:(BOOL)transposeIndexes;
- (CGFloat) heightForCellAtIndexPath:(NSIndexPath *)indexPath transposeIndexes:(BOOL)transposeIndexes;
- (void) didSelectCellAtIndexPath:(NSIndexPath *)indexPath transposeIndexes:(BOOL)transposeIndexes;
- (UITableViewCell *) cellForIndexPath:(NSIndexPath *)indexPath transposeIndexes:(BOOL)transposeIndexes;

- (NSInteger) numberOfSections;
- (NSInteger) numberOfCellsInSection:(NSInteger)section;
- (NSInteger) numberOfRows;
- (NSInteger) numberOfColumns;
- (NSInteger) numberOfAllCells;

@end


@interface ListBase ()
- (void) autoDeselectCallback:(NSIndexPath*)indexPath;
@end


@interface SectionedListBase : ListBase
{
}

- (Class) headerClass:(NSInteger)section;
- (NSString*) headerNib:(NSInteger)section;
- (Class) footerClass:(NSInteger)section;
- (NSString*) footerNib:(NSInteger)section;

@end
