

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class AlertTextField;

@protocol AlertTextFieldDelegate <NSObject>
- (void) didEnter:(AlertTextField*)textField text:(NSString*)text;
- (void) didCancelText:(AlertTextField*)textField;
@end


@interface AlertTextField : UIAlertView
{
	UITextField *_textField;
	id<AlertTextFieldDelegate> _caller;
	BOOL _numeric;
	BOOL _secure;
}

@property (nonatomic,assign) id<AlertTextFieldDelegate> caller;
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,assign) BOOL numeric;
@property (nonatomic,assign) BOOL secure;

- (id) initWithCaller:(id<AlertTextFieldDelegate>)caller title:(NSString*)title text:(NSString*)text placeholder:(NSString*)placeholder autocorrection:(UITextAutocorrectionType)autocorrection numeric:(BOOL)numeric secure:(BOOL)secure;

@end
