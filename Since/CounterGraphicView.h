//
//  CounterGraphicView.h
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CounterGraphicView : UIView

- (id)initWithSuperView:(UIView *)superview;

- (void)resetView:(NSArray *)sinceComponents colors:(NSDictionary *)colors;

@end
