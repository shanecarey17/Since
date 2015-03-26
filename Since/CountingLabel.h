//
//  CountingLabel.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountingLabel : UILabel

- (void)countFromValue:(NSInteger)startValue toValue:(NSInteger)endValue duration:(CGFloat)duration;

@end
