//
// from:
// http://starterstep.wordpress.com/2009/03/24/custom-uialertview-with-uitableview/
// 
// thanx
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class AlertTableView;

@protocol AlertTableViewDelegate <NSObject>
@optional
- (void) didSelect:(AlertTableView*)tableView row:(NSInteger)row;
- (void) didCancelTable:(AlertTableView*)tableView;
@end


@interface AlertTableView : UIAlertView <UITableViewDelegate,
										 UITableViewDataSource>
{
	UITableView *_tableView;
	id<AlertTableViewDelegate> _caller;
	NSArray *_list;
	CGFloat _tableHeight;
}

@property (readwrite,assign) id<AlertTableViewDelegate> caller;
@property (readwrite,retain) NSArray *list;

- (id) initWithCaller:(id<AlertTableViewDelegate>)caller list:(NSArray*)list title:(NSString*)title;

@end
