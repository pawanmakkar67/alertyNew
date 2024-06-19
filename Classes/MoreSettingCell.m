//
//  MoreSettingCell.m
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 07..
//

#import "MoreSettingCell.h"
#import "AlertySettingsMgr.h"

@import Photos;

@interface MoreSettingCell() <UITextFieldDelegate>

@property (weak, nonatomic) UITextField* pinTextField;

@end

@implementation MoreSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    /*[self.switchBtn setOffImage:[UIImage imageNamed:@"offSwitch"]];
    [self.switchBtn setOnImage:[UIImage imageNamed:@"onSwitch"]];*/

    /*self.switchBtn.onTintColor = REDESIGN_COLOR_CANCEL;
    self.switchBtn.tintColor = REDESIGN_COLOR_CANCEL;
    self.switchBtn.thumbTintColor = REDESIGN_COLOR_GREEN;
    self.switchBtn.backgroundColor = UIColor.clearColor;*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setCell:(NSInteger)row title:(NSString*) title {

    self.labelTxt.text = title;
    if (row <= 6 ){
        switch (row) {
            case 0:
                //last_known_position

                if ([AlertySettingsMgr lastPositionEnabled] == NO){
                    [self setOffTint];
                }else{
                    [self setOnTint];
                }
                [self.switchBtn setOn:[AlertySettingsMgr lastPositionEnabled]];

                [self.switchBtn addTarget:self action:@selector(lastPositionDidChange:) forControlEvents:UIControlEventValueChanged];
               // [self.customSwitch setStatus:YES];
                //self.customSwitch.status = NO;
                self.switchBtn.tag = row;


                break;
            case 1:
                //Discrete mode
                if ([AlertySettingsMgr discreteModeEnabled] == NO){
                    [self setOffTint];
                }else{
                    [self setOnTint];
                }
                [self.switchBtn setOn:[AlertySettingsMgr discreteModeEnabled]];
                //[self.customSwitch setStatusBtn:[AlertySettingsMgr discreteModeEnabled]];
                self.switchBtn.tag = row;

                [self.switchBtn addTarget:self action:@selector(discreteDidChange:) forControlEvents:UIControlEventValueChanged];
                //[self.customSwitch addTarget:self action:@selector(discreteDidChange:) forControlEvents:UIControlEventValueChanged];


                break;
            case 2:
                //Tracking
                if ([AlertySettingsMgr trackingEnabled] == NO){
                    [self setOffTint];
                }else{
                    [self setOnTint];
                }

                [self.switchBtn setOn:[AlertySettingsMgr trackingEnabled]];
                self.switchBtn.tag = row;

                [self.switchBtn addTarget:self action:@selector(trackingDidChange:) forControlEvents:UIControlEventValueChanged];

                break;
            case 3:
                //Switch to Front Facing Camera
                if ([AlertySettingsMgr frontCameraEnabled] == NO) {
                    [self setOffTint];
                }else{
                    [self setOnTint];
                }
                [self.switchBtn setOn:[AlertySettingsMgr frontCameraEnabled]];
                self.switchBtn.tag = row;

                [self.switchBtn addTarget:self action:@selector(frontCameraDidChange:) forControlEvents:UIControlEventValueChanged];

                break;
            case 4:
                //Upload last screenshot on alert
                if ([AlertySettingsMgr screenshotEnabled] == NO) {
                    [self setOffTint];
                }else{
                    [self setOnTint];
                }
                [self.switchBtn setOn:[AlertySettingsMgr screenshotEnabled]];
                self.switchBtn.tag = row;

                [self.switchBtn addTarget:self action:@selector(screenshotDidChange:) forControlEvents:UIControlEventValueChanged];
                break;
            case 5:
                //Speakerphone
                if ([AlertySettingsMgr speakerEnabled] == NO) {
                    [self setOffTint];
                }else{
                    [self setOnTint];
                }
                [self.switchBtn setOn:[AlertySettingsMgr speakerEnabled]];
                self.switchBtn.tag = row;

                [self.switchBtn addTarget:self action:@selector(speakerDidChange:) forControlEvents:UIControlEventValueChanged];
                break;
            case 6:
                //Use pin
                if (!AlertySettingsMgr.usePIN) {
                    [self setOffTint];
                } else {
                    [self setOnTint];
                }
                [self.switchBtn setOn:AlertySettingsMgr.usePIN];
                self.switchBtn.tag = row;
                [self.switchBtn addTarget:self action:@selector(usePinDidChange:) forControlEvents:UIControlEventValueChanged];
                break;
            default:
                break;
        }
        [self.switchBtn setHidden:NO];
        [self.arrow setHidden:YES];
    }else if (row <= 9){
        [self.switchBtn setHidden:YES];
        [self.arrow setHidden:NO];
    }else{
        [self.switchBtn setHidden:YES];
        [self.arrow setHidden:YES];
        if(row == 13){
            [self.seperator setHidden:YES];
        }
    }
}


#pragma mark - UIButton target handlers


-(void) lastPositionDidChange:(id)sender {
    if (self.switchBtn.on) {
        [self setOnTint];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"last_known_position", @"") message:NSLocalizedString(@"settings_last_known_position_alert", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.switchBtn.on = NO;
            [self setOffTint];

        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AlertySettingsMgr setLastPositionEnabled:YES];
        }]];
        [self.alertDelegate presentViewController:alert animated:YES completion:nil];
    } else {
        [self setOffTint];
        [AlertySettingsMgr setLastPositionEnabled:NO];
    }
}

-(void) trackingDidChange:(id)sender {
    NSLog(@"btn%ld",(long)self.switchBtn.tag);
    if (self.switchBtn.on) {
        [self setOnTint];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tracking", @"") message:NSLocalizedString(@"Your route will be temporarily stored in the phone memory to be displayed if the alert is activated.", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.switchBtn.on = NO;
            [self setOffTint];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AlertySettingsMgr setTrackingEnabled:YES];
        }]];
        [self.alertDelegate presentViewController:alert animated:YES completion:nil];
    } else {
        [self setOffTint];
        [AlertySettingsMgr setTrackingEnabled:NO];
    }
}

- (void)setOnTint {
    self.switchBtn.onTintColor = REDESIGN_COLOR_CANCEL;
    self.switchBtn.tintColor = REDESIGN_COLOR_CANCEL;
    self.switchBtn.thumbTintColor = REDESIGN_COLOR_GREEN;
}

- (void)setOffTint {
    self.switchBtn.onTintColor = REDESIGN_COLOR_CANCEL;
    self.switchBtn.tintColor = REDESIGN_COLOR_CANCEL;
    self.switchBtn.thumbTintColor = UIColor.whiteColor;
}

-(void) discreteDidChange:(id)sender {

    if (self.switchBtn.on) {
        [self setOnTint];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Discrete mode", @"") message:NSLocalizedString(@"Discrete mode will disable notifications", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.switchBtn.on = NO;
            [self setOffTint];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AlertySettingsMgr setDiscreteModeEnabled:YES];
        }]];
        [self.alertDelegate presentViewController:alert animated:YES completion:nil];
    } else {
        [self setOffTint];
        [AlertySettingsMgr setDiscreteModeEnabled:NO];
    }
}

-(void) frontCameraDidChange:(id)sender {
    if (self.switchBtn.on) {
        [self setOnTint];

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Camera", @"") message:NSLocalizedString(@"Alerty will use Front-facing camera as default.", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.switchBtn.on = NO;
            [self setOffTint];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AlertySettingsMgr setFrontCameraEnabled:YES];
        }]];
        [self.alertDelegate presentViewController:alert animated:YES completion:nil];
    } else {
        [self setOffTint];
        [AlertySettingsMgr setFrontCameraEnabled:NO];
        //[[AlertyAppDelegate sharedAppDelegate] updateFrontCameraOnPebble]; ???
    }
}

-(void) screenshotDidChange:(id)sender {
    BOOL on = self.switchBtn.on;
    if (on) {
        [self setOnTint];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [AlertySettingsMgr setScreenshotEnabled:YES];
            } else {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    self.switchBtn.on = NO;
                    [self setOffTint];
                }];
            }
        }];
    } else {
        [self setOffTint];
        [AlertySettingsMgr setScreenshotEnabled:NO];
    }
}

-(void) speakerDidChange:(id)sender {
    if (self.switchBtn.on) {
        [self setOnTint];
    }else{
        [self setOffTint];
    }

    [AlertySettingsMgr setSpeakerEnabled:self.switchBtn.on];
}

-(void) usePinDidChange:(id)sender {
    if (self.switchBtn.on) {
        [self setOnTint];
    }else{
        [self setOffTint];
    }

    //[AlertySettingsMgr setSpeakerEnabled:self.switchBtn.on];
    
    if (self.switchBtn.on) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"LOGIN_PIN_ALERT", @"") preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = NSLocalizedString(@"Use PIN", @"");
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.delegate = self;
            textField.text = self.pinTextField.text;
            self.pinTextField = textField;
        }];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.switchBtn.on = NO;
            [self setOffTint];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.pinTextField.text.length != 4) {
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:@"4 characters required" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self usePinDidChange:self.switchBtn];
                }]];
                [self.alertDelegate presentViewController:alertController animated:YES completion:nil];
            } else {
                [AlertySettingsMgr setUsePIN:YES];
                [AlertySettingsMgr setUserPIN:self.pinTextField.text];
                [DataManager.sharedDataManager storeUserSettings:nil pin:self.pinTextField.text];
            }
        }]];
        [self.alertDelegate presentViewController:alert animated:YES completion:nil];
    } else {
        [AlertySettingsMgr setUsePIN:NO];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.pinTextField) {
        return [textField.text length] + [string length] <= 4;
    }
    return YES;
}

@end
