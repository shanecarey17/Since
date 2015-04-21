//
//  ColorSchemeTableViewCell.m
//  Since
//
//  Created by Shane Carey on 3/28/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define kNumLines 3

#import "SinceColorSchemePickerCell.h"
#import "ColorSchemes.h"

@interface SinceColorSchemePickerCell ()

@property (strong, nonatomic) UIView *colorView;

@end

@implementation SinceColorSchemePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // No background
        self.backgroundColor = [UIColor clearColor];
        
        
        // Color view
        _colorView = [self createColorView];
        [self.contentView addSubview:_colorView];
        
        // Label
        _label = [self createLabel];
        [self.contentView addSubview:self.label];
        
        // Layout constraints
        NSArray *constraints = [self createConstraints];
        [self.contentView addConstraints:constraints];
        
    }
    return self;
}

- (UIView *)createColorView {
    // Create view
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height / 2, self.bounds.size.height / 2)];
    colorView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add sublayers
    for (int i = 0; i < kNumLines; i++) {
        [colorView.layer addSublayer:[CAShapeLayer layer]];
    }
    
    return colorView;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    label.textColor = [UIColor lightTextColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (NSArray *)createConstraints {
    NSLayoutConstraint *widthColorViewConstraint = [NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    NSLayoutConstraint *heightColorViewConstraint = [NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    NSLayoutConstraint *xColorViewConstraint = [NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *yColorViewConstraint = [NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *xLabelConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *topLabelConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_colorView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *bottomLabelConstraint = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    return @[widthColorViewConstraint, heightColorViewConstraint, xColorViewConstraint, yColorViewConstraint, xLabelConstraint, topLabelConstraint, bottomLabelConstraint];
}

- (void)layoutSubviews {
    self.contentView.alpha = powf(self.bounds.size.width, 2) / powf(self.bounds.size.height, 2);
    self.contentView.frame = self.bounds;
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    [self drawColors];
}

- (void)drawColors {
    // Calculate locations
    __block CGFloat xEnd = _colorView.bounds.size.width;
    __block CGFloat deltaY = _colorView.bounds.size.height / (kNumLines + 1);
    __block CGFloat strokeWeight = _colorView.bounds.size.height / (kNumLines * 2);
    __block CGFloat y = deltaY;
    
    // Draw lines
    for (CAShapeLayer *shapeLayer in _colorView.layer.sublayers) {
        UIBezierPath *linePath = [[UIBezierPath alloc] init];
        [linePath moveToPoint:CGPointMake(0, y)];
        [linePath addLineToPoint:CGPointMake(xEnd, y)];
        
        shapeLayer.path = linePath.CGPath;
        shapeLayer.lineWidth = strokeWeight;
        
        y += deltaY;
    }
}

- (void)setColorScheme:(NSString *)colorScheme {
    _colorScheme = colorScheme;
    NSDictionary *colors = [ColorSchemes colorSchemeWithName:colorScheme];
    NSArray *colorsArray = [colors objectForKey:@"displayColors"];
    [_colorView.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [(CAShapeLayer *)obj setStrokeColor:[(UIColor *)colorsArray[idx] CGColor]];
    }];
}

@end
