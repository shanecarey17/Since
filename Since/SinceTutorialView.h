//
//  SinceTutorialView.h
//  Since
//
//  Created by Shane Carey on 4/19/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SinceTutorialLabelSpeechDirection) {
    SinceTutorialLabelSpeechDirectionNone,
    SinceTutorialLabelSpeechDirectionUp,
    SinceTutorialLabelSpeechDirectionDown,
    SinceTutorialLabelSpeechDirectionLeft,
    SinceTutorialLabelSpeechDirectionRight
};

@interface SinceTutorialView : UIView

@property (strong, nonatomic) UITextView *textLabel;

@property (strong, nonatomic) UIButton *actionButton;

@property (nonatomic) SinceTutorialLabelSpeechDirection direction;

- (void)fadeTransitions:(void (^)(void))transitions completion:(void (^)(void))completion;

@end
