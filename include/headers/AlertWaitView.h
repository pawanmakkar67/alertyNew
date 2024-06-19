

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AlertWaitView : UIAlertView
{
	UIActivityIndicatorView *_activity;
}

- (id) initWithTitle:(NSString*)title message:(NSString*)message;

@end
