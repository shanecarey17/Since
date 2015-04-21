//
//  ColorSchemes.m
//  Since
//
//  Created by Shane Carey on 3/26/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "ColorSchemes.h"
#import "UIColor+Hex.h"

@implementation ColorSchemes

static NSDictionary *colorSchemes = nil;

+ (void)initialize {
    colorSchemes = @{@"B & W" : [ColorSchemes bwColorScheme],
                     @"Inverse" : [ColorSchemes reverseColorScheme],
                     @"Mono" : [ColorSchemes monoColorScheme],
                     @"Neon" : [ColorSchemes neonColorScheme],
                     @"Vintage" : [ColorSchemes vintageColorScheme],
                     @"Retro" : [ColorSchemes retroColorScheme],
                     @"Sea" : [ColorSchemes seaColorScheme],
                     @"Brush" : [ColorSchemes earthColorScheme],
                     @"Blaze" : [ColorSchemes fireColorScheme],
                     @"Cozy" : [ColorSchemes warmColorScheme],
                     @"Fiji" : [ColorSchemes exoticColorScheme],
                     @"Mod" : [ColorSchemes modColorScheme],
                     @"Pop" : [ColorSchemes popColorScheme],
                     @"Citrus" : [ColorSchemes citrusColorScheme]
                     };
}

+ (NSArray *)colorSchemes {
    NSMutableArray *sortedKeys = [[colorSchemes allKeys] mutableCopy];
    [sortedKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return sortedKeys;
}

+ (NSDictionary *)colorSchemeWithName:(NSString *)colorSchemeName {
    return [colorSchemes objectForKey:colorSchemeName];
}

+ (NSDictionary *)bwColorScheme {
    return @{@"titleColor" : [UIColor blackColor],
             @"centerColor" : [UIColor blackColor],
             @"backgroundColor" : [UIColor whiteColor],
             @"arcColors" : @[
                     [UIColor blackColor],
                     [UIColor blackColor],
                     [UIColor blackColor],
                     [UIColor blackColor],
                     [UIColor blackColor],
                     [UIColor blackColor],
                     [UIColor blackColor]
              ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor blackColor],
                     @"cellTextColor" : [UIColor whiteColor],
              },
             @"displayColors" : @[
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor]]
      };
}

+ (NSDictionary *)reverseColorScheme {
    return @{@"titleColor" : [UIColor whiteColor],
             @"centerColor" : [UIColor blackColor],
             @"backgroundColor" : [UIColor blackColor],
             @"arcColors" : @[
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor blackColor],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor whiteColor],
                     [UIColor whiteColor],
                     [UIColor whiteColor]]
             };
}

+ (NSDictionary *)monoColorScheme {
    return @{@"titleColor" : [UIColor blackColor],
             @"centerColor" : [UIColor blackColor],
             @"backgroundColor" : [UIColor whiteColor],
             @"arcColors" : @[
                     [UIColor colorWithWhite:0.1 alpha:1.0],
                     [UIColor colorWithWhite:0.2 alpha:1.0],
                     [UIColor colorWithWhite:0.3 alpha:1.0],
                     [UIColor colorWithWhite:0.4 alpha:1.0],
                     [UIColor colorWithWhite:0.5 alpha:1.0],
                     [UIColor colorWithWhite:0.6 alpha:1.0],
                     [UIColor colorWithWhite:0.7 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithWhite:0.5 alpha:1.0],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithWhite:0.3 alpha:1.0],
                     [UIColor whiteColor],
                     [UIColor colorWithWhite:0.6 alpha:1.0]]
             };
}

+ (NSDictionary *)neonColorScheme {
    return @{@"titleColor" : [UIColor blackColor],
             @"centerColor" : [UIColor colorWithRed:0 green:1.0 blue:0.804 alpha:1.0],
             @"backgroundColor" : [UIColor whiteColor],
             @"arcColors" : @[
                     [UIColor colorWithRed:0.62 green:0.973 blue:0.259 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.443 blue:0.224 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.224 blue:0.663 alpha:1.0],
                     [UIColor colorWithHex:0x00CCFF],
                     [UIColor colorWithRed:1.0 green:0.745 blue:0 alpha:1.0],
                     [UIColor colorWithRed:100 green:0.239 blue:0.345 alpha:1.0],
                     [UIColor colorWithRed:0.208 green:1.0 blue:0.447 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithRed:1.0 green:0.097 blue:0.349 alpha:1.0],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithRed:0 green:1.0 blue:0.804 alpha:1.0],
                     [UIColor colorWithHex:0xFFFFFF],
                     [UIColor colorWithRed:0.62 green:0.973 blue:0.259 alpha:1.0]]
             };
}

