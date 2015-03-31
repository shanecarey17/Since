//
//  CountingLabel.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountingLabel : UILabel

- (void)countToValue:(NSInteger)end duration:(CGFloat)time;

- (void)countFromValue:(NSInteger)start toValue:(NSInteger)end duration:(CGFloat)time;

@end
