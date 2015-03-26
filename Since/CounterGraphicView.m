//
//  CounterGraphicView.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define   PI 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((PI * degrees)/ 180)
#define   RAND_FLOAT ((double)arc4random() / 0x100000000)

#import "CounterGraphicView.h"
#import "CountingLabel.h"

@interface CounterGraphicView ()
{
    NSInteger numProgressShapes;
    NSMutableArray *progressShapes;
    CAShapeLayer *centerCircleLayer;
    CountingLabel *dayCountLabel;
}

@end

@implementation CounterGraphicView

- (id)initWithSuperView:(UIView *)superview {
    CGRect frame = CGRectMake(0, 0, superview.bounds.size.width, superview.bounds.size.width);
    self = [super initWithFrame:frame];
    if (self) {
        // Array of shapes
        progressShapes = [[NSMutableArray alloc] init];
        
        // Init the label
        dayCountLabel = [[CountingLabel alloc] init];
        dayCountLabel.textAlignment = NSTextAlignmentCenter;
        dayCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.bounds.size.width / 6];
        dayCountLabel.textColor = [UIColor whiteColor];
        dayCountLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:dayCountLabel];
        
        // Add self as subview
        [superview addSubview:self];
        self.center = superview.center;
    }
    return self;
}

- (void)layoutSubviews {
    // Strange ui layout things going on here
    self.layer.bounds = self.frame;
    dayCountLabel.center = self.center;
}

- (void)resetView:(NSArray *)sinceComponents colors:(NSDictionary *)colors {
    // The number of shapes to show is the number of non null entries in our components
    numProgressShapes = 0;
    for (NSObject *object in sinceComponents) {
        if (![object isEqual:[NSNull null]]) {
            numProgressShapes++;
        } else break;
    }
    
    // Create the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.6f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // After the transaction we want to redraw our arcs (need to do this before adding animations to layer)
    [CATransaction setCompletionBlock:^{
        [self drawLayers:sinceComponents colors:colors];
    }];
    
    // During the transaction, add an animation to reset each arc to zero
    for (CAShapeLayer *layer in progressShapes) {
        CABasicAnimation *toZeroAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        toZeroAnimation.fromValue = @(layer.strokeEnd);
        toZeroAnimation.toValue = @0.0f;
        toZeroAnimation.duration = 0.6f;
        toZeroAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        toZeroAnimation.fillMode = kCAFillModeBoth;
        toZeroAnimation.removedOnCompletion = NO;
        [layer addAnimation:toZeroAnimation forKey:toZeroAnimation.keyPath];
    }
    
    // Commit the transaction
    [CATransaction commit];
    
    // Count
    [dayCountLabel countFromValue:0 toValue:[(NSNumber *)sinceComponents[0] integerValue] duration:3.0f];
    
    // And the center circle
    UIColor *newFillColor = [colors objectForKey:@"centerColor"];
    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColorAnimation.fromValue = (id)centerCircleLayer.fillColor;
    fillColorAnimation.toValue = (id)newFillColor.CGColor;
    fillColorAnimation.duration = 3.0f;
    fillColorAnimation.fillMode = kCAFillModeForwards;
    fillColorAnimation.removedOnCompletion = NO;
    centerCircleLayer.fillColor = newFillColor.CGColor;
    [centerCircleLayer addAnimation:fillColorAnimation forKey:fillColorAnimation.keyPath];
    
    // And the background of the superview
    UIColor *newBackgroundColor = [colors objectForKey:@"backgroundColor"];
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.fromValue = (id)self.superview.backgroundColor.CGColor;
    backgroundColorAnimation.toValue = (id)newBackgroundColor.CGColor;
    backgroundColorAnimation.duration = 3.0f;
    backgroundColorAnimation.fillMode = kCAFillModeForwards;
    backgroundColorAnimation.removedOnCompletion = NO;
    self.superview.backgroundColor = (id)newBackgroundColor;
    [self.superview.layer addAnimation:backgroundColorAnimation forKey:backgroundColorAnimation.keyPath];
}

- (void)drawLayers:(NSArray *)sinceComponents colors:(NSDictionary *)colors {
    // Draw the shapes
    [self drawCenterCircle:colors[@"centerColor"]];
    
    // Remove layers if we need to
    for (CALayer *layer in progressShapes) {
        [layer removeFromSuperlayer];
    }
    
    // Draw in our new shapes
    for (int i = 0; i < numProgressShapes - 1; i++) {
        [self drawArcWithProgress:[(NSNumber *)[sinceComponents objectAtIndex:i + 1] floatValue] index:i color:colors[@"arcColors"][i]];
    }
    
    // Bring the label to the front
    [self bringSubviewToFront:dayCountLabel];
}

- (void)drawCenterCircle:(UIColor *)color {
    // If the circle exists don't draw it again
    if (centerCircleLayer != nil) {
        return;
    }
    
    // Create the circle
    centerCircleLayer = [[CAShapeLayer alloc] init];
    centerCircleLayer.bounds = self.bounds;
    centerCircleLayer.position = self.center;
    centerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
    centerCircleLayer.fillColor = color.CGColor;
    centerCircleLayer.lineWidth = 0.0f;
    centerCircleLayer.strokeEnd = 0.0f;
    [self.layer addSublayer:centerCircleLayer];
    
    // We want our cirle to be 1/6 the view, set radius
    NSInteger radius = self.bounds.size.width / 6;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius                                                   startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    
    // Assign the circle
    centerCircleLayer.path = path.CGPath;
}

- (void)drawArcWithProgress:(float)progress index:(NSInteger)index color:(UIColor *)color {
    // New shape layer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.bounds = self.bounds;
    shapeLayer.position = self.center;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeEnd = 0.0f;
    shapeLayer.strokeColor = color.CGColor;
    
    // Add to the layer of the view
    [self.layer addSublayer:shapeLayer];
    [progressShapes addObject:shapeLayer];
    
    // Calculate the radius of the arc based on how many arcs there are
    NSInteger width = self.bounds.size.width;
    NSInteger innerRadius = width / 6;
    NSInteger outerRadius = width;
    NSInteger radius = -1 * ((2 * index + 1) * (innerRadius - outerRadius)) / (4 * (numProgressShapes + 1)) + innerRadius + 2;
    shapeLayer.lineWidth = ((outerRadius - innerRadius) / (numProgressShapes + 1) / 2) - 2;
    
    // Draw the path
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius                                                   startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    shapeLayer.path = path.CGPath;
    
    // Configure the animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = 3.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    shapeLayer.strokeEnd = progress;
    [shapeLayer addAnimation:animation forKey:animation.keyPath];
}

@end
