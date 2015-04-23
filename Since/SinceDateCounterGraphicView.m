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
    CALayer *progressShapesLayer;
    CAShapeLayer *centerCircleLayer;
    CAShapeLayer *arrowLayer;
    
    CountingLabel *dayCountLabel;
    
    NSUInteger _timer_sem;
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
        
        // Layers
        [self drawCenterCircle];
        [self drawArrow];
        
        // Init the label
        dayCountLabel = [[CountingLabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 4, self.bounds.size.width / 6)];
        dayCountLabel.textAlignment = NSTextAlignmentCenter;
        dayCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.bounds.size.width / 6];
        dayCountLabel.textColor = [UIColor whiteColor];
        dayCountLabel.adjustsFontSizeToFitWidth = YES;
        dayCountLabel.numberOfLines = 0;
        [self addSubview:dayCountLabel];
        
        // Timer
        [self setTimer];
    }
    return self;
}

#pragma mark - Drawing

- (void)drawLayersWithColors:(NSDictionary *)colors numArcs:(NSUInteger)numArcs {
    // Draw the center circle if it doesn't exist
    if (centerCircleLayer == nil) {
        
    }
    
    // Remove arc layers
    progressShapesLayer.sublayers = nil;
    
    // Draw in our new shapes
    NSInteger width = self.bounds.size.width;
    NSInteger innerRadius = width / 6;
    NSInteger outerRadius = width;
    for (int i = 0; i < numArcs - 1; i++) {
        CGFloat radius = -1 * ((2 * i + 1) * (innerRadius - outerRadius)) / (4 * (numArcs + 1)) + innerRadius + 2;
        CGFloat lineWidth = ((outerRadius - innerRadius) / (numArcs + 1) / 2) - 2;
        [self drawArcWithRadius:radius width:lineWidth color:colors[@"arcColors"][i]];
    }
    
    // Layout arcs
    [self layoutSublayersOfLayer:progressShapesLayer];
}

- (void)drawArcWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color {
    // New shape layer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.bounds = self.bounds;
    shapeLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeEnd = 0.0f;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = width;
    
    // Draw the path
    CGPoint center = CGPointMake(progressShapesLayer.bounds.size.width / 2.f, progressShapesLayer.bounds.size.height / 2.f);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    shapeLayer.path = path.CGPath;
    
    // Add to the layer of the view
    [progressShapesLayer addSublayer:shapeLayer];
}

- (void)drawCenterCircle {
    // Create the circle
    centerCircleLayer = [[CAShapeLayer alloc] init];
    centerCircleLayer.bounds = self.bounds;
    centerCircleLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    centerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
    
    // We want our cirle to be 1/6 the view, set radius
    CGPoint center = CGPointMake(progressShapesLayer.bounds.size.width / 2.f, progressShapesLayer.bounds.size.height / 2.f);
    NSInteger radius = self.bounds.size.width / 6;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    
    // Assign the circle
    centerCircleLayer.path = path.CGPath;
    
    [self.layer addSublayer:centerCircleLayer];
}

- (void)drawArrow {
    // Create arrow
    arrowLayer = [[CAShapeLayer alloc] init];
    arrowLayer.bounds = self.bounds;
    arrowLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    arrowLayer.fillColor = [UIColor clearColor].CGColor;
    arrowLayer.strokeColor = [UIColor whiteColor].CGColor;
    arrowLayer.lineWidth = 2.0;
    
    UIBezierPath *arrowPath = [[UIBezierPath alloc] init];
    [arrowPath moveToPoint:CGPointZero];
    [arrowPath addLineToPoint:CGPointZero];
    [arrowPath addLineToPoint:CGPointZero];
    
    arrowLayer.path = arrowPath.CGPath;
    
    [self.layer addSublayer:arrowLayer];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    for (CALayer *subLayer in layer.sublayers) {
        // Every sublayer is centered in the view
        subLayer.position = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    }
}

#pragma mark - Timer

- (void)setTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(increment:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)increment:(NSTimer *)timer {
    // We will only increment if there are no continuing animations
    if (_timer_sem == 0) {
        NSArray *components = [self componentsArrayWithDate:_date];
        
        if (components.count - 1 != progressShapesLayer.sublayers.count) {
            // We need to redraw
            [self drawLayersWithColors:_colorScheme numArcs:components.count];
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.5];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setCompletionBlock:^{
            dayCountLabel.text = [NSString stringWithFormat:@"%ld", (long)[(NSNumber *)components[0] integerValue]];
        }];
        [self setArcsToProgress:components duration:0.9];
        [CATransaction commit];
    }
}

#pragma mark - Reset

