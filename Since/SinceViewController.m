//
//  ViewController.m
//  Since
//
//  Created by Shane Carey on 3/24/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

#import "SinceViewController.h"
#import "SinceColorPickerTableViewController.h"
#import "SinceEntryPickerCollectionViewController.h"
#import "SinceTutorialView.h"
#import "SinceDateCounterGraphicView.h"
#import "SinceTitleTextField.h"
#import "SinceDatePicker.h"
#import "UIView+SinceUtilities.h"

@interface SinceViewController () <UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
    
    // Child Controllers
    SinceColorPickerTableViewController *colorPickerController;
    SinceEntryPickerCollectionViewController *entryPickerController;
    
    // UI elements
    SinceDateCounterGraphicView *graphicView;
    SinceDatePicker *datePicker;
    SinceTitleTextField *entryTitleField;
    SinceTutorialView *tutorialView;
    
    // Gestures
    UITapGestureRecognizer *tapToReset;
    UITapGestureRecognizer *tapToShowDatePicker;
    UIPanGestureRecognizer *panToExposeColorPicker;
    UIPanGestureRecognizer *panToExposeEntryPicker;
    
    // State flags
    BOOL datePickerIsVisible;
    BOOL colorPickerIsVisible;
    BOOL entryPickerIsVisible;
    BOOL tutorialIsInProgress;
}

@property (strong, nonatomic) SinceDataManager *dataManager;

@property (strong, nonatomic) NSDictionary *entry;

@end

@implementation SinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Model
    self.dataManager = [[SinceDataManager alloc] init];
    self.dataManager.delegate = self;
    
    // Initialize subiews (date picker under graphic view)
    [self initColorPicker];
    [self initDatePicker];
    [self initGraphicView];
    [self initEntryPicker];
    [self initEntryTitleField];
    
    // Register for notifications to reset graphic view on open and hide stuff on close
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetCurrentDisplay) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllSubviews) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllSubviews) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllSubviews) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initGraphicView {
    // Set up graphics view
    graphicView = [[SinceDateCounterGraphicView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
    graphicView.center = self.view.center;
    [graphicView setAnchorPointAdjustPosition:CGPointMake(0.75, 0.5)];
    [self.view addSubview:graphicView];
    
    // Double tap for date picker
    tapToShowDatePicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerControl)];
    tapToShowDatePicker.numberOfTapsRequired = 2;
    tapToShowDatePicker.delegate = self;
    [graphicView addGestureRecognizer:tapToShowDatePicker];
    
    // Single tap for reset display
    tapToReset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetCurrentDisplay)];
    tapToReset.delegate = self;
    [graphicView addGestureRecognizer:tapToReset];
    [tapToReset requireGestureRecognizerToFail:tapToShowDatePicker];
    
    // Pan for color picker
    panToExposeColorPicker = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragColorSchemePicker:)];
    panToExposeColorPicker.delegate = self;
    [graphicView addGestureRecognizer:panToExposeColorPicker];
}

- (void)initColorPicker {
    colorPickerController = [[SinceColorPickerTableViewController alloc] init];
    [self addChildViewController:colorPickerController];
    [colorPickerController didMoveToParentViewController:self];
    [self.view addSubview:colorPickerController.view];
    colorPickerController.tableView.frame = CGRectMake(0, 0, 0, self.view.bounds.size.height);
    colorPickerController.dataManager = self.dataManager;
}

- (void)initEntryPicker {
    entryPickerController = [[SinceEntryPickerCollectionViewController alloc] init];
    [self addChildViewController:entryPickerController];
    [entryPickerController didMoveToParentViewController:self];
    [self.view addSubview:entryPickerController.view];
    entryPickerController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height / 8);
    entryPickerController.dataManager = self.dataManager;
    
    panToExposeEntryPicker = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(revealEntryPicker:)];
    panToExposeEntryPicker.cancelsTouchesInView = NO;
    panToExposeEntryPicker.delegate = self;
    [self.view addGestureRecognizer:panToExposeEntryPicker];
}

- (void)initDatePicker {
    // Date picker
    datePicker = [[SinceDatePicker alloc] init];
    datePicker.center = CGPointMake(self.view.center.x, (self.view.bounds.size.width + self.view.bounds.size.height) / 2);
    [datePicker setAnchorPointAdjustPosition:CGPointMake(0.75, 0.5)];
    datePicker.alpha = 0.0f;
    [self.view addSubview:datePicker];
    
    // Set flag
    datePickerIsVisible = NO;
}

