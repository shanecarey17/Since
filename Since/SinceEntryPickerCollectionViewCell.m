//
//  SinceEntryPickerCollectionViewCell.m
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "SinceEntryPickerCollectionViewCell.h"
#import "SinceEntryDeleteButton.h"

@interface SinceEntryPickerCollectionViewCell () {
    
    UIButton *deleteButton;
}

@end

@implementation SinceEntryPickerCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initLabels];
        [self initDeleteButton];
    }
    return self;
}

- (void)initLabels {
    // Initialize
    _dayCountLabel = [[UILabel alloc] init];
    _dayCountLabel.textColor = [UIColor whiteColor];
    _dayCountLabel.textAlignment = NSTextAlignmentCenter;
    _dayCountLabel.numberOfLines = 0;
    _dayCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.bounds.size.width / 3];
    _dayCountLabel.adjustsFontSizeToFitWidth = YES;
    _dayCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_dayCountLabel];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor lightTextColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_titleLabel];
    
    // Constraints
    NSLayoutConstraint *centerXCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerYCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *widthCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    NSLayoutConstraint *heightCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    
    NSLayoutConstraint *topTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dayCountLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *bottomTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leftTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    [self.contentView addConstraints:@[centerXCountLabel, centerYCountLabel, widthCountLabel, heightCountLabel, topTitleLabel, bottomTitleLabel, leftTitleLabel, rightTitleLabel]];
}

- (void)initDeleteButton {
    deleteButton = [[SinceEntryDeleteButton alloc] init];
    deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    deleteButton.alpha = 0.0;
    [self.contentView addSubview:deleteButton];
    
    NSLayoutConstraint *topButton = [NSLayoutConstraint constraintWithItem:deleteButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0];
    NSLayoutConstraint *rightButton = [NSLayoutConstraint constraintWithItem:deleteButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0];
    NSLayoutConstraint *widthButton = [NSLayoutConstraint constraintWithItem:deleteButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0];
    NSLayoutConstraint *heightButton = [NSLayoutConstraint constraintWithItem:deleteButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0];
    [self.contentView addConstraints:@[topButton, rightButton, widthButton, heightButton]];
    
    [deleteButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchDown];
}

- (void)layoutSubviews {
    // Things that depend on the size of the cell
    deleteButton.layer.cornerRadius = deleteButton.bounds.size.width / 2;
}

- (void)setEditing:(BOOL)editing {
    if (editing) {
        // Wobble
        CGFloat wobbleDuration = 0.09 + fmodf(((double)arc4random() / 0x100000000), 0.04);
        [UIView animateWithDuration:wobbleDuration delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
            animations:^ {
                self.contentView.transform = CGAffineTransformTranslate(CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(3)), 0, 1.5f) ;
            } completion:nil];
        // Fade in delete button
        [UIView animateWithDuration:0.5 animations:^{
            deleteButton.alpha = 1.0;
        }];
    } else {
        // Stop the wobble
        [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear) animations:^ {
                self.contentView.transform = CGAffineTransformIdentity;
            } completion:nil];
        // Fade out the button
        [UIView animateWithDuration:0.5 animations:^{
            deleteButton.alpha = 0.0;
        }];
    }
}

- (void)deleteButtonPressed {
    // Let the collection know to delete the cell
    [self.delegate deleteButtonPressedForCell:self];
}

@end
