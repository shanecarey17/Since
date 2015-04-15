//
//  ViewController.m
//  Since
//
//  Created by Shane Carey on 3/24/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define   PI 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((PI * degrees)/ 180)
#define   RAND_FLOAT ((double)arc4random() / 0x100000000)

#import "SinceViewController.h"
#import "SinceDateCounterGraphicView.h"
#import "SinceDatePicker.h"
#import "ColorSchemes.h"
#import "SinceColorSchemePickerCell.h"
#import "UIView+AnchorPosition.h"

@interface SinceViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

{
    // UI elements
    SinceDateCounterGraphicView *graphicView;
    SinceDatePicker *datePicker;
    UITableView *colorSchemePicker;
    
    // Gestures
    UITapGestureRecognizer *tapToReset;
    UITapGestureRecognizer *tapToShowDatePicker;
    UIPanGestureRecognizer *panToExposeColorPicker;
    
    // State flags
    BOOL datePickerIsVisible;
    BOOL colorPickerIsVisible;
}

@end

@implementation SinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register for a notification to reset graphic view on open
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGraphicView) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    // Initialize subiews (date picker under graphic view)
    [self initColorPicker];
    [self initDatePicker];
    [self initGraphicView];
}

- (void)initGraphicView {
    // Set up graphics view
    graphicView = [[SinceDateCounterGraphicView alloc] initWithSuperView:self.view];
    
    // Double tap
    tapToShowDatePicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePickerControl)];
    tapToShowDatePicker.numberOfTapsRequired = 2;
    tapToShowDatePicker.delegate = self;
    [graphicView addGestureRecognizer:tapToShowDatePicker];
    
    // Single tap
    tapToReset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetGraphicView)];
    [graphicView addGestureRecognizer:tapToReset];
    [tapToReset requireGestureRecognizerToFail:tapToShowDatePicker];
    
    // Pan
    panToExposeColorPicker = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragColorSchemePicker:)];
    panToExposeColorPicker.delegate = self;
    [graphicView addGestureRecognizer:panToExposeColorPicker];
}

- (void)initColorPicker {
    // Tableview for color picking
    colorSchemePicker = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, self.view.bounds.size.height)];
    colorSchemePicker.delegate = self;
    colorSchemePicker.dataSource = self;
    colorSchemePicker.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    colorSchemePicker.separatorColor = [UIColor clearColor];
    colorSchemePicker.showsVerticalScrollIndicator = NO;
    [self.view addSubview:colorSchemePicker];
    
    // Set flag
    colorPickerIsVisible = NO;
}

- (void)initDatePicker {
    // Date picker
    datePicker = [[SinceDatePicker alloc] init];
    datePicker.center = CGPointMake(self.view.center.x, (self.view.bounds.size.width + self.view.bounds.size.height) / 2);
    datePicker.alpha = 0.0f;
    [self.view addSubview:datePicker];
    
    // Set flag
    datePickerIsVisible = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    // Reset the view on open
    [self resetGraphicView];
}

#pragma mark - Date picker

- (void)datePickerControl {
    // If the date picker is not visible
    if (!datePickerIsVisible) {
        // Set the color scheme and dat
        datePicker.colorScheme = [_colorScheme objectForKey:@"pickerColors"];
        datePicker.date = _sinceDate;
        
        // Show the picker
        [self showDatePicker];
        
    } else {
        // Date picker is visible
        NSDate *chosenDate = [datePicker date];
        if (chosenDate == nil) {
            // Shake for invalid date
            [self datePickerInvalidShake];
            
            // Return before we set the flag (we didn't show
            return;
            
        } else {
            // We have a valid date
            _sinceDate = chosenDate;
            
            // Set and hide date picker
            [self hideDatePicker];
        }
    }
}

