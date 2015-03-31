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

- (void)countToValue:(NSInteger)end duration:(CGFloat)time {
    [self countFromValue:value toValue:end duration:time];
}

- (void)countFromValue:(NSInteger)start toValue:(NSInteger)end duration:(CGFloat)time {
    // Disable previous timer
    [timer invalidate];
    
    // Set values
    value = startValue = start;
    endValue = end;
    progress = 0.0f;
    duration = time;
    
    // Begin
    timer = [NSTimer scheduledTimerWithTimeInterval:1 / 30.f target:self selector:@selector(updateValue) userInfo:nil repeats:YES];
}

- (void)updateValue {
    // Update variables
    value = [self calculateValue];
    progress += 1 / 30.0f;
    
    // Set text
    [UIView animateWithDuration:0.1 animations:^{
        self.text = [NSString stringWithFormat:@"%d", (int)value];
    }];
    
    // Stop when value == endvalue
    if (value == endValue) {
        [timer invalidate];
    }
}

- (NSInteger)calculateValue {
    // Cubic ease in out curve
    Float32 percent = (progress / duration) - 1;
    return endValue * (pow(percent, 3) + 1) + startValue;
}

@end
