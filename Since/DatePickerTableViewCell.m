//
//  DatePickerTableViewCell.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "DatePickerTableViewCell.h"

@implementation DatePickerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialize
        self.label = [[UILabel alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:self.label];
        
        // Customize
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:26];
        self.label.layer.masksToBounds = YES;
        
        // Layout constraints
        NSLayoutConstraint *xConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:1];
        NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:1];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1 constant:-20];
        [self.contentView addConstraints:@[xConstraint, yConstraint, widthConstraint, heightConstraint]];
                                         
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    self.label.layer.cornerRadius = self.label.bounds.size.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    if (selected) {
        self.label.textColor = [self.colorScheme objectForKey:@"selectedCellTextColor"];
        self.label.backgroundColor = [self.colorScheme objectForKey:@"selectedCellBackgroundColor"];
    } else {
        self.label.textColor = [self.colorScheme objectForKey:@"cellTextColor"];
        self.label.backgroundColor = [self.colorScheme objectForKey:@"cellBackgroundColor"];
    }
}

- (void)setColorScheme:(NSDictionary *)colorScheme {
    _colorScheme = colorScheme;
    if (self.selected) {
        self.label.textColor = [self.colorScheme objectForKey:@"selectedCellTextColor"];
        self.label.backgroundColor = [self.colorScheme objectForKey:@"selectedCellBackgroundColor"];
    } else {
        self.label.textColor = [colorScheme objectForKey:@"cellTextColor"];
        self.label.backgroundColor = [colorScheme objectForKey:@"cellBackgroundColor"];
    }
}

@end
