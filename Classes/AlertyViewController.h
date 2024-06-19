
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "GeoAddress.h"
#import "GWCall.h"
#import "GWManager.h"
#import "LockView.h"
#import "IsGdURLShortener.h"
#import "BaseViewController.h"

typedef enum {
    AlertyAlertStateCanSendAlert,
    AlertyAlertStateNoContacts,
    AlertyAlertStateNoPincode,
	AlertyAlertStateCannotSendAlert
} AlertyAlertState;

@interface AlertyViewController : BaseViewController
						/*LockViewDelegate,
						, 
						MFMailComposeViewControllerDelegate,
						MFMessageComposeViewControllerDelegate,
						URLShortenerDelegate,
						LockViewClosingViewDelegate,*/
						

@property (nonatomic, strong) LockView *lockView;


#pragma mark - IBActions
- (IBAction) wifiBtnPressed:(id)sender;

- (void) removeAlertView;
- (void) startSosMode:(NSNumber*)source lock:(BOOL)lock;
- (void) reloadFriends;
- (void) enableHeadsetForEmergency;
- (void) getInviteURLShortened;
- (void) startRecording;

- (void) displayRegistrationView;
- (void) displayLoginOrSubscribe;
- (void) showNetworkError:(BOOL)show;

- (void) updateManDown;
- (void) updateTimer;
- (void) updateHomeTimer;


- (void) followMeReceived:(NSString*)followMe userId:(NSString*)userId showFollowing:(BOOL)showFollowing;
- (void) startFollowMeMode:(NSString*) phoneNumber recipient:(NSString*)recipient;

#pragma mark - Static methods

+ (BOOL) canSendAlert;
+ (AlertyAlertState) alertyAlertState;

@end
