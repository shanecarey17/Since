//
//  ColorSchemes.h
//  Since
//
//  Created by Shane Carey on 3/26/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSchemes : NSObject

+ (NSArray *)colorSchemes;

+ (NSDictionary *)colorSchemeWithName:(NSString *)colorSchemeName;

@end
