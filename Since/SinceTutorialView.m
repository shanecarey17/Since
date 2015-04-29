//
//  SinceTutorialView.m
//  Since
//
//  Created by Shane Carey on 4/19/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define kSpeechExtrudeLength 25.0

#import "SinceTutorialView.h"
#import "SinceTutorialActionButton.h"

@interface SinceTutorialView () <UITextViewDelegate> {
    SinceTutorialLabelSpeechDirection _direction;
}

@end

@implementation SinceTutorialView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [self createTextLabel];
        [self addSubview:_textLabel];
        
        _actionButton = [self createActionButton];
        [self addSubview:_actionButton];
        
        NSArray *constraints = [self createConstraints];
        [self addConstraints:constraints];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Get the context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // Draw the path with extrusion
    CGContextBeginPath(context);
    switch (_direction) {
        case SinceTutorialLabelSpeechDirectionNone:
            // No extrusion
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, rect.size.width, 0);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextAddLineToPoint(context, 0, rect.size.height);
            CGContextClosePath(context);
            break;
        case SinceTutorialLabelSpeechDirectionUp:
            // Draw extrusion on top
            CGContextMoveToPoint(context, 0, kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, (rect.size.width / 2) - (kSpeechExtrudeLength / 2), kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, rect.size.width / 2, 0);
            CGContextAddLineToPoint(context, (rect.size.width / 2) + (kSpeechExtrudeLength / 2), kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, rect.size.width, kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextAddLineToPoint(context, 0, rect.size.height);
            CGContextClosePath(context);
            break;
        case SinceTutorialLabelSpeechDirectionDown:
            // Draw extrusion on bottom
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, rect.size.width, 0);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height - kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, (rect.size.width / 2) + (kSpeechExtrudeLength / 2), rect.size.height - kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height);
            CGContextAddLineToPoint(context, (rect.size.width / 2) - (kSpeechExtrudeLength / 2), rect.size.height - kSpeechExtrudeLength);
            CGContextAddLineToPoint(context, 0, rect.size.height - kSpeechExtrudeLength);
            CGContextClosePath(context);
            break;
        case SinceTutorialLabelSpeechDirectionLeft:
            // Draw extrusion on left
            CGContextMoveToPoint(context, kSpeechExtrudeLength, 0);
            CGContextAddLineToPoint(context, rect.size.width, 0);
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
            CGContextAddLineToPoint(context, kSpeechExtrudeLength, rect.size.height);
            CGContextAddLineToPoint(context, kSpeechExtrudeLength, (rect.size.height / 2) + (kSpeechExtrudeLength / 2));
            CGContextAddLineToPoint(context, 0, rect.size.height / 2);
            CGContextAddLineToPoint(context, kSpeechExtrudeLength, (rect.size.height / 2) - (kSpeechExtrudeLength / 2));
            break;
        case SinceTutorialLabelSpeechDirectionRight:
            // Draw extrusion on right
            CGContextMoveToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, rect.size.width - kSpeechExtrudeLength, 0);
            CGContextAddLineToPoint(context, rect.size.width - kSpeechExtrudeLength, (rect.size.height / 2) - (kSpeechExtrudeLength / 2));
            CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 2);
            CGContextAddLineToPoint(context, rect.size.width - kSpeechExtrudeLength, (rect.size.height / 2) + (kSpeechExtrudeLength / 2));
            CGContextAddLineToPoint(context, rect.size.width - kSpeechExtrudeLength, rect.size.height);
            CGContextAddLineToPoint(context, 0, rect.size.height);
            CGContextClosePath(context);
            break;
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (UITextView *)createTextLabel {
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
    textView.textColor = [UIColor darkTextColor];
    textView.backgroundColor = [UIColor clearColor];
    [textView setEditable:NO];
    textView.delegate = self;
    return textView;
}

- (UIButton *)createActionButton {
    UIButton *actionButton = [[SinceTutorialActionButton alloc] init];
    actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    actionButton.backgroundColor = [UIColor clearColor];
    return actionButton;
}

