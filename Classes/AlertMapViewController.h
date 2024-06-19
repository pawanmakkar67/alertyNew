//
//  AlertMapViewController.h
//  Alerty
//
//  Created by Mekom Ltd. on 04/04/14.
//
//

#import <UIKit/UIKit.h>

@interface AlertMapViewController : UIViewController

@property (assign, nonatomic) NSInteger alertID;
@property (strong, nonatomic) NSString* alertUserId;
@property (strong, nonatomic) NSString* alertUserName;
@property (strong, nonatomic) NSString* roomName;
@property (strong, nonatomic) NSString* token;
@property (assign, nonatomic) BOOL openAlert;
@property (strong, nonatomic) NSString* statusText;

@end
