//
//  HoshiTextField.m
//  CCTextFieldEffects
//
//  Created by Kelvin on 6/25/16.
//  Copyright © 2016 Cokile. All rights reserved.
//

#import "HoshiTextField.h"
#import "AlertyAppDelegate.h"

@interface HoshiTextField ()

@property (strong, nonatomic) CALayer *inactiveBorderLayer;
@property (strong, nonatomic) CALayer *activeBorderLayer;
@property (nonatomic) CGPoint activePlaceholderPoint;

@end

@implementation HoshiTextField

#pragma mark - Constants
static CGFloat const activeBorderThickness = 2;
static CGFloat const inactiveBorderThickness = 0.7;
static CGPoint const textFieldInsets = {0, 12};
static CGPoint const placeholderInsets = {0, 6};

#pragma mark - Custom accessorys

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholder];
}

- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    
    [self updateBorder];
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    
    [self updateBorder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    [self updateBorder];
    [self updatePlaceholder];
}

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.inactiveBorderLayer = [[CALayer alloc] init];
    self.activeBorderLayer = [[CALayer alloc] init];
    self.placeholderLabel = [[UILabel alloc] init];    
    
    self.borderInactiveColor = COLOR_INACTIVE_BORDER;
    self.borderActiveColor = COLOR_ACCENT;
    self.placeholderColor = UIColor.grayColor;
    self.cursorColor = COLOR_GRAY_CURSOR;
    self.textColor = [UIColor colorNamed:@"color_text"];
    
    self.placeholderFontScale = 0.90;
    self.activePlaceholderPoint = CGPointZero;
}

#pragma mark - Overridden methods
- (void)drawRect:(CGRect)rect {
    CGRect frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y);
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    
    [self updateBorder];
    [self updatePlaceholder];
    
    [self.layer addSublayer:self.inactiveBorderLayer];
    [self.layer addSublayer:self.activeBorderLayer];
    [self addSubview:self.placeholderLabel];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectOffset(bounds, textFieldInsets.x, textFieldInsets.y);
}

- (void)animateViewsForTextEntry {
    if (self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.placeholderLabel.frame = CGRectMake(10, self.placeholderLabel.frame.origin.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
            self.placeholderLabel.alpha = 0;
        } completion:^(BOOL finished) {
            if (self.didBeginEditingHandler != nil) {
                self.didBeginEditingHandler();
            }
        }];
    }
    
    [self layoutPlaceholderInTextRect];
    self.placeholderLabel.frame = CGRectMake(self.activePlaceholderPoint.x, self.activePlaceholderPoint.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
    
    [UIView animateWithDuration:0.2 animations:^{
        self.placeholderLabel.alpha = 0.5;
    }];
    
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:YES];
}

- (void)animateViewsForTextDisplay {
    if (self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutPlaceholderInTextRect];
            self.placeholderLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (self.didEndEditingHandler != nil) {
                self.didEndEditingHandler();
            }
        }];
        
        self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:NO];
    }
}

#pragma mark - Private methods
- (void)updateBorder{
    self.inactiveBorderLayer.frame = [self rectForBorderThickness:inactiveBorderThickness isFilled:YES];
    self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor.CGColor;
    
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:NO];
    self.activeBorderLayer.backgroundColor = self.borderActiveColor.CGColor;
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = self.placeholderColor;
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if ([self isFirstResponder] || self.text.length!=0) {
        [self animateViewsForTextEntry];
    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    //UIFont *smallerFont = [UIFont fontWithName:font.fontName size:font.pointSize*self.placeholderFontScale];
    UIFont* smallerFont = [UIFont systemFontOfSize:font.pointSize*self.placeholderFontScale weight:UIFontWeightSemibold];
    return smallerFont;
}

- (CGRect)rectForBorderThickness:(CGFloat)thickness isFilled:(BOOL)isFilled {
    if (isFilled) {
        return CGRectMake(0, CGRectGetHeight(self.frame)-thickness, CGRectGetWidth(self.frame), thickness);
    } else {
        return CGRectMake(0, CGRectGetHeight(self.frame)-thickness, 0, thickness);
    }
}

- (void)layoutPlaceholderInTextRect {
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = textRect.origin.x;
    
    switch (self.textAlignment) {
        case NSTextAlignmentCenter:
            originX += textRect.size.width/2-self.placeholderLabel.bounds.size.width/2;
            break;
        case NSTextAlignmentRight:
            originX += textRect.size.width-self.placeholderLabel.bounds.size.width;
            break;
        default:
            break;
    }
    
    self.placeholderLabel.frame = CGRectMake(originX, textRect.size.height/2, CGRectGetWidth(self.placeholderLabel.bounds), CGRectGetHeight(self.placeholderLabel.bounds));
    self.activePlaceholderPoint = CGPointMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y-self.placeholderLabel.frame.size.height-placeholderInsets.y);
}

@end
