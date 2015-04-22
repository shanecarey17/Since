//
//  UIView+AnchorPosition.m
//  Since
//
//  Created by Shane Carey on 3/31/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "UIView+SinceUtilities.h"

@implementation UIView (SinceUtilities)

- (void)setAnchorPointAdjustPosition:(CGPoint)anchorPoint {
    // Change anchor point by setting around bounds of view
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

@end
