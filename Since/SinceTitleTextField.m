//
//  SinceTitleTextField.m
//  Since
//
//  Created by Shane Carey on 4/18/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceTitleTextField.h"
#import "SinceDataManager.h"
#import "SinceColorSchemes.h"

@interface SinceTitleTextField () <UITextFieldDelegate>

@end

@implementation SinceTitleTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardAppearance = UIKeyboardAppearanceDark;
        self.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:self.bounds.size.height / 4];
        self.tintColor = [UIColor clearColor];
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

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

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end
