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
#import "SinceDataManager.h"
#import "SinceColorSchemePickerTableView.h"
#import "SinceColorSchemePickerCell.h"
#import "SinceEntryPickerCollectionView.h"
#import "UIView+AnchorPosition.h"

@interface SinceViewController () <UITableViewDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate>

{
    // UI elements
    SinceDateCounterGraphicView *graphicView;
    SinceDatePicker *datePicker;
    SinceColorSchemePickerTableView *colorSchemePicker;
    SinceEntryPickerCollectionView *entryPicker;
    
    // Gestures
    UITapGestureRecognizer *tapToReset;
    UITapGestureRecognizer *tapToShowDatePicker;
    UIPanGestureRecognizer *panToExposeColorPicker;
    UIPanGestureRecognizer *panToExposeEntryPicker;
    
    // State flags
    BOOL datePickerIsVisible;
    BOOL colorPickerIsVisible;
    BOOL entryPickerIsVisible;
}

@end

@implementation SinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register for a notification to reset graphic view on open
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGraphicView) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
    
    // Initialize subiews (date picker under graphic view)
    [self initColorPicker];
    [self initDatePicker];
    [self initGraphicView];
    [self initEntryPicker];
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
    colorSchemePicker = [[SinceColorSchemePickerTableView alloc] initWithFrame:CGRectMake(0, 0, 0, self.view.bounds.size.height)];
    colorSchemePicker.delegate = self;
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

- (void)initEntryPicker {
    entryPicker = [[SinceEntryPickerCollectionView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height / 7)];
    entryPicker.delegate = self;
    UILongPressGestureRecognizer *holdToEdit = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editEntryPicker)];
    holdToEdit.minimumPressDuration = 1.0;
    [entryPicker addGestureRecognizer:holdToEdit];
    
    panToExposeEntryPicker = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(revealEntryPicker:)];
    panToExposeEntryPicker.cancelsTouchesInView = NO;
    panToExposeEntryPicker.delegate = self;
    [self.view addGestureRecognizer:panToExposeEntryPicker];
    
    [self.view addSubview:entryPicker];
}

- (void)viewDidAppear:(BOOL)animated {
    // Reset the view on open
    [self resetGraphicView];
}

#pragma mark - Date picker

- (void)datePickerControl {
    // If the date picker is not visible
    if (!datePickerIsVisible) {
        // Set the color scheme and date
        datePicker.colorScheme = [_entry objectForKey:@"colorScheme"];
        datePicker.date = [_entry objectForKey:@"sinceDate"];
        
        // Show the picker
        [self showDatePicker];
        
    } else {
        // Date picker is visible
        NSDate *chosenDate = [datePicker date];
        if (chosenDate == nil) {
            // Shake for invalid date
            [self datePickerInvalidShake];
            
        } else {
            // We have a valid date
            [_entry setObject:chosenDate forKey:@"sinceDate"];
            [entryPicker reloadData];
            
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
        [datePicker setDate:[_entry objectForKey:@"sinceDate"]];
    }];
}

- (void)showDatePicker {
    // Animate graphic translate up and hide entry view
    [self hideEntryPicker];
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
    [graphicView resetView:[_entry objectForKey:@"sinceDate"] colors:[_entry objectForKey:@"colorScheme"]];
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
        if (previousAngle > suspendedAngle) {
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
        graphicView.layer.transform = rotateTransform;
        colorSchemePicker.frame = CGRectMake(0, 0, 2 * self.view.bounds.size.width / 5.0f, self.view.bounds.size.height);
    } completion:^(BOOL finished){
        colorPickerIsVisible = YES;
    }];
}