+ (NSDictionary *)vintageColorScheme {
    return @{@"titleColor" : [UIColor blackColor],
             @"centerColor" : [UIColor colorWithHex:0x260126],
             @"backgroundColor" : [UIColor colorWithHex:0xF2EEB3],
             @"arcColors" : @[
                     [UIColor colorWithHex:0x59323C],
                     [UIColor colorWithHex:0xBFAF80],
                     [UIColor colorWithHex:0x8C6954],
                     [UIColor colorWithRed:0.675 green:0.545 blue:0.49 alpha:1.0],
                     [UIColor colorWithHex:0xF7CEC9],
                     [UIColor colorWithRed:0.627 green:0.671 blue:0.541 alpha:1.0],
                     [UIColor colorWithRed:0.337 green:0.275 blue:0.239 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0x706667],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithHex:0x260126],
                     [UIColor colorWithHex:0xF2EEB3],
                     [UIColor colorWithHex:0x59323C]]
             };
}

+ (NSDictionary *)retroColorScheme {
    return @{@"titleColor" : [UIColor blackColor],
             @"centerColor" : [UIColor colorWithRed:0.961 green:0.38 blue:0.306 alpha:1.0],
             @"backgroundColor" : [UIColor colorWithRed:1.0 green:0.98 blue:0.753 alpha:1.0],
             @"arcColors" : @[
                     [UIColor colorWithRed:0.42 green:0.827 blue:0.706 alpha:1.0],
                     [UIColor colorWithRed:0.98 green:0.902 blue:0.306 alpha:1.0],
                     [UIColor colorWithRed:0.596 green:0.373 blue:0.388 alpha:1.0],
                     [UIColor colorWithRed:0.275 green:0.541 blue:0.514 alpha:1.0],
                     [UIColor colorWithRed:0.09 green:0.208 blue:0.31 alpha:1.0],
                     [UIColor colorWithHex:0xC5894D],
                     [UIColor colorWithRed:1.0 green:0.737 blue:0.557 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithRed:0.298 green:0.188 blue:0.141 alpha:1.0],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithRed:0.961 green:0.38 blue:0.306 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.98 blue:0.753 alpha:1.0],
                     [UIColor colorWithRed:0.42 green:0.827 blue:0.706 alpha:1.0]]
             };
}

+ (NSDictionary *)seaColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0x1F3063],
             @"centerColor" : [UIColor colorWithRed:0.133 green:0.259 blue:0.333 alpha:1.0],
             @"backgroundColor" : [UIColor colorWithRed:0.784 green:1.0 blue:1.0 alpha:1.0],
             @"arcColors" : @[
                     [UIColor colorWithRed:0.424 green:0.604 blue:0.671 alpha:1.0],
                     [UIColor colorWithHex:0xFFF568],
                     [UIColor colorWithRed:0.525 green:0.802 blue:0.778 alpha:1.0],
                     [UIColor colorWithRed:0.118 green:0.275 blue:0.408 alpha:1.0],
                     [UIColor colorWithHex:0xFA6900],
                     [UIColor colorWithRed:0.42 green:0.851 blue:0.996 alpha:1.0],
                     [UIColor colorWithRed:0.357 green:0.655 blue:0.753 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0xF38630],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithRed:0.133 green:0.259 blue:0.333 alpha:1.0],
                     [UIColor colorWithRed:0.784 green:1.0 blue:1.0 alpha:1.0],
                     [UIColor colorWithRed:0.424 green:0.604 blue:0.671 alpha:1.0]]
             };
}

+ (NSDictionary *)earthColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0x400707],
             @"centerColor" : [UIColor colorWithRed:0.212 green:0.286 blue:0.204 alpha:1.0],
             @"backgroundColor" : [UIColor colorWithRed:0.835 green:0.961 blue:0.824 alpha:1.0],
             @"arcColors" : @[
                     [UIColor colorWithRed:0.482 green:0.627 blue:0.243 alpha:1.0],
                     [UIColor colorWithRed:0.647 green:0.475 blue:0.275 alpha:1.0],
                     [UIColor colorWithRed:0.373 green:0.592 blue:0.349 alpha:1.0],
                     [UIColor colorWithRed:0.316 green:0.365 blue:0.302 alpha:1.0],
                     [UIColor colorWithRed:0.208 green:0.596 blue:0.294 alpha:1.0],
                     [UIColor colorWithRed:0.169 green:0.133 blue:0.11 alpha:1.0],
                     [UIColor colorWithRed:0.282 green:0.624 blue:0.502 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithRed:0 green:0.537 blue:0.376 alpha:1.0],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithRed:0.212 green:0.286 blue:0.204 alpha:1.0],
                     [UIColor colorWithRed:0.835 green:0.961 blue:0.824 alpha:1.0],
                     [UIColor colorWithRed:0.482 green:0.627 blue:0.243 alpha:1.0]]
             };
}

