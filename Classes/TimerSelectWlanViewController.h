//
//  TimerSelectWlanViewController.h
//  Alerty
//
//  Created by Viking on 2018. 02. 08..
//

#import <UIKit/UIKit.h>

@class WifiAP;
@protocol TimerSelectWlanViewControllerDelegate

@required

- (void) wlanSelected:(WifiAP*)wifiap;

@end


@interface TimerSelectWlanViewController : UIViewController

@property (nonatomic, assign) id<TimerSelectWlanViewControllerDelegate> delegate;

@end
