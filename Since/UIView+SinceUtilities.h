//
//  UIView+AnchorPosition.h
//  Since
//
//  Created by Shane Carey on 3/31/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SinceUtilities)

- (void)setAnchorPointAdjustPosition:(CGPoint)anchorPoint;

- (void)disableAllSubviewsRecursive:(BOOL)enabled;

@end
