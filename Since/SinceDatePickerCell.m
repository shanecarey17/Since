//
//  DatePickerTableViewCell.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceDatePickerCell.h"
#import "ColorSchemes.h"

@implementation SinceDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Self
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        // Label
        self.label = [self createLabel];
        [self.contentView addSubview:self.label];
        
        // Layout constraints
        NSArray *constraints = [self createConstraints];
        [self.contentView addConstraints:constraints];
                                         
    }
    return self;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = self.bounds.size.width / 2;
    return label;
}

- (NSArray *)createConstraints {
    NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:1];
    NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:1];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:-20];
    
    return @[xConstraint, yConstraint, widthConstraint, heightConstraint];
}

- (void)layoutSubviews {
    self.label.layer.cornerRadius = self.label.bounds.size.width / 2;
}

- (void)setColorScheme:(NSString *)colorScheme {
    _colorScheme = colorScheme;
    self.label.textColor = [[[ColorSchemes colorSchemeWithName:colorScheme] objectForKey:@"pickerColors"] objectForKey:@"cellTextColor"];
    self.label.backgroundColor = [[[ColorSchemes colorSchemeWithName:colorScheme] objectForKey:@"pickerColors"] objectForKey:@"cellBackgroundColor"];
}

@end
