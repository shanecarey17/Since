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

@implementation SinceEntryPickerCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dayCountLabel = [self createDayCountLabel];
        [self.contentView addSubview:_dayCountLabel];
        
        _titleLabel = [self createTitleLabel];
        [self.contentView addSubview:_titleLabel];
        
        _deleteButton = [self createDeleteButton];
        [self.contentView addSubview:_deleteButton];
        
        NSArray *constraints = [self createConstraints];
        [self.contentView addConstraints:constraints];
    }
    return self;
}

- (UILabel *)createDayCountLabel {
    UILabel *dayCountLabel = [[UILabel alloc] init];
    dayCountLabel.textColor = [UIColor whiteColor];
    dayCountLabel.textAlignment = NSTextAlignmentCenter;
    dayCountLabel.numberOfLines = 0;
    dayCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:self.bounds.size.width / 3];
    dayCountLabel.adjustsFontSizeToFitWidth = YES;
    dayCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return dayCountLabel;
}

- (UILabel *)createTitleLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:self.bounds.size.width / 8];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return titleLabel;
}

- (UIButton *)createDeleteButton {
    SinceEntryDeleteButton *deleteButton = [[SinceEntryDeleteButton alloc] init];
    deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    deleteButton.alpha = 0.0;
    return deleteButton;
}

- (NSArray *)createConstraints {
    NSLayoutConstraint *centerXCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *topCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10];
    NSLayoutConstraint *widthCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    NSLayoutConstraint *heightCountLabel = [NSLayoutConstraint constraintWithItem:_dayCountLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0];
    
    NSLayoutConstraint *topTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dayCountLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *heightTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:16];
    NSLayoutConstraint *leftTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *topButton = [NSLayoutConstraint constraintWithItem:_deleteButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0];
    NSLayoutConstraint *rightButton = [NSLayoutConstraint constraintWithItem:_deleteButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRightMargin multiplier:1 constant:0];
    NSLayoutConstraint *widthButton = [NSLayoutConstraint constraintWithItem:_deleteButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0];
    NSLayoutConstraint *heightButton = [NSLayoutConstraint constraintWithItem:_deleteButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.25 constant:0];
    
    return @[centerXCountLabel, topCountLabel, widthCountLabel, heightCountLabel, topTitleLabel, heightTitleLabel, leftTitleLabel, rightTitleLabel, topButton, rightButton, widthButton, heightButton];
}

- (void)layoutSubviews {
    _deleteButton.layer.cornerRadius = _deleteButton.bounds.size.width / 2;
}

#pragma mark - editing

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
            _deleteButton.alpha = 1.0;
        }];
    } else {
        // Stop the wobble
        [UIView animateWithDuration:0.1 delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear) animations:^ {
                self.contentView.transform = CGAffineTransformIdentity;
            } completion:nil];
        // Fade out the button
        [UIView animateWithDuration:0.5 animations:^{
            _deleteButton.alpha = 0.0;
        }];
    }
}

@end
