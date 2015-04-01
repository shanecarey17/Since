//
//  CountingLabel.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CountingLabelTimingFunction) {
    CountingLabelTimingFunctionEaseIn,
    CountingLabelTimingFunctionEaseOut,
    CountingLabelTimingFunctionEaseInOut
};

@interface CountingLabel : UILabel

- (void)countToValue:(NSInteger)end duration:(CGFloat)time timing:(CountingLabelTimingFunction)function;

- (void)countFromValue:(NSInteger)start toValue:(NSInteger)end duration:(CGFloat)time timing:(CountingLabelTimingFunction)function;

@end
