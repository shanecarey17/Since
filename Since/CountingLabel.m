//
//  CountingLabel.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "CountingLabel.h"

@implementation CountingLabel

- (void)countFromValue:(NSInteger)startValue toValue:(NSInteger)endValue duration:(CGFloat)duration {
    // Wait between frames on background threads
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // Keep track of the value and progress
        __block int currentValue = 0;
        __block float progress = 0.0f;
        
        while (progress < duration) {
            // Sleep in the background for one frame
            usleep(1000000 / 30);
            
            // Quadratic ease in/out
            float percent = (progress / duration) - 1;
            currentValue = endValue * (pow(percent, 3) + 1) + startValue;
            
            // Update the progress
            progress += 1.0f / 30.0f;
            
            // Update text on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Quick fade between numbers
                CATransition *animation = [CATransition animation];
                animation.duration = 0.5;
                animation.type = kCATransitionFade;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                [self.layer addAnimation:animation forKey:@"changeTextTransition"];
                
                // Change the label
                self.text = [NSString stringWithFormat:@"%d", currentValue];
                [self sizeToFit];
            });
        }
        
        // In case there is an off by one error
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition *animation = [CATransition animation];
            animation.duration = 0.5;
            animation.type = kCATransitionFade;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.layer addAnimation:animation forKey:@"changeTextTransition"];
            self.text = [NSString stringWithFormat:@"%ld", (long)endValue];
            [self sizeToFit];
        });
        
    });
}

@end