- (void)hideColorPicker {
    // Animate back into place
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        graphicView.layer.transform = CATransform3DIdentity;
        colorSchemePicker.frame = CGRectMake(0, 0, 0, self.view.bounds.size.height);
    } completion:^(BOOL completion) {
        [graphicView setAnchorPointAdjustPosition:CGPointMake(0.5, 0.5)];
        colorPickerIsVisible = NO;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *colorScheme = [(SinceColorSchemePickerCell *)[tableView cellForRowAtIndexPath:indexPath] colorScheme];
    [_entry setObject:colorScheme forKey:@"colorScheme"];
    [self resetGraphicView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 2 * self.view.bounds.size.width / 5;
}

#pragma mark - Entry picker

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (entryPicker.editing) {
        // Stop editing the picker
        entryPicker.editing = NO;
    } else {
        // Let's do something with the cell we chose
        NSMutableDictionary *chosenEntry;
        if (indexPath.row == [[SinceDataManager sharedManager] numEntries]) {
            // Create a new entry
            chosenEntry = [[SinceDataManager sharedManager] newData];
            [[SinceDataManager sharedManager] addData:chosenEntry];
            
            // Animated insertion
            NSIndexPath *insertIndex = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
            [collectionView insertItemsAtIndexPaths:@[insertIndex]];
            [collectionView reloadItemsAtIndexPaths:@[insertIndex]];
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        } else {
            // Show the chosen entry
            chosenEntry = [[SinceDataManager sharedManager] dataAtIndex:indexPath.row];
            [self hideEntryPicker];
        }
        
        // Update view
        _entry = chosenEntry;
        [self resetGraphicView];
    }
}

- (void)editEntryPicker {
    entryPicker.editing = YES;
}

- (void)revealEntryPicker:(UIPanGestureRecognizer *)sender {
    // Get where we are panning
    CGFloat yTracking = [sender locationInView:self.view].y;
    if (yTracking < self.view.frame.size.height * 6 / 7) {
        // Cancel the gesture
        sender.enabled = NO;
        sender.enabled = YES;
    }

    // State logic
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            if ([sender velocityInView:entryPicker].y < 0 && entryPickerIsVisible) {
                // Don't let the view jump up if we pull up form suspended
            } else {
                // Animate quickly to where our finger is
                [UIView animateWithDuration:0.3 animations:^{
                    entryPicker.frame = CGRectMake(0, yTracking, entryPicker.frame.size.width, entryPicker.frame.size.height);
                }];
                
                // From this point our entry picker is visible
                entryPickerIsVisible = YES;
            }
            break;
        }
        
        case UIGestureRecognizerStateChanged: {
            // Move to where the finger is
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                entryPicker.frame = CGRectMake(0, yTracking, entryPicker.frame.size.width, entryPicker.frame.size.height);
            }completion:^(BOOL finished){
                // nothing here
            }];
            break;
        }
        
        case UIGestureRecognizerStateEnded: case UIGestureRecognizerStateCancelled: {
            // Animate the view to either suspended or hidden (depending on where our finger left off)
            if ([sender locationInView:self.view].y < self.view.frame.size.height * 13 / 14) {
                [self showEntryPicker];
            } else {
                [self hideEntryPicker];
            }
            break;
        }

        default:
            break;
    }
}

- (void)showEntryPicker {
    [UIView animateWithDuration:0.3f animations:^{
        entryPicker.frame = CGRectMake(0, self.view.frame.size.height * 6 / 7, entryPicker.frame.size.width, entryPicker.frame.size.height);
    }];
}

- (void)hideEntryPicker {
    [UIView animateWithDuration:0.3f animations:^{
        entryPicker.frame = CGRectMake(0, self.view.frame.size.height, entryPicker.frame.size.width, entryPicker.frame.size.height);
    } completion:^(BOOL finished){
        entryPickerIsVisible = NO;
    }];
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == panToExposeColorPicker) {
        // We only pan if the date picker is not visible
        if (!datePickerIsVisible && !entryPickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    } else if (gestureRecognizer == tapToShowDatePicker) {
        // We only show date picker if color picker is not visible (entry picker animates away)
        if (!colorPickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    } else if (gestureRecognizer == panToExposeEntryPicker) {
        // Same shit
        if (!colorPickerIsVisible && !datePickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    }
    
    // Otherwise fuck it
    return YES;
}

@end
