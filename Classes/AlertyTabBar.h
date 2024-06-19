//
//  AlertyTabBar.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/29/13.
//
//

#import <UIKit/UIKit.h>

@class AlertyTabBar;

@protocol AlertyTabBarDelegate <NSObject>
@optional
- (void) didPressHomeButton:(AlertyTabBar*)tabBar;
- (void) didPressContactsButton:(AlertyTabBar*)tabBar;
- (void) didPressFunctionsButton:(AlertyTabBar*)tabBar;
- (void) didPressSettingsButton:(AlertyTabBar*)tabBar;
@end

@interface AlertyTabBar : UIView

@property (nonatomic, weak) id<AlertyTabBarDelegate> delegate;

+ (AlertyTabBar*) alertyTabBar;
- (void) selectTab:(NSInteger) index;

@end
