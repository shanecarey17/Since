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
#import "ColorSchemes.h"

@interface SinceDateCounterGraphicView () {
    NSInteger numProgressShapes;
    CALayer *progressShapesLayer;
    CAShapeLayer *centerCircleLayer;
    CountingLabel *dayCountLabel;
}

@end

@implementation SinceDateCounterGraphicView

- (id)initWithFrame:(CGRect)frame {
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
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    for (CALayer *subLayer in layer.sublayers) {
        // Every sublayer is centered in the view
        subLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    }
}

- (void)resetView:(NSDate *)sinceDate colors:(NSString *)colorScheme {
    // Get the components from the date
    NSArray *sinceComponents = [self componentsArrayWithDate:sinceDate];
    NSDictionary *colors = [ColorSchemes colorSchemeWithName:colorScheme];
    
    // Reset the arcs
    [self resetArcs:sinceComponents colors:colors];
    
    // Set other colors
    [self changeCenterAndBackgroundColor:colors];
    
    // Count label down
    [dayCountLabel countToValue:0 duration:0.6f timing:CountingLabelTimingFunctionEaseIn];
}

- (NSArray *)componentsArrayWithDate:(NSDate *)date {
    NSInteger intervalSinceDate = (NSInteger)[[NSDate date] timeIntervalSinceDate:date];
    NSMutableArray *componentsArr = [[NSMutableArray alloc] init];
    // Day count is the first entry in the array
    [componentsArr addObject:@(intervalSinceDate / 86400)];
    // Day percentage
    [componentsArr addObject:@(intervalSinceDate % 86400 / 86400.f)];
    // Week percentage
    [componentsArr addObject:intervalSinceDate > 86400 ? @(intervalSinceDate % 604800 / 604800.f) : [NSNull null]];
    // Month percentage
    [componentsArr addObject:intervalSinceDate > 604800 ? @(intervalSinceDate % 2592000 / 2592000.f) : [NSNull null]];
    // Year percentage
    [componentsArr addObject:intervalSinceDate > 2592000 ? @(intervalSinceDate % 31536000 / 31536000.f) : [NSNull null]];
    // 2 year percentage
    [componentsArr addObject:intervalSinceDate > 31536000 ? @(intervalSinceDate % 63072000 / 63072000.f) : [NSNull null]];
    // 5 year percentage
    [componentsArr addObject:intervalSinceDate > 63072000 ? @(intervalSinceDate % 157680000 / 157680000.f) : [NSNull null]];
    // 10 year percentage
    [componentsArr addObject:intervalSinceDate > 157680000 ? @(intervalSinceDate % 315360000 / 315360000.f) : [NSNull null]];
    
    // Set internal variables with array
    numProgressShapes = 0;
    for (NSObject *object in componentsArr) {
        if (![object isEqual:[NSNull null]]) {
            numProgressShapes++;
        } else break;
    }
    
    // Return a hard copy of the array
    return [NSArray arrayWithArray:componentsArr];
}

- (void)resetArcs:(NSArray *)components colors:(NSDictionary *)colors {
    // Cancel the current animation and disable interaction
    [self cancelArcAnimations];
    self.userInteractionEnabled = NO;
    
    // Create the transaction
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.6f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // After the transaction we want to redraw our arcs (need to do this before adding animations to layer)
    [CATransaction setCompletionBlock:^{
        [self drawLayers:components colors:colors];
        // Count up
        [dayCountLabel countFromValue:0 toValue:[(NSNumber *)components[0] integerValue] duration:3.0f timing:CountingLabelTimingFunctionEaseOut];
        // Now we can tap again
        self.userInteractionEnabled = YES;
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
}

- (void)changeCenterAndBackgroundColor:(NSDictionary *)colors {
    // Cancel and animate color of background circle
    CAShapeLayer *centerCirclePresentationLayer = centerCircleLayer.presentationLayer;
    [centerCircleLayer removeAllAnimations];
    centerCircleLayer.fillColor = centerCirclePresentationLayer.fillColor;
    
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
    CALayer *backgroundPresentationLayer = self.superview.layer.presentationLayer;
    [self.superview.layer removeAllAnimations];
    self.superview.layer.backgroundColor = backgroundPresentationLayer.backgroundColor;
    
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
    // Draw the center circle if it doesn't exist
    if (centerCircleLayer == nil) {
        [self drawCenterCircle:colors[@"centerColor"]];
    }
    
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