- (NSArray *)createConstraints {
    NSLayoutConstraint *labelTopConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:kSpeechExtrudeLength];
    NSLayoutConstraint *labelLeftConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:kSpeechExtrudeLength];
    NSLayoutConstraint *labelRightConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:kSpeechExtrudeLength];
    NSLayoutConstraint *labelBottomConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_actionButton attribute:NSLayoutAttributeTop multiplier:1 constant:-10];
    
    NSLayoutConstraint *buttonBottomConstraint = [NSLayoutConstraint constraintWithItem:_actionButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:kSpeechExtrudeLength];
    NSLayoutConstraint *buttonXCenter = [NSLayoutConstraint constraintWithItem:_actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *buttonHeight = [NSLayoutConstraint constraintWithItem:_actionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:kSpeechExtrudeLength];
    NSLayoutConstraint *buttonWidth = [NSLayoutConstraint constraintWithItem:_actionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:kSpeechExtrudeLength];
    
    return @[labelTopConstraint, labelLeftConstraint, labelRightConstraint, labelBottomConstraint, buttonBottomConstraint, buttonXCenter, buttonHeight, buttonWidth];
}

- (void)fadeTransitions:(void (^)(void))transitions completion:(void (^)(void))completion {
    // Animates transition of tutorial view from one step to another
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    }completion:^(BOOL finished){
        if (transitions) {
            transitions();
        }
        [UIView animateWithDuration:0.3 delay:0.2 options:kNilOptions animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished){
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)setDirection:(SinceTutorialLabelSpeechDirection)direction {
    _direction = direction;
    switch (direction) {
        case SinceTutorialLabelSpeechDirectionNone:
            self.layer.anchorPoint = CGPointMake(0.5, 0.5);
            for (NSLayoutConstraint *constraint in self.constraints) {
                [self resetConstraint:constraint];
            }
            break;
        case SinceTutorialLabelSpeechDirectionUp:
            self.layer.anchorPoint = CGPointMake(0.5, 0.0);
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeTop) {
                    constraint.constant = 2 * kSpeechExtrudeLength;
                } else {
                    [self resetConstraint:constraint];
                }
            }
            break;
        case SinceTutorialLabelSpeechDirectionDown:
            self.layer.anchorPoint = CGPointMake(0.5, 1.0);
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeBottom) {
                    constraint.constant = 2 * -kSpeechExtrudeLength;
                } else {
                    [self resetConstraint:constraint];
                }
            }
            break;
        case SinceTutorialLabelSpeechDirectionLeft:
            self.layer.anchorPoint = CGPointMake(0.0, 0.5);
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeLeft) {
                    constraint.constant = 2 * kSpeechExtrudeLength;
                } else if (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeCenterX) {
                    constraint.constant = kSpeechExtrudeLength / 2;
                } else {
                    [self resetConstraint:constraint];
                }
            }
            break;
        case SinceTutorialLabelSpeechDirectionRight:
            self.layer.anchorPoint = CGPointMake(1.0, 0.5);
            for (NSLayoutConstraint *constraint in self.constraints) {
                if (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeRight) {
                    constraint.constant = 2 * -kSpeechExtrudeLength;
                } else if (constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeCenterX) {
                    constraint.constant = -kSpeechExtrudeLength / 2;
                }else {
                    [self resetConstraint:constraint];
                }
            }
            break;
    }
    
    // Redraw and layout
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

- (void)resetConstraint:(NSLayoutConstraint *)constraint {
    if (constraint.secondItem == self) {
        if (constraint.secondAttribute == NSLayoutAttributeCenterX) {
            constraint.constant = 0;
        } else {
            if (constraint.secondAttribute == NSLayoutAttributeRight || constraint.secondAttribute == NSLayoutAttributeBottom) {
                constraint.constant = -kSpeechExtrudeLength;
            } else {
                constraint.constant = kSpeechExtrudeLength;
            }
        }
    }
}

#pragma mark - UITextView delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}

@end
