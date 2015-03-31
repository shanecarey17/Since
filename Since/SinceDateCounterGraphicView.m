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

#import "SinceDateCounterGraphicView.h"
#import "CountingLabel.h"

@interface SinceDateCounterGraphicView ()
{
    NSInteger numProgressShapes;
    CALayer *progressShapesLayer;
    CAShapeLayer *centerCircleLayer;
    CountingLabel *dayCountLabel;
}

@end

@implementation SinceDateCounterGraphicView

- (id)initWithSuperView:(UIView *)superview {
    CGRect frame = CGRectMake(0, 0, superview.bounds.size.width, superview.bounds.size.width);
    self = [super initWithFrame:frame];
    if (self) {
        // Layer of arcs
        progressShapesLayer = [[CALayer alloc] init];
        progressShapesLayer.bounds = self.frame;
        [self.layer addSublayer:progressShapesLayer];
        
        // Init the label
        dayCountLabel = [[CountingLabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 4, self.bounds.size.width / 6)];
        dayCountLabel.textAlignment = NSTextAlignmentCenter;
        dayCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.bounds.size.width / 6];
        dayCountLabel.textColor = [UIColor whiteColor];
        dayCountLabel.adjustsFontSizeToFitWidth = YES;
        dayCountLabel.numberOfLines = 0;
        [self addSubview:dayCountLabel];
        
        // Add self as subview
        [superview addSubview:self];
        self.center = superview.center;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    for (CALayer *subLayer in layer.sublayers) {
        // Every sublayer is centered in the view
        subLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    }
}

- (void)resetView:(NSArray *)sinceComponents colors:(NSDictionary *)colors {
    // The number of shapes to show is the number of non null entries in our components
    numProgressShapes = 0;
    for (NSObject *object in sinceComponents) {
        if (![object isEqual:[NSNull null]]) {
            numProgressShapes++;
        } else break;
    }
    
    // Cancel the current animation
    [self cancelArcAnimations];
    
    // Create the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.6f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // After the transaction we want to redraw our arcs (need to do this before adding animations to layer)
    [CATransaction setCompletionBlock:^{
        [self drawLayers:sinceComponents colors:colors];
    }];
    
    // During the transaction, add an animation to reset each arc to zero
    for (CAShapeLayer *layer in progressShapesLayer.sublayers) {
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
    
    // Count label
    [dayCountLabel countFromValue:0 toValue:[(NSNumber *)sinceComponents[0] integerValue] duration:3.0f];
}

- (void)cancelArcAnimations {
    CALayer *currentProgressShapesLayer = progressShapesLayer.presentationLayer;
    [progressShapesLayer removeAllAnimations];
    for (NSUInteger i = 0; i < progressShapesLayer.sublayers.count; i++) {
        CAShapeLayer *arcLayer = [progressShapesLayer.sublayers objectAtIndex:i];
        CAShapeLayer *presentingArcLayer = [currentProgressShapesLayer.sublayers objectAtIndex:i];
        arcLayer.strokeEnd = presentingArcLayer.strokeEnd;
    }
}

- (void)drawLayers:(NSArray *)sinceComponents colors:(NSDictionary *)colors {
    // Draw the shapes
    [self drawCenterCircle:colors[@"centerColor"]];
    
    // Remove arc layers
    progressShapesLayer.sublayers = nil;
    
    // Draw in our new shapes
    for (int i = 0; i < numProgressShapes - 1; i++) {
        [self drawArcWithProgress:[(NSNumber *)[sinceComponents objectAtIndex:i + 1] floatValue] index:i color:colors[@"arcColors"][i]];
    }
    
    // Layout arcs
    [self layoutSublayersOfLayer:progressShapesLayer];
    
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
    centerCircleLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    centerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
    centerCircleLayer.fillColor = color.CGColor;
    centerCircleLayer.lineWidth = 0.0f;
    centerCircleLayer.strokeEnd = 0.0f;
    [self.layer addSublayer:centerCircleLayer];
    
    // We want our cirle to be 1/6 the view, set radius
    CGPoint center = CGPointMake(progressShapesLayer.bounds.size.width / 2.f, progressShapesLayer.bounds.size.height / 2.f);
    NSInteger radius = self.bounds.size.width / 6;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    
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
    
    // Calculate the radius of the arc based on how many arcs there are
    NSInteger width = self.bounds.size.width;
    NSInteger innerRadius = width / 6;
    NSInteger outerRadius = width;
    NSInteger radius = -1 * ((2 * index + 1) * (innerRadius - outerRadius)) / (4 * (numProgressShapes + 1)) + innerRadius + 2;
    shapeLayer.lineWidth = ((outerRadius - innerRadius) / (numProgressShapes + 1) / 2) - 2;
    
    // Draw the path
    CGPoint center = CGPointMake(progressShapesLayer.bounds.size.width / 2.f, progressShapesLayer.bounds.size.height / 2.f);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    shapeLayer.path = path.CGPath;
    
    // Add to the layer of the view
    [progressShapesLayer addSublayer:shapeLayer];
    
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
