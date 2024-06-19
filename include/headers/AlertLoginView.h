
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class AlertLoginView;

@protocol AlertLoginViewDelegate <NSObject>
@optional
- (void) didLogin:(AlertLoginView*)loginView username:(NSString*)username password:(NSString*)password;
- (void) didCancelLogin:(AlertLoginView*)loginView;
@end


@interface AlertLoginView : UIAlertView <UITextFieldDelegate>
{
	UITextField *_usernameField;
	UITextField *_passwordField;
	id<AlertLoginViewDelegate> _caller;
}

@property (nonatomic,assign) id<AlertLoginViewDelegate> caller;
@property (nonatomic,retain) UITextField *usernameField;
@property (nonatomic,retain) UITextField *passwordField;

- (id) initWithCaller:(id<AlertLoginViewDelegate>)caller title:(NSString*)title username:(NSString*)username password:(NSString*)password;

@end
