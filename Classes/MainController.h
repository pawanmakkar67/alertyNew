//
//  MainController.h
//  Alerty
//
//  Created by moni on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertyViewController.h"
#import "VideoListViewController.h"
#import "FunctionsViewController.h"
#import "ManDownView.h"
#import "AlertyTabBar.h"
#import <Speech/Speech.h>

@interface MainController : UITabBarController <UITextFieldDelegate,
											UIAlertViewDelegate,
											UITabBarControllerDelegate,
											ManDownViewDelegate,
											LockViewDelegate,
											AlertyTabBarDelegate,
											LockViewClosingViewDelegate,
                                            SFSpeechRecognizerDelegate> {
                                                SFSpeechRecognizer *speechRecognizer;
                                                SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
                                                SFSpeechRecognitionTask *recognitionTask;
                                                AVAudioEngine *audioEngine;
                                                AVAudioInputNode *inputNode;
                                            }

@property (nonatomic, strong) IBOutlet AlertyViewController  *alertyViewController;
@property (nonatomic, strong) AlertyTabBar *fakeTabBar;

- (BOOL) isManDownViewShowing;
- (void) showManDownView:(BOOL)timerAlarm;
- (void) showManDownViewHome:(BOOL)homeAlarm;


- (BOOL) isLockViewShowing;
- (void) showLockView:(BOOL)show activeText:(NSString *)activeText;
- (void) showSetPhoneNrAlert;

- (void) clearNetworkNotification;
- (void) addTimer:(NSDate*)date;

- (void) hideFunctions;

- (void) showIndoorLocation;

@end
