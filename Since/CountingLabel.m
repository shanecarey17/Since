//
//  CountingLabel.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "CountingLabel.h"

@interface CountingLabel () {
    NSTimer *timer;
}

@end

@implementation CountingLabel

- (void)countToValue:(NSInteger)end duration:(CGFloat)time timing:(CountingLabelTimingFunction)function {
    [self countFromValue:[self.text integerValue] toValue:end duration:time timing:function];
}

- (void)countFromValue:(NSInteger)start toValue:(NSInteger)end duration:(CGFloat)time timing:(CountingLabelTimingFunction)function {
    // Disable previous timer
    [timer invalidate];
    
    // Begin
    NSMutableDictionary *timingFunction = [[NSMutableDictionary alloc] initWithDictionary:@{@"timingFunction" : @(function),
                                                                                            @"endValue" : @(end),
                                                                                            @"startValue" : @(start),
                                                                                            @"duration" : @(time),
                                                                                            @"progress" : @(0.0)}];
    timer = [NSTimer timerWithTimeInterval:1 / 30.f target:self selector:@selector(updateValue:) userInfo:timingFunction repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)updateValue:(NSTimer *)sender {
    // Get data from timer
    CountingLabelTimingFunction function = (CountingLabelTimingFunction)[(NSNumber *)[[sender userInfo] objectForKey:@"timingFunction"] integerValue];
    NSInteger start = [(NSNumber *)[[sender userInfo] objectForKey:@"startValue"] integerValue];
    NSInteger end = [(NSNumber *)[[sender userInfo] objectForKey:@"endValue"] integerValue];
    CGFloat duration = [(NSNumber *)[[sender userInfo] objectForKey:@"duration"] floatValue];
    CGFloat progress = [(NSNumber *)[[sender userInfo] objectForKey:@"progress"] floatValue];
    
    // Calculate value and set text
    NSInteger value = [self calculateValueWithTiming:function startValue:start endValue:end duration:duration progress:progress];
    self.text = [NSString stringWithFormat:@"%ld", (long)value];
    
    // Update progress
    progress += 1 / 30.0f;
    [[sender userInfo] setObject:@(progress) forKey:@"progress"];
    
    // Stop when value == endvalue
    if (value == end) {
        [timer invalidate];
    }
}

- (NSInteger)calculateValueWithTiming:(CountingLabelTimingFunction)function startValue:(NSInteger)start endValue:(NSInteger)end duration:(CGFloat)time progress:(CGFloat)progress {
    CGFloat percent = progress / time;
    NSInteger delta = end - start;
    CGFloat result;
    switch (function) {
        case CountingLabelTimingFunctionEaseIn:
            // Quintic ease in curve
            result = delta * pow(percent, 3) + start;
            break;
        case CountingLabelTimingFunctionEaseOut:
            // Quintic ease out curve
            result = delta * (pow(percent - 1, 3) + 1) + start;
            break;
        case CountingLabelTimingFunctionEaseInOut:
            // Quintic ease in/out curve
            if (percent / 2 < 1) {
                result = (delta / 2) * pow(percent / 2, 3) + start;
            } else result = (delta / 2) * (pow(percent / 2, 3) + 2) + start;
            break;
    }
    return result;
}

@end
