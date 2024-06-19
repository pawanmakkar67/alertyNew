//
//  LockViewClosingView.h
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/4/13.
//
//

#import <UIKit/UIKit.h>

@protocol LockViewClosingViewDelegate <NSObject>
- (void) didUnlockLocker;
- (void) didCancelLockView;
@end

@interface LockViewClosingView : UIView

@property (nonatomic, weak) id<LockViewClosingViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *pincodeTitleLabel;
@property (nonatomic, strong) IBOutlet UIView *cancellerView;
@property (nonatomic, strong) IBOutlet UITextField *dummyField;
@property (nonatomic, strong) IBOutlet UITextField *firstDigit;
@property (nonatomic, strong) IBOutlet UITextField *secondDigit;
@property (nonatomic, strong) IBOutlet UITextField *thirdDigit;
@property (nonatomic, strong) IBOutlet UITextField *fourthDigit;
@property (strong, nonatomic) IBOutlet UIView *wrongPinView;

- (IBAction) cancelStoping:(UIGestureRecognizer *)sender;

+ (LockViewClosingView*) lockViewClosingView;
+ (NSString *) strip:(NSString *)receiver;

- (void) resetState;
- (BOOL) canUnlockWithPin:(NSString*)pinCode;

@end