- (void)resetView:(NSDate *)sinceDate colors:(NSString *)colorScheme {
    // Set date
    _date = sinceDate;
    
    // Increase timer semapore
    _timer_sem++;
    
    // Get the components from the date
    NSArray *sinceComponents = [self componentsArrayWithDate:sinceDate];
    NSDictionary *colors = [ColorSchemes colorSchemeWithName:colorScheme];
    _colorScheme = colors;

    // Cancel the current animation
    [self cancelArcAnimations];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.6];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setCompletionBlock:^{
        
        // Redraw layers
        [self drawLayersWithColors:colors numArcs:sinceComponents.count];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:3.0];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [CATransaction setCompletionBlock:^{
            // Decrease semaphore
            _timer_sem--;
        }];
        
        // Animate to progress
        [self setArcsToProgress:sinceComponents duration:3.0];
        
        [CATransaction commit];
        
        // Label count up
        [dayCountLabel countFromValue:0 toValue:[(NSNumber *)sinceComponents[0] integerValue] duration:3.0f timing:CountingLabelTimingFunctionEaseOut];
    }];
    
    // Reset the arcs
    [self setArcsToZeroWithDuration:0.6];
    
    [CATransaction commit];
    
    // Label count down
    [dayCountLabel countToValue:0 duration:0.6 timing:CountingLabelTimingFunctionEaseIn];
    
    // Set other colors
    [self changeCenterAndBackgroundColor:colors];
    
}

#pragma mark - Data

- (NSArray *)componentsArrayWithDate:(NSDate *)date {
    // Timer interval since date
    NSInteger intervalSinceDate = labs((NSInteger)[[NSDate date] timeIntervalSinceDate:date]);
    
    // Components Array
    NSMutableArray *componentsArr = [[NSMutableArray alloc] init];
    
    // Day count is the first entry in the array
    [componentsArr addObject:@(intervalSinceDate / 86400)];
    
    // Minute percentage
    [componentsArr addObject:@(intervalSinceDate % 60 / 60.f)];
    
    // Hour percentage
    if (intervalSinceDate > 60) {
        [componentsArr addObject:@(intervalSinceDate % 3600 / 3600.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // Day percentage
    if (intervalSinceDate > 3600) {
        [componentsArr addObject:@(intervalSinceDate % 86400 / 86400.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // Week percentage
    if (intervalSinceDate > 86400) {
        [componentsArr addObject:@(intervalSinceDate % 604800 / 604800.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // Month percentage
    if (intervalSinceDate > 604800) {
        [componentsArr addObject:@(intervalSinceDate % 2592000 / 2592000.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // Year percentage
    if (intervalSinceDate > 2592000) {
        [componentsArr addObject:@(intervalSinceDate % 31536000 / 31536000.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // 2 year percentage
    if (intervalSinceDate > 31536000) {
        [componentsArr addObject:@(intervalSinceDate % 63072000 / 63072000.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // 5 year percentage
    if (intervalSinceDate > 63072000) {
        [componentsArr addObject:@(intervalSinceDate % 157680000 / 157680000.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // 10 year percentage
    if (intervalSinceDate > 157680000) {
        [componentsArr addObject:@(intervalSinceDate % 315360000 / 315360000.f)];
    } else return [NSArray arrayWithArray:componentsArr];
    
    // Return a hard copy of the array
    return [NSArray arrayWithArray:componentsArr];
}

#pragma mark - Arc Animation

- (void)cancelArcAnimations {
    CALayer *currentProgressShapesLayer = progressShapesLayer.presentationLayer;
    [progressShapesLayer removeAllAnimations];
    for (NSUInteger i = 0; i < progressShapesLayer.sublayers.count; i++) {
        CAShapeLayer *arcLayer = [progressShapesLayer.sublayers objectAtIndex:i];
        CAShapeLayer *presentingArcLayer = [currentProgressShapesLayer.sublayers objectAtIndex:i];
        arcLayer.strokeEnd = presentingArcLayer.strokeEnd;
    }
}

- (void)setArcsToZeroWithDuration:(CGFloat)duration {
    // During the transaction, add an animation to reset each arc to zero
    for (CAShapeLayer *layer in progressShapesLayer.sublayers) {
        [self addAnimationToArc:layer toProgress:0.0 duration:duration];
    }
}

- (void)setArcsToProgress:(NSArray *)components duration:(CGFloat)duration {
    [progressShapesLayer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [self addAnimationToArc:(CAShapeLayer *)obj toProgress:[(NSNumber *)components[idx + 1] floatValue] duration:duration];
    }];
}

- (void)addAnimationToArc:(CAShapeLayer *)arc toProgress:(CGFloat)progress duration:(CGFloat)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(arc.strokeEnd);
    animation.toValue = @(progress);
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    [arc addAnimation:animation forKey:animation.keyPath];
    arc.strokeEnd = progress;
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

@end