- (void)initEntryTitleField {
    entryTitleField = [[SinceTitleTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, graphicView.frame.origin.y)];
    entryTitleField.delegate = self;
    [entryTitleField setAnchorPointAdjustPosition:CGPointMake(0.75, 0.5)];
    [self.view addSubview:entryTitleField];
}

#pragma mark - view enter/exit

- (void)viewWillAppear:(BOOL)animated {
    [self.dataManager forceDelegateCall];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialWasViewed"]) {
        [self tutorial:nil];
    }
}

- (void)hideAllSubviews {
    [entryPickerController setEditing:NO];
    [entryPickerController.collectionView reloadData];
    [self hideEntryPicker];
    [self hideDatePicker];
    [self hideColorPicker];
}

#pragma mark - Data delegation and reloading view

- (void)activeEntryWasChangedToEntry:(NSDictionary *)entry {
    self.entry = entry;
    [self resetCurrentDisplay];
}

- (void)resetCurrentDisplay {
    [graphicView resetView:[self.entry objectForKey:@"sinceDate"] colors:[self.entry objectForKey:@"colorScheme"]];
    [entryTitleField setText:[self.entry objectForKey:@"title"] colorScheme:[self.entry objectForKey:@"colorScheme"]];
    [datePicker setColorScheme:[self.entry objectForKey:@"colorScheme"]];
    [datePicker setDate:[self.entry objectForKey:@"sinceDate"]];
}

#pragma mark - Date picker

- (void)datePickerControl {
    // If the date picker is not visible
    if (!datePickerIsVisible) {
        
        // Show the picker
        [self showDatePicker];
        
    } else {
        // Date picker is visible
        NSDate *chosenDate = [datePicker date];
        if (chosenDate == nil) {
            // Shake for invalid date
            CAKeyframeAnimation *invalidShake = [self invalidShakeAnimation];
            [datePicker.layer addAnimation:invalidShake forKey:invalidShake.keyPath];
            
        } else {
            // We have a valid date
            [self.dataManager setActiveEntryObject:chosenDate forKey:@"sinceDate"];
            
            // Set and hide date picker
            [self hideDatePicker];
        }
    }
}

- (CAKeyframeAnimation *)invalidShakeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.07;
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-10, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(10, 0, 0)]];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.autoreverses = YES;
    animation.repeatCount = 2;
    return animation;
}

- (void)showDatePicker {
    // Animate graphic translate up and hide entry view
    [self hideEntryPicker];
    [entryTitleField setAnchorPointAdjustPosition:CGPointMake(0.5, 0.5)];
    [UIView animateWithDuration:0.3f animations:^{
        entryTitleField.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.75, 0.75), 0, -25);
        graphicView.transform = CGAffineTransformMakeTranslation(0, -50);
    } completion:^(BOOL finished){
        // Picker fades in after
        [UIView animateWithDuration:0.3f animations:^{
            datePicker.alpha = 1.0f;
        }];
    }];
    
    // Set flag
    datePickerIsVisible = YES;
}

- (void)hideDatePicker {
    // Animate
    [UIView animateWithDuration:0.3f animations:^{
        // Fade date picker out
        datePicker.alpha = 0.0f;
    } completion:^(BOOL finished){
        // Translate graphic down
        [UIView animateWithDuration:0.3f animations:^{
            entryTitleField.transform = CGAffineTransformIdentity;
            graphicView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            // Reset view with date
            [entryTitleField setAnchorPointAdjustPosition:CGPointMake(0.75, 0.5)];
        }];
    }];
    
    // Set flag
    datePickerIsVisible = NO;
}

#pragma mark - Color picker

