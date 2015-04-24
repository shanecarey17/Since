//
//  SinceLoadingView.m
//  Since
//
//  Created by Shane Carey on 4/23/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceLoadingView.h"

@implementation SinceLoadingView

- (id)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        [self draw];
    }
    return self;
}

- (void)draw {
    // Blurred background
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurredView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurredView.frame = self.bounds;
    [self addSubview:blurredView];
    
    // Circling arcs
    for (int i = 1; i <= 3; i++) {
        CAShapeLayer *circlingArc = [CAShapeLayer layer];
        circlingArc.frame = self.bounds;
        circlingArc.position = self.center;
        circlingArc.fillColor = [UIColor clearColor].CGColor;
        circlingArc.strokeColor = [UIColor colorWithWhite:0.95 alpha:0.95].CGColor;
        circlingArc.strokeEnd = i * 0.3;
        circlingArc.lineWidth = 20;
        UIBezierPath *circlingArcPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:30 * i startAngle:0 endAngle:2 * M_PI clockwise:YES];
        circlingArc.path = circlingArcPath.CGPath;
        [self.layer addSublayer:circlingArc];
        
        CABasicAnimation *spinningAnimation = [self spinningAnimationWithDuration:i * 2.0];
        [circlingArc addAnimation:spinningAnimation forKey:spinningAnimation.keyPath];
    }
}

- (CABasicAnimation *)spinningAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    return animation;
}

- (void)show {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    self.center = mainWindow.center;
    [mainWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished){
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self removeFromSuperview];
    }];
}


@end
