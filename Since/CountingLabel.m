//
//  CountingLabel.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "CountingLabel.h"

@interface CountingLabel ()
{
    NSTimer *timer;
    NSInteger value;
    NSInteger startValue;
    NSInteger endValue;
    Float32 progress;
    Float32 duration;
}

@end

@implementation CountingLabel

- (void)countToValue:(NSInteger)end duration:(CGFloat)time timing:(CountingLabelTimingFunction)function {
    [self countFromValue:value toValue:end duration:time timing:function];
}

- (void)countFromValue:(NSInteger)start toValue:(NSInteger)end duration:(CGFloat)time timing:(CountingLabelTimingFunction)function {
    // Disable previous timer
    [timer invalidate];
    
    // Set values
    value = startValue = start;
    endValue = end;
    progress = 0.0f;
    duration = time;
    
    // Begin
    NSDictionary *timingFunction = @{@"timingFunction" : @(function)};
    timer = [NSTimer timerWithTimeInterval:1 / 30.f target:self selector:@selector(updateValue:) userInfo:timingFunction repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)updateValue:(NSTimer *)sender {
    // Update variables
    CountingLabelTimingFunction function = (CountingLabelTimingFunction)[(NSNumber *)[[sender userInfo] objectForKey:@"timingFunction"] integerValue];
    value = [self calculateValue:function];
    progress += 1 / 30.0f;
    
    // Set text
    self.text = [NSString stringWithFormat:@"%d", (int)value];
    
    // Stop when value == endvalue
    if (value == endValue) {
        [timer invalidate];
    }
}

- (NSInteger)calculateValue:(CountingLabelTimingFunction)function {
    Float32 percent = progress / duration;
    NSInteger delta = endValue - startValue;
    Float32 result;
    switch (function) {
        case CountingLabelTimingFunctionEaseIn:
            // Quintic ease in curve
            result = delta * pow(percent, 3) + startValue;
            break;
        case CountingLabelTimingFunctionEaseOut:
            // Quintic ease out curve
            result = delta * (pow(percent - 1, 3) + 1) + startValue;
            break;
        case CountingLabelTimingFunctionEaseInOut:
            // Quintic ease in/out curve
            if (percent / 2 < 1) {
                result = (delta / 2) * pow(percent / 2, 3) + startValue;
            } else result = (delta / 2) * (pow(percent / 2, 3) + 2) + startValue;
            break;
    }
    return result;
}

@end
