//
//  StartViewController.m
//  Alerty
//
//  Created by Viking on 2017. 03. 24..
//
//

#import "StartViewController.h"
#import "SignInViewController.h"
#import "CreateAccountViewController.h"
#import "AlertyAppDelegate.h"

@interface StartViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *termsOfServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UIView *createAccountBlock;
@property (weak, nonatomic) IBOutlet UILabel *labelOr;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.createAccountButton.backgroundColor = COLOR_ACCENT;
    self.createAccountButton.layer.cornerRadius = 4.0;
    //self.signInButton.backgroundColor = COLOR_ACCENT;
    self.signInButton.layer.cornerRadius = 4.0;
    self.signInButton.layer.borderColor = REDESIGN_COLOR_BUTTON.CGColor;
    self.signInButton.layer.borderWidth = 1.0;
    
#if defined(OPUS) || defined(SAKERHETSAPPEN)
    self.labelOr.hidden = YES;
    self.createAccountBlock.hidden = YES;
#endif
    
    self.appName.text = NSLocalizedStringFromTable(@"Alerty", @"Target", @"");

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsTapped)];
    [self.termsOfServiceLabel addGestureRecognizer:tap];
    
    NSString* terms = NSLocalizedString(@"TERMS", @"");
#if defined(OPUS) || defined(SAKERHETSAPPEN)
    terms = [terms stringByReplacingOccurrencesOfString:@"Alerty" withString:NSLocalizedStringFromTable(@"Alerty", @"Target", @"")];
#endif
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:terms attributes:@{
                                                                                                NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                                                                NSForegroundColorAttributeName: [UIColor whiteColor]}];
    NSRange range = [terms rangeOfString:NSLocalizedStringFromTable(@"Alerty", @"Target", @"")];
    if (range.location != NSNotFound) {
        [title addAttribute:NSUnderlineStyleAttributeName value:@1 range:NSMakeRange(range.location, terms.length - range.location)];
    }
    self.termsOfServiceLabel.attributedText = title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createAccountPressed:(id)sender {
    CreateAccountViewController *createAccountViewController = [[CreateAccountViewController alloc] initWithNibName:@"CreateAccountViewController" bundle:nil];
    [self.navigationController pushViewController:createAccountViewController animated:YES];
}

- (IBAction)signInButtonPressed:(id)sender {
    SignInViewController *signInViewController = [[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil];
    [self.navigationController pushViewController:signInViewController animated:YES];
}

- (void) termsTapped {
    NSString *lang = [[AlertyAppDelegate language] substringToIndex:2];
    NSString *htmlPage = nil;
    if ([lang isEqualToString:@"sv"]) {
#ifdef OPUS
        htmlPage = @"https://sites.google.com/innovationpush.com/opuslf-anvandarvillkor/home";
#else
        htmlPage = @"https://www.getalerty.com/anvandarvillkor/?lang=sv";
#endif
    }
    else {
#ifdef OPUS
        htmlPage = @"https://sites.google.com/innovationpush.com/opuslf-toc/home";
#else
        htmlPage = @"https://www.getalerty.com/anvandarvillkor/?lang=en";
#endif
    }
}

@end
