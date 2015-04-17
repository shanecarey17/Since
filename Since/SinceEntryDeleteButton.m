//
//  SinceEntryDeleteButton.m
//  Since
//
//  Created by Shane Carey on 4/17/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceEntryDeleteButton.h"

@implementation SinceEntryDeleteButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw red circle
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGRect insetRect = CGRectInset(rect, 2, 2);
    CGContextFillEllipseInRect(context, insetRect);
    
    // Draw white line
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, self.bounds.size.height / 8);
    CGContextMoveToPoint(context, self.bounds.size.width / 3, self.bounds.size.height / 2);
    CGContextAddLineToPoint(context, self.bounds.size.width * 2 / 3, self.bounds.size.height / 2);
    CGContextStrokePath(context);
    
}


@end
