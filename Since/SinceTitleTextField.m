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
        self.delegate = self;
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

#pragma mark - delegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 16 || returnKey;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[SinceDataManager sharedManager] setActiveEntryObject:self.text forKey:@"title"];
}

@end
