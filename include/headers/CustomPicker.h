//
//  CustomPicker.h
//
//  Created by Bence Balint on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomPicker : UIView
{
}

@property (retain,nonatomic) IBOutlet id generalPicker;
@property (retain,nonatomic) IBOutlet UIView *headerView;
@property (retain,nonatomic) IBOutlet UIImageView *headerBackground;
@property (retain,nonatomic) IBOutlet UILabel *titleLabel;
@property (retain,nonatomic) IBOutlet UILabel *valueLabel;
@property (retain,nonatomic) IBOutlet UIToolbar *buttonBar;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *okButtonItem;
@property (retain,nonatomic) IBOutlet UIBarButtonItem *fixedOffsetItem;
@property (retain,nonatomic) IBOutlet UIButton *okButton;
@property (retain,nonatomic) IBOutlet UIImageView *pickerFrame;

+ (CustomPicker*) generalPicker:(id)target action:(SEL)action;
+ (CustomPicker*) datePicker:(id)target action:(SEL)action;

- (void) setTitle:(NSString*)title;
- (void) setValue:(NSString*)value;

- (BOOL) isShown;
- (void) showFromBottom:(BOOL)show inView:(UIView*)view animated:(BOOL)animated;

- (IBAction)doneButtonPressed:(id)sender;

@end


@interface CustomPicker ()
- (void) initInternals;
- (void) layoutHeaderItems;
@end