+ (NSDictionary *)fireColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0xBF5521],
             @"centerColor" : [UIColor colorWithRed:0.969 green:0.318 blue:0.318 alpha:1.0],
             @"backgroundColor" : [UIColor colorWithRed:1.0 green:0.902 blue:0.773 alpha:1.0],
             @"arcColors" : @[
                     [UIColor colorWithRed:1.0 green:0.533 blue:0.333 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.792 blue:0.278 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.322 blue:0.196 alpha:1.0],
                     [UIColor colorWithRed:0.31 green:0.122 blue:0.09 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.757 blue:0.247 alpha:1.0],
                     [UIColor colorWithRed:0.6 green:0.278 blue:0.192 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.525 blue:0.173 alpha:1.0]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithRed:0.969 green:0.384 blue:0.29 alpha:1.0],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithRed:0.969 green:0.318 blue:0.318 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.902 blue:0.773 alpha:1.0],
                     [UIColor colorWithRed:1.0 green:0.533 blue:0.333 alpha:1.0]]
             };
}

+ (NSDictionary *)warmColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0x874E32],
             @"centerColor" : [UIColor colorWithHex:0x588C73],
             @"backgroundColor" : [UIColor colorWithHex:0xF2E394],
             @"arcColors" : @[
                     [UIColor colorWithHex:0xF2AE72],
                     [UIColor colorWithHex:0xD96459],
                     [UIColor colorWithHex:0x8C4646],
                     [UIColor colorWithHex:0x22707B],
                     [UIColor colorWithHex:0x12384B],
                     [UIColor colorWithHex:0x8A8F60],
                     [UIColor colorWithHex:0xED9E69]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0x4E4035],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithHex:0x588C73],
                     [UIColor colorWithHex:0xF2E394],
                     [UIColor colorWithHex:0xF2AE72]]
             };
}

+ (NSDictionary *)exoticColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0xA35C36],
             @"centerColor" : [UIColor colorWithHex:0x5E412F],
             @"backgroundColor" : [UIColor colorWithHex:0xFCEBB6],
             @"arcColors" : @[
                     [UIColor colorWithHex:0x78C0A8],
                     [UIColor colorWithHex:0xF07818],
                     [UIColor colorWithHex:0xF0A830],
                     [UIColor colorWithHex:0x9ED377],
                     [UIColor colorWithHex:0xF2584A],
                     [UIColor colorWithHex:0x072446],
                     [UIColor colorWithHex:0x52BDC8]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0xE96689],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithHex:0x5E412F],
                     [UIColor colorWithHex:0xFCEBB6],
                     [UIColor colorWithHex:0x78C0A8]]
             };
}

+ (NSDictionary *)modColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0x353A3B],
             @"centerColor" : [UIColor colorWithHex:0xF2584A],
             @"backgroundColor" : [UIColor colorWithHex:0xF5F5F5],
             @"arcColors" : @[
                     [UIColor colorWithHex:0x67727A],
                     [UIColor colorWithHex:0xC3D7DF],
                     [UIColor colorWithHex:0x6991AC],
                     [UIColor colorWithHex:0x73777A],
                     [UIColor colorWithHex:0xFF9B71],
                     [UIColor colorWithHex:0x1B5173],
                     [UIColor colorWithHex:0xAFC3C1]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0x0A1C25],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithHex:0xF2584A],
                     [UIColor colorWithHex:0xF5F5F5],
                     [UIColor colorWithHex:0x67727A]]
             };
}

+ (NSDictionary *)popColorScheme {
    return @{@"titleColor" : [UIColor blackColor],
             @"centerColor" : [UIColor colorWithHex:0xDD5A8E],
             @"backgroundColor" : [UIColor colorWithHex:0x8FBDCD],
             @"arcColors" : @[
                     [UIColor colorWithHex:0xF3B345],
                     [UIColor colorWithHex:0x4E6F5A],
                     [UIColor colorWithHex:0xEFCEDA],
                     [UIColor colorWithHex:0xFCE348],
                     [UIColor colorWithHex:0xA91209],
                     [UIColor colorWithHex:0xBB6C67],
                     [UIColor colorWithHex:0x0460AB]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0xAFEAAA],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithHex:0xDD5A8E],
                     [UIColor colorWithHex:0x8FBDCD],
                     [UIColor colorWithHex:0xF3B345]]
             };
}

+ (NSDictionary *)citrusColorScheme {
    return @{@"titleColor" : [UIColor colorWithHex:0x114F28],
             @"centerColor" : [UIColor colorWithHex:0xE95363],
             @"backgroundColor" : [UIColor colorWithHex:0xEFEFEF],
             @"arcColors" : @[
                     [UIColor colorWithHex:0xC7E35D],
                     [UIColor colorWithHex:0xFBD453],
                     [UIColor colorWithHex:0xFF950E],
                     [UIColor colorWithHex:0x8FD3D4],
                     [UIColor colorWithHex:0x8DC86C],
                     [UIColor colorWithHex:0xE48164],
                     [UIColor colorWithHex:0xF77855]
                     ],
             @"pickerColors" : @{
                     @"cellBackgroundColor" : [UIColor colorWithHex:0x238193],
                     @"cellTextColor" : [UIColor whiteColor],
                     },
             @"displayColors" : @[
                     [UIColor colorWithHex:0xE95363],
                     [UIColor colorWithHex:0xEFEFEF],
                     [UIColor colorWithHex:0xC7E35D]]
             };
}

@end