- (void)datePickerInvalidShake {
    // Animate a headshake for invalid date
    CGPoint center = datePicker.center;
    [UIView animateKeyframesWithDuration:0.75f delay:0.0f options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        // Add keyframes to shake
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.125f animations:^{
            datePicker.center = CGPointMake(center.x + 10, center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.125f relativeDuration:0.125f animations:^{
            datePicker.center = CGPointMake(center.x - 10, center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.25f relativeDuration:0.125f animations:^{
            datePicker.center = CGPointMake(center.x + 10, center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.375f relativeDuration:0.125f animations:^{
            datePicker.center = CGPointMake(center.x - 10, center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.125f animations:^{
            datePicker.center = CGPointMake(center.x + 10, center.y);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.625f relativeDuration:0.125f animations:^{
            datePicker.center = center;
        }];
        
    } completion:^(BOOL finished){
        // Scroll back to original date
        [datePicker setDate:_sinceDate];
    }];
}

- (void)showDatePicker {
    // Animate graphic translate up
    [UIView animateWithDuration:0.3f animations:^{
        graphicView.center = CGPointMake(graphicView.center.x, graphicView.center.y - 50);
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
            graphicView.center = self.view.center;
        } completion:^(BOOL finished){
            // Reset view with date
            [self resetGraphicView];
        }];
    }];
    
    // Set flag
    datePickerIsVisible = NO;
}

#pragma mark - Graphic View

- (void)resetGraphicView {
    [graphicView resetView:_sinceDate colors:_colorScheme];
}

#pragma mark - Color picker

- (void)dragColorSchemePicker:(UIPanGestureRecognizer *)panGestureRecognizer {
    // Hold on to this
    static CGFloat startingAngle;
    
    // If we are beginning our pan, change the anchor point of the view
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // Change anchor point
        [graphicView setAnchorPointAdjustPosition:CGPointMake(0.75, 0.5)];
        
        // Get the starting angle of the view (this is constant for entire pan gesture)
        startingAngle = atan2(graphicView.layer.transform.m31, graphicView.layer.transform.m11);
        return;
    }
    
    // Get the x offset
    CGFloat xOffset =  [panGestureRecognizer translationInView:self.view].x;
    CGFloat previousAngle = atan2(graphicView.layer.transform.m31, graphicView.layer.transform.m11);
    
    // Constants
    const CGFloat suspendedAngle = DEGREES_TO_RADIANS(-55);
    const CGFloat maxPullAngle = DEGREES_TO_RADIANS(70);
    const CGFloat minPullAngle = DEGREES_TO_RADIANS(0);
    
    // Hold some data
    static CGFloat prevXOffset = 0;
    static CGFloat maxXOffset = 0;
    static CGFloat maxAngle = 0;
    
    // The gesture is continuing
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // Calculate the angle of rotation and distance to pull colorScheme selector
        CGFloat angle;
        
        // Determine angle
        if (startingAngle == 0) {
            // We are dragging from resting position
            if (xOffset > prevXOffset) {
                // We dragged right
                angle = previousAngle - ((maxPullAngle - fabs(previousAngle)) * (xOffset / self.view.bounds.size.width));
                
                // Save for when we slide left (this is our new max bound)
                maxAngle = angle;
                maxXOffset = xOffset;
            } else {
                // We dragged left
                angle = maxAngle *  (xOffset / maxXOffset);
            }
        } else {
            // We are dragging from suspended position
            if (xOffset > prevXOffset) {
                // We dragged right
                angle = previousAngle - ((maxPullAngle - fabs(previousAngle)) * (xOffset / self.view.bounds.size.width));
                
                // Save for when we slide left (this is our new max bound)
                maxAngle = angle;
                maxXOffset = xOffset;
            } else {
                // We dragged left
                if (maxAngle == 0) {
                    // We are dragging left first
                    angle = previousAngle + ((minPullAngle - fabs(previousAngle)) * (xOffset / self.view.bounds.size.width));
                } else {
                    // We have already dragged right, this is continuing left
                    angle = maxAngle *  (xOffset / maxXOffset);
                }
            }
        }
        
        // We don't want to rotate into positive angles (left side into screen)
        if (angle > 0.0f) {
            angle = 0.0f;
        }
        
        // The width of the picker follows the ratio
        // width/(view.width / 2) == angle/maxPullAngle
        CGFloat pickerXOffset = (self.view.bounds.size.width / 2.0f) * fabs(angle / maxPullAngle);
        
        // Hold the last position (necessary to calculate angle and offset)
        prevXOffset = xOffset;
        
        // The transform
        CATransform3D rotationTransform = CATransform3DIdentity;
        rotationTransform.m34 = 1.0f / -500;
        rotationTransform = CATransform3DRotate(rotationTransform, angle, 0.0f, 1.0f, 0.0f);
        graphicView.layer.transform = rotationTransform;
        
        // Move the colorPicker tableview in (wierd exception when offset approaches 0)
        @try {
            colorSchemePicker.frame = CGRectMake(0, 0, pickerXOffset, self.view.bounds.size.height);
        }
        @catch (NSException *exception) {
            colorSchemePicker.frame = CGRectMake(0, 0, 0, self.view.bounds.size.height);
        }
        return;
    }
    
    // The gesture ended
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Reset static max angle (the max angle is the farthest angle for any continuing complete drag)
        maxAngle = 0;
        
        // Set duration of return value
        CGFloat returnAnimationDuration = 0.3f;
        
        if (previousAngle > suspendedAngle) {
            // Animate back into place
            [UIView animateWithDuration:returnAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                graphicView.layer.transform = CATransform3DIdentity;
                colorSchemePicker.frame = CGRectMake(0, 0, 0, self.view.bounds.size.height);
            } completion:^(BOOL completion) {
                [graphicView setAnchorPointAdjustPosition:CGPointMake(0.5, 0.5)];
                colorPickerIsVisible = NO;
            }];
            
        } else {
            // Animate to suspended position
            CATransform3D rotateTransform = CATransform3DIdentity;
            rotateTransform.m34 = 1.0f / -500;
            rotateTransform = CATransform3DRotate(rotateTransform, suspendedAngle, 0.0f, 1.0f, 0.0f);
            [UIView animateWithDuration:returnAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                graphicView.layer.transform = rotateTransform;
                colorSchemePicker.frame = CGRectMake(0, 0, 2 * self.view.bounds.size.width / 5.0f, self.view.bounds.size.height);
            } completion:^(BOOL finished){
                colorPickerIsVisible = YES;
            }];
            
        }
    }
}

#pragma mark - Color Picker tableview delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ColorSchemes colorSchemes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinceColorSchemePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colorSchemeCell"];
    if (cell == nil) {
        // Initialize cell
        cell = [[SinceColorSchemePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorSchemeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    // Provide data
    NSMutableArray *sortedKeys = [[ColorSchemes colorSchemes] mutableCopy];
    [sortedKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    cell.colorScheme = [ColorSchemes colorSchemeWithName:[sortedKeys objectAtIndex:indexPath.row]];
    cell.label.text = [sortedKeys objectAtIndex:indexPath.row];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.width / 5 * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _colorScheme = [(SinceColorSchemePickerCell *)[tableView cellForRowAtIndexPath:indexPath] colorScheme];
    [self resetGraphicView];
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == panToExposeColorPicker) {
        // We only pan if the date picker is not visible
        if (!datePickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    } else {
        // We only show date picker if color picker is not visible
        if (!colorPickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
