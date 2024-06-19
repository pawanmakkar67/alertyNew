//
//  CustomSwitch.m
//  Alerty
//
//  Created by Ben Hassen on 2020. 08. 11..
//

#import "CustomSwitchBtn.h"

@implementation CustomSwitchBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [self initInternals];
        [self update];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self initInternals];
    }
    return self;
}

- (void) initInternals{
    self.onImage = [UIImage imageNamed:@"onSwitch"];
          self.offImage = [UIImage imageNamed:@"offSwitch"];
          self.statusBtn = NO;
}



/*- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setImage:self.offImage forState:UIControlStateNormal];
        [self setStatus:self.statusBtn];
    }
    return self;
}*/



- (void)setStatusBtn:(BOOL)status {
    if (self.statusBtn != status) {
        self.statusBtn = status;
        [self update];
    }
}

-(void) update{
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        self.statusBtn ? [self setImage:self.onImage forState:UIControlStateNormal] : [self setImage:self.offImage forState:UIControlStateNormal];
  } completion:nil];
}

-(void) toggle{
    self.statusBtn ? [self setStatusBtn:NO] : [self setStatusBtn:YES];
}

-(void) setStatus:(BOOL)status{
    self.statusBtn = status;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self toggle];
}

@end
