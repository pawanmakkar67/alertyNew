
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataSourceStates.h"


@class StatusView;

@protocol StatusViewDataSource <NSObject>
@required
- (DSStatus) statusViewStatus:(StatusView*)view;
- (NSString*) statusViewTitle:(StatusView*)view;
- (NSString*) statusViewSubtitle:(StatusView*)view;
- (NSString*) statusViewButton:(StatusView*)view;
@end


@protocol StatusViewDelegate <NSObject>
@optional
- (void) statusViewAction:(StatusView*)view;
@end


@interface StatusView : UIView {
	id<StatusViewDelegate> _delegate;
	id<StatusViewDataSource> _dataSource;
	id _userInfo;
	DSStatus _status;
}

@property (readwrite,assign) id<StatusViewDelegate> delegate;
@property (readwrite,assign) id<StatusViewDataSource> dataSource;
@property (readwrite,retain) id userInfo;
@property (readwrite,assign) DSStatus status;
@property (readwrite,retain) IBOutlet UIImageView *backgroundImage;
@property (readwrite,retain) IBOutlet UIActivityIndicatorView *activity;
@property (readwrite,retain) IBOutlet UILabel *emptyTitle;
@property (readwrite,retain) IBOutlet UILabel *emptySubtitle;
@property (readwrite,retain) IBOutlet UILabel *errorTitle;
@property (readwrite,retain) IBOutlet UILabel *errorSubtitle;
@property (readwrite,retain) IBOutlet UILabel *loadingTitle;
@property (readwrite,retain) IBOutlet UILabel *loadingSubtitle;
@property (readwrite,retain) IBOutlet UILabel *loadedTitle;
@property (readwrite,retain) IBOutlet UILabel *loadedSubtitle;
@property (readwrite,retain) IBOutlet UILabel *title;
@property (readwrite,retain) IBOutlet UILabel *subtitle;
@property (readwrite,retain) IBOutlet UIButton *button;

+ (id) statusView:(NSString*)nibName delegate:(id<StatusViewDelegate>)delegate dataSource:(id<StatusViewDataSource>)dataSource size:(CGSize)size;

- (IBAction) buttonPressed:(UIButton*)sender;

- (void) refresh;
- (UILabel*) titleLabelForStatus:(DSStatus)status;
- (UILabel*) subtitleLabelForStatus:(DSStatus)status;
- (void) clearTitles;
- (void) clearSubtitles;

@end
