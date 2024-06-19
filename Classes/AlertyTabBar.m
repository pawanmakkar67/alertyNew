//
//  AlertyTabBar.m
//  Alerty
//
//  Created by Laszlo Zavaleta on 1/29/13.
//
//

#import "AlertyTabBar.h"
#import "NSBundleAdditions.h"

@interface AlertyTabBar()

@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIButton *contactsButton;
@property (strong, nonatomic) IBOutlet UIButton *functionsButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation AlertyTabBar

@synthesize delegate = _delegate;

+ (AlertyTabBar*) alertyTabBar {
	return (AlertyTabBar*)[NSBundle loadFirstFromNib:@"AlertyTabBar"];
}

- (IBAction)didPressHomeButton:(id)sender {
	if( [self.delegate respondsToSelector:@selector(didPressHomeButton:)] ) {
		[self.delegate didPressHomeButton:self];
	}
	[self performSelector:@selector(selectButton:) withObject:sender afterDelay:0.01];
}

- (IBAction)didPressContactsButton:(id)sender {
	if( [self.delegate respondsToSelector:@selector(didPressContactsButton:)] ) {
		[self.delegate didPressContactsButton:self];
	}
	[self performSelector:@selector(selectButton:) withObject:sender afterDelay:0.01];
}

- (IBAction)didPressFunctionsButton:(id)sender {
    if( [self.delegate respondsToSelector:@selector(didPressFunctionsButton:)] ) {
        [self.delegate didPressFunctionsButton:self];
    }
    [self performSelector:@selector(selectButton:) withObject:sender afterDelay:0.01];
}

- (IBAction)didPressSettingsButton:(id)sender {
	if( [self.delegate respondsToSelector:@selector(didPressSettingsButton:)] ) {
		[self.delegate didPressSettingsButton:self];
	}
	[self performSelector:@selector(selectButton:) withObject:sender afterDelay:0.01];
}

- (void) selectButton:(id)sender {
	self.homeButton.selected = NO;
	self.contactsButton.selected = NO;
	self.functionsButton.selected = NO;
	self.settingsButton.selected = NO;
	[sender setSelected:YES];
}

- (void) selectTab:(NSInteger) index {
    self.homeButton.selected = (index == 0);
    self.contactsButton.selected = (index == 1);
    self.functionsButton.selected = (index == 2);
    self.settingsButton.selected = (index == 3);
}

@end