- (void)dragColorSchemePicker:(UIPanGestureRecognizer *)panGestureRecognizer {
    // Visible while gesture is in action
    colorPickerIsVisible = YES;
    
    // Constants
    const CGFloat suspendedAngle = DEGREES_TO_RADIANS(-55);
    const CGFloat maxPullAngle = DEGREES_TO_RADIANS(70);
    const CGFloat minPullAngle = DEGREES_TO_RADIANS(0);
    
    // Hold some data
    static CGFloat prevXOffset = 0;
    static CGFloat maxXOffset = 0;
    static CGFloat maxAngle = 0;
    
    // The gesture is moving
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // Necessary for calculating angle
        CGFloat xOffset =  [panGestureRecognizer translationInView:self.view].x;
        CGFloat previousAngle = atan2(graphicView.layer.transform.m31, graphicView.layer.transform.m11);
        
        // Calculate the angle of rotation and distance to pull colorScheme selector
        CGFloat angle;
        
        if (xOffset > prevXOffset) {
            // We dragged right
            angle = previousAngle - ((maxPullAngle - fabs(previousAngle)) * (xOffset / self.view.bounds.size.width));
            
            // Save for when we slide left (this is our new max bound)
            maxAngle = angle;
            maxXOffset = xOffset;
        } else if (maxAngle == 0) {
            // We are dragging left first
            angle = previousAngle + ((minPullAngle - fabs(previousAngle)) * (xOffset / self.view.bounds.size.width));
        } else {
            // We dragged left (after dragging right)
            angle = maxAngle *  (xOffset / maxXOffset);
        }
        
        // Angle is negative
        angle = angle < 0 ? angle : 0;
        
        // The width of the picker follows the ratio
        CGFloat pickerXOffset = (self.view.bounds.size.width / 2.0f) * fabs(angle / maxPullAngle);
        
        // Hold the last position (necessary to calculate angle and offset)
        prevXOffset = xOffset;
        
        // The rotation transform
        CATransform3D rotationTransform = CATransform3DIdentity;
        rotationTransform.m34 = 1.0f / -500;
        rotationTransform = CATransform3DRotate(rotationTransform, angle, 0.0f, 1.0f, 0.0f);
        entryTitleField.layer.transform = rotationTransform;
        graphicView.layer.transform = rotationTransform;
        
        // Move the colorPicker tableview in (careful of NAN width)
        colorPickerController.tableView.frame = CGRectMake(0, 0, pickerXOffset == NAN ? 0 : pickerXOffset, self.view.bounds.size.height);
        return;
    }
    
    // The gesture ended
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Reset static max angle (the max angle is the farthest angle for any continuing complete drag)
        maxAngle = 0;
        
        // Hide or show depending on the angle
        CGFloat endAngle = atan2(graphicView.layer.transform.m31, graphicView.layer.transform.m11);
        if (endAngle > suspendedAngle) {
            [self hideColorPicker];
        } else {
            [self showColorPicker];
        }
    }
}

- (void)showColorPicker {
    // Animate to suspended position
    CATransform3D rotateTransform = CATransform3DIdentity;
    rotateTransform.m34 = 1.0f / -500;
    rotateTransform = CATransform3DRotate(rotateTransform, DEGREES_TO_RADIANS(-55), 0.0f, 1.0f, 0.0f);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        entryTitleField.layer.transform = rotateTransform;
        graphicView.layer.transform = rotateTransform;
        colorPickerController.tableView.frame = CGRectMake(0, 0, 2 * self.view.bounds.size.width / 5.0f, self.view.bounds.size.height);
    } completion:nil];
}

- (void)hideColorPicker {
    // Animate back into place
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        entryTitleField.layer.transform = CATransform3DIdentity;
        graphicView.layer.transform = CATransform3DIdentity;
        colorPickerController.tableView.frame = CGRectMake(0, 0, 0, self.view.bounds.size.height);
    } completion:^(BOOL completion) {
        colorPickerIsVisible = NO;
    }];
}

#pragma mark - Entry picker

