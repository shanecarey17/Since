//
//  ColorSchemes.m
//  Since
//
//  Created by Shane Carey on 3/26/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define   RAND_FLOAT ((double)arc4random() / 0x100000000)

#import "ColorSchemes.h"

@implementation ColorSchemes

static NSDictionary *colorSchemes = nil;

+ (void)initialize {
    colorSchemes = @{@"scheme1" : @{@"centerColor" : [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                    @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                    @"arcColors" : @[
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0]
                                            ],
                                    @"pickerColors" : @{
                                            @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.3 brightness:0.3 alpha:1.0],
                                            @"cellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0],
                                            @"cellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0]
                                            }
                         
                         },
                     @"scheme2" : @{@"centerColor" : [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                    @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                    @"arcColors" : @[
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0]
                                            ],
                                    @"pickerColors" : @{
                                            @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.3 brightness:0.3 alpha:1.0],
                                            @"cellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0],
                                            @"cellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0]
                                            }
                         
                         },
                     @"scheme3" : @{@"centerColor" : [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                    @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                    @"arcColors" : @[
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0]
                                            ],
                                    @"pickerColors" : @{
                                            @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.3 brightness:0.3 alpha:1.0],
                                            @"cellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0],
                                            @"cellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0]
                                            }
                         
                         },
                     @"scheme4" : @{@"centerColor" : [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                    @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                    @"arcColors" : @[
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0]
                                            ],
                                    @"pickerColors" : @{
                                            @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.3 brightness:0.3 alpha:1.0],
                                            @"cellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0],
                                            @"cellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0]
                                            }
                         
                         },
                     @"scheme5" : @{@"centerColor" : [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                    @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                    @"arcColors" : @[
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0],
                                            [UIColor colorWithHue:RAND_FLOAT saturation:RAND_FLOAT brightness:0.5 alpha:1.0]
                                            ],
                                    @"pickerColors" : @{
                                            @"backgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.3 brightness:0.3 alpha:1.0],
                                            @"cellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0],
                                            @"cellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellBackgroundColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.2 brightness:0.9 alpha:1.0],
                                            @"selectedCellTextColor" : [UIColor colorWithHue:RAND_FLOAT saturation:0.5 brightness:0.7 alpha:1.0]
                                            }
                         
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
