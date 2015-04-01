//
//  UIColor+Hex.m
//  Since
//
//  Created by Shane Carey on 3/31/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hex {
    // Bitmask the rgb from the hex
    float red = ((hex & 0xFF0000) >> 16) / 255.0f;
    float green = ((hex & 0x00FF00) >> 8) / 255.0f;
    float blue = ((hex & 0x0000FF) >> 0) / 255.0f;
    
    // Return the color
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
