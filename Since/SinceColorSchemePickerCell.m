//
//  ColorSchemeTableViewCell.m
//  Since
//
//  Created by Shane Carey on 3/28/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceColorSchemePickerCell.h"

@interface SinceColorSchemePickerCell ()
{
    UIView *colorView;
    
    CAShapeLayer *lineOne;
    CAShapeLayer *lineTwo;
    CAShapeLayer *lineThree;
}

@end

@implementation SinceColorSchemePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // No background
        self.backgroundColor = [UIColor clearColor];
        
        // Color view
        colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height / 2, self.bounds.size.height / 2)];
        colorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:colorView];
        
        // Init shape layers
        lineOne = [CAShapeLayer layer];
        lineTwo = [CAShapeLayer layer];
        lineThree = [CAShapeLayer layer];
        [self drawColors];
        
        // Label
        self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        self.label.textColor = [UIColor lightTextColor];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.label];
        
        // Layout constraints
        NSLayoutConstraint *widthColorViewConstraint = [NSLayoutConstraint constraintWithItem:colorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
        NSLayoutConstraint *heightColorViewConstraint = [NSLayoutConstraint constraintWithItem:colorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
        NSLayoutConstraint *xColorViewConstraint = [NSLayoutConstraint constraintWithItem:colorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *yColorViewConstraint = [NSLayoutConstraint constraintWithItem:colorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        NSLayoutConstraint *xLabelConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *topLabelConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:colorView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *bottomLabelConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        // Add them
        [self.contentView addConstraints:@[widthColorViewConstraint, heightColorViewConstraint, xColorViewConstraint, yColorViewConstraint, xLabelConstraint, topLabelConstraint, bottomLabelConstraint]];
    }
    return self;
}

- (void)layoutSubviews {
    self.contentView.frame = self.bounds;
    self.contentView.alpha = powf(self.bounds.size.width, 2) / powf(self.bounds.size.height, 2);
    [self.contentView setNeedsUpdateConstraints];
    [self drawColors];
}

- (void)drawColors {
    NSArray *lines = @[lineOne, lineTwo, lineThree];
    
    // Calculate locations
    CGFloat xEnd = colorView.bounds.size.width;
    CGFloat deltaY = colorView.bounds.size.height / (lines.count + 1);
    CGFloat strokeWeight = (colorView.bounds.size.height / lines.count) / 2;
    CGFloat y = deltaY;
    
    // Draw lines
    for (CAShapeLayer __strong *line in lines) {
        UIBezierPath *linePath = [[UIBezierPath alloc] init];
        [linePath moveToPoint:CGPointMake(0, y)];
        [linePath addLineToPoint:CGPointMake(xEnd, y)];
        
        line.path = linePath.CGPath;
        line.lineWidth = strokeWeight;
        
        [colorView.layer addSublayer:line];
        
        y += deltaY;
    }
}

- (void)setColorScheme:(NSDictionary *)colorScheme {
    _colorScheme = colorScheme;
    lineOne.strokeColor = [(UIColor *)[colorScheme objectForKey:@"centerColor"] CGColor];
    lineTwo.strokeColor = [(UIColor *)[colorScheme objectForKey:@"backgroundColor"] CGColor];
    lineThree.strokeColor = [(UIColor *) [(NSArray *)[colorScheme objectForKey:@"arcColors"] firstObject] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