- (void)revealEntryPicker:(UIPanGestureRecognizer *)sender {
    // Get where we are panning
    CGFloat yTracking = [sender locationInView:self.view].y;
    CGFloat entryPickerWidth = entryPickerController.view.bounds.size.width;
    CGFloat entryPickerHeight = entryPickerController.view.bounds.size.height;
    CGFloat suspendedYPosition = self.view.frame.size.height - entryPickerController.view.frame.size.height + 1;

    // State logic
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if (yTracking < suspendedYPosition || (entryPickerIsVisible && [sender velocityInView:self.view].y < 0)) {
                // Cancel the gesture if we are out of range or we are bouncing up (bug?)
                sender.enabled = NO;
                sender.enabled = YES;
                return;
            } else {
                // Animate quickly to where our finger is
                [UIView animateWithDuration:0.3 animations:^{
                    entryPickerController.view.frame = CGRectMake(0, yTracking, entryPickerWidth, entryPickerHeight);
                }];
                
                // From this point our entry picker is visible
                entryPickerIsVisible = YES;
            }
            break;
        }
        
        case UIGestureRecognizerStateChanged: {
            // Move to where the finger is
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                if (yTracking < suspendedYPosition) {
                    // If we are out of range
                    entryPickerController.view.frame = CGRectMake(0, suspendedYPosition, entryPickerWidth, entryPickerHeight);
                } else {
                    entryPickerController.view.frame = CGRectMake(0, yTracking, entryPickerWidth, entryPickerHeight);
                }
            }completion:nil];
            break;
        }
        
        case UIGestureRecognizerStateEnded: {
            // Animate the view to either suspended or hidden
            CGFloat hideThreshold = self.view.frame.size.height - entryPickerController.view.frame.size.height / 2;
            if (yTracking > hideThreshold) {
                // Hide if we are out of bounds or near bottom
                [self hideEntryPicker];
            } else {
                // Show otherwise
                [self showEntryPicker];
            }
            break;
        }

        default:
            break;
    }
}

- (void)showEntryPicker {
    [UIView animateWithDuration:0.3f animations:^{
        entryPickerController.view.frame = CGRectMake(0, self.view.frame.size.height - entryPickerController.view.frame.size.height + 1, entryPickerController.view.frame.size.width, entryPickerController.view.frame.size.height);
    }];
}

- (void)hideEntryPicker {
    [UIView animateWithDuration:0.3f animations:^{
        entryPickerController.view.frame = CGRectMake(0, self.view.frame.size.height, entryPickerController.view.frame.size.width, entryPickerController.view.frame.size.height);
    } completion:^(BOOL finished){
        entryPickerController.editing = NO;
        entryPickerIsVisible = NO;
    }];
}

#pragma mark - should we accept the gesture based on the state?

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (tutorialIsInProgress || [entryTitleField isFirstResponder]) {
        // Don't do anything if the tutorial is in progress or keyboard is up
        return NO;
    }
    
    // All of our other gesture recognizers
    if (gestureRecognizer == panToExposeColorPicker) {
        return !datePickerIsVisible && !entryPickerIsVisible;
    } else if (gestureRecognizer == tapToShowDatePicker) {
        return !colorPickerIsVisible;
    } else if (gestureRecognizer == panToExposeEntryPicker) {
        return !colorPickerIsVisible && !datePickerIsVisible;
    } else if (gestureRecognizer == tapToReset) {
        return !datePickerIsVisible;
    }
    
    // Otherwise fuck it
    return YES;
}

#pragma mark - title field delegate

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
    [self.dataManager setActiveEntryObject:textField.text forKey:@"title"];
}

#pragma mark - Tutorial

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (!tutorialIsInProgress) {
            
            // Hide views
            [self hideColorPicker];
            [self hideEntryPicker];
            [self hideDatePicker];
            
            // Begin tutorial
            [self tutorial:nil];
        }
    }
}

