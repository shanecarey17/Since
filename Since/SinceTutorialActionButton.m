//
//  SinceTutorialActionButton.m
//  Since
//
//  Created by Shane Carey on 4/19/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceTutorialActionButton.h"

@implementation SinceTutorialActionButton


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetLineWidth(context, 5);
    
    // Right angle pointed right
    CGContextMoveToPoint(context, rect.size.width / 2 - rect.size.height / 8, rect.size.height * 1 / 4);
    CGContextAddLineToPoint(context, rect.size.width / 2 + rect.size.height / 8, rect.size.width * 2 / 4);
    CGContextAddLineToPoint(context, rect.size.width / 2 - rect.size.height / 8, rect.size.height * 3 / 4);
    
    CGContextStrokePath(context);
}


@end
