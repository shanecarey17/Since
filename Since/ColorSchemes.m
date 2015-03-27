//
//  ColorSchemes.m
//  Since
//
//  Created by Shane Carey on 3/26/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "ColorSchemes.h"

@implementation ColorSchemes

static NSDictionary *colorSchemes = nil;

+ (void)initialize {
    colorSchemes = @{@"scheme1" : @{
                         
                         },
                     @"scheme2" : @{
                         
                         },
                     @"scheme3" : @{
                         
                         },
                     @"scheme4" : @{
                         
                         },
                     @"scheme5" : @{
                         
                         },
                     };
}

+ (NSArray *)colorSchemes {
    return [colorSchemes allKeys];
}

+ (NSDictionary *)colorSchemeWithName:(NSString *)colorSchemeName {
    return [colorSchemes objectForKey:colorSchemeName];
}

@end