- (void)tutorial:(UIButton *)sender {
    // Set flag
    tutorialIsInProgress = YES;
    
    // Create tutorial view lazily on first step
    if (!tutorialView) {
        // Create tutorial view
        tutorialView = [[SinceTutorialView alloc] initWithFrame:CGRectZero];
        tutorialView.backgroundColor = [UIColor clearColor];
        tutorialView.layer.zPosition = 500;
        tutorialView.alpha = 0.0;
        [tutorialView.actionButton setTag:1];
        [tutorialView.actionButton addTarget:self action:@selector(tutorial:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tutorialView];
    }
    
    // Array of steps for tutorial
    NSArray *tutorialSteps = [self tutorialSteps];
    
    // Keep track of what step we are on; execute, increment, and continue
    NSInteger stepCount = sender ? [sender tag] : 0;
    void (^performStep)() = (void (^)())[tutorialSteps objectAtIndex:stepCount];
    performStep();
    [sender setTag:stepCount + 1];
}

- (NSArray *)tutorialSteps {
    // Create a block for each step
    void (^introStep)() = ^{
        // Into step
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 200, 125);
            tutorialView.center = self.view.center;
            tutorialView.textLabel.text = @"Welcome to Since!\nPress to continue";
            tutorialView.direction = SinceTutorialLabelSpeechDirectionNone;
        } completion:nil];
    };
    void (^overviewStep)() = ^{
        // Overview step
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 200, 170);
            tutorialView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 3 / 5);
            tutorialView.direction = SinceTutorialLabelSpeechDirectionUp;
            tutorialView.textLabel.text = @"The display shows the number of days since your date of choice";
        } completion:nil];
    };
    void (^arcStep)() = ^{
        // Arc description step
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 250, 185);
            tutorialView.center = tutorialView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 3 / 5);
            tutorialView.textLabel.text = @"Colorful arcs represent the minute, hour, day, week, month, year, etc. Tap the display to animate the arcs";
        } completion:^{
            [self resetCurrentDisplay];
        }];
    };
    void (^titleStep)() = ^{
        // Title step
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 200, 170);
            tutorialView.center = CGPointMake(self.view.center.x, entryTitleField.frame.size.height);
            tutorialView.direction = SinceTutorialLabelSpeechDirectionUp;
            tutorialView.textLabel.text = @"You can title the dates you choose to track. Tap to change the title";
        } completion:nil];
    };
    void (^dateStep)() = ^{
        // Date picker step
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 250, 180);
            tutorialView.center = CGPointMake(self.view.center.x, datePicker.frame.origin.y + datePicker.bounds.size.height / 3);
            tutorialView.direction = SinceTutorialLabelSpeechDirectionDown;
            tutorialView.textLabel.text = @"Double tap the display to edit the date. After choosing a date, double tap again to select it";
        } completion:^{
            [self showDatePicker];
        }];
    };
    void (^colorStep)() = ^{
        // Color picker step
        [self hideDatePicker];
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 150, 290);
            tutorialView.center = CGPointMake(self.view.bounds.size.width * 2 / 5, self.view.center.y);
            tutorialView.direction = SinceTutorialLabelSpeechDirectionLeft;
            tutorialView.textLabel.text = @"There are over 12 brilliant color schemes to choose from. Drag to the right to select a color scheme";
        } completion:^{
            [self showColorPicker];
        }];
    };
    void (^entryStep)() = ^{
        // Entry picker step
        [self hideColorPicker];
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 200, 215);
            tutorialView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height * 7 / 8);
            tutorialView.direction = SinceTutorialLabelSpeechDirectionDown;
            tutorialView.textLabel.text = @"Since allows you to track multiple dates for 99¢. Drag up from the bottom to create or select a date. Press and hold to edit";
        } completion:^{
            [self showEntryPicker];
        }];
    };
    void (^outroStep)() = ^{
        // Final outro step
        [self hideEntryPicker];
        
        // Text
        NSString *text = @"Thank you for downloading Since! Report a bug or leave a review here. Shake iPhone anytime to replay this tutorial. Good luck and happy counting";
        
        // Generic font type
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        UIFont *light = tutorialView.textLabel.font;
        UIColor *color = tutorialView.textLabel.textColor;
        NSDictionary *mainAttributes = [NSDictionary dictionaryWithObjectsAndKeys:light, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, color, NSForegroundColorAttributeName, nil];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:mainAttributes];
        
        // Hyperlink
        UIFont *bold = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        NSURL *appStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/since-a-colorful-day-counter/id981958143?ls=1&mt=8"];
        NSDictionary *urlAttributes = [NSDictionary dictionaryWithObjectsAndKeys:bold, NSFontAttributeName, appStoreURL, NSLinkAttributeName, nil];
        NSRange linkRange = [text rangeOfString:@"here"];
        [attrStr addAttributes:urlAttributes range:linkRange];
        
        // Transition
        [tutorialView fadeTransitions:^{
            tutorialView.frame = CGRectMake(0, 0, 250, 190);
            tutorialView.center = self.view.center;
            tutorialView.direction = SinceTutorialLabelSpeechDirectionNone;
            tutorialView.textLabel.attributedText = attrStr;
        } completion:nil];
    };
    void (^endStep)() = ^{
        [tutorialView fadeTransitions:^{
            [tutorialView removeFromSuperview];
            tutorialView = nil;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialWasViewed"];
        } completion:^{
            tutorialIsInProgress = NO;
        }];
    };
    
    // Add to array
    NSArray *tutorialSteps = [NSArray arrayWithObjects:introStep, overviewStep, arcStep, titleStep, dateStep, colorStep, entryStep, outroStep, endStep, nil];
    return tutorialSteps;
}

@end
