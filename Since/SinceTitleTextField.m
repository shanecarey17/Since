//
//  SinceTitleTextField.m
//  Since
//
//  Created by Shane Carey on 4/18/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceTitleTextField.h"
#import "SinceColorSchemes.h"

@implementation SinceTitleTextField

- (void)setText:(NSString *)text colorScheme:(NSString *)colorScheme {
    // Animate text and color change
    [UIView animateWithDuration:0.6 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished){
        [super setText:text];
        self.textColor = [[SinceColorSchemes colorSchemeWithName:colorScheme] objectForKey:@"titleColor"];
        [UIView animateWithDuration:0.6 animations:^{
            self.alpha = 1;
        }];
    }];
}

@end
