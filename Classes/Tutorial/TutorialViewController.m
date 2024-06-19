
//
//  TutorialViewController.m
//  Alerty
//
//  Created by Viking on 2017. 03. 29..
//
//

#import "TutorialViewController.h"
#import "AlertyAppDelegate.h"

@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pressAndHoldLeadingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        self.pressAndHoldLeadingConstraint.constant = 0;
    }
    
    /*NSString* next = [NSLocalizedString(@"NEXT", @"") uppercaseString];
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:next attributes:@{
                                                                                                            NSFontAttributeName : self.nextLabel.font,
                                                                                                            NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [title addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(0, next.length - 2)];*/
    self.nextBtn.layer.cornerRadius = 4.0;
    self.nextBtn.layer.borderWidth = 1.0;
    self.nextBtn.layer.borderColor = UIColor.whiteColor.CGColor;
    [self.nextBtn setTitle:NSLocalizedString(@"NEXT", @"") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissGuid:(id)sender {
    self.completion();
}

- (IBAction)nextPressed:(id)sender {
    self.index++;
    if (self.index == 3) {
        self.completion();
    } else {
        [self showPage];
    }
}

- (void) showPage {
    self.firstView.hidden = (self.index != 0);
    self.secondView.hidden = (self.index != 1);
    self.thirdView.hidden = (self.index != 2);
}

@end
