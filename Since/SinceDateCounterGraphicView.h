//
//  CounterGraphicView.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinceDateCounterGraphicView : UIView

- (id)initWithSuperView:(UIView *)superview;

- (void)resetView:(NSDate *)sinceDate colors:(NSString *)colorScheme;

@end
