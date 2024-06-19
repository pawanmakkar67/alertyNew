//
//  TimerSelectLocationViewController.h
//  Alerty
//
//  Created by Viking on 2018. 02. 14..
//

#import <UIKit/UIKit.h>

@protocol TimerSelectLocationViewControllerDelegate

@required

- (void) locationSelected:(NSString*)location latitude:(double)latitude longitude:(double)longitude;

@end

@interface TimerSelectLocationViewController : UIViewController

@property (nonatomic, assign) id<TimerSelectLocationViewControllerDelegate> delegate;

@end
