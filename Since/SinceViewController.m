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
    // Data
    NSDate *sinceDate;
    NSDictionary *colorScheme;
    
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
    
    // Hide the navigation controller
    self.navigationController.navigationBarHidden = YES;
    
    // Get our components since the last occurrence
    [self retrieveUserDefaults];
    
    // Register for notifications that we entered/exited the app
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGraphicView) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUserDefaults) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
    
    // Initialize subiews
    [self initGraphicView];
    [self initColorPicker];
    [self initDatePicker];
}

- (void)initGraphicView {
    // Set up graphics view
    graphicView = [[SinceDateCounterGraphicView alloc] initWithSuperView:self.view];
    tapToReset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetGraphicView)];
    [graphicView addGestureRecognizer:tapToReset];
    tapToShowDatePicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    tapToShowDatePicker.numberOfTapsRequired = 2;
    tapToShowDatePicker.delegate = self;
    [graphicView addGestureRecognizer:tapToShowDatePicker];
    [tapToReset requireGestureRecognizerToFail:tapToShowDatePicker];
    UIPanGestureRecognizer *dragToShowColorSchemePicker = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragColorSchemePicker:)];
    dragToShowColorSchemePicker.delegate = self;
    [graphicView addGestureRecognizer:dragToShowColorSchemePicker];
}

- (void)initColorPicker {
    // Tableview for color picking
    colorSchemePicker = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, self.view.bounds.size.height)];
    colorSchemePicker.delegate = self;
    colorSchemePicker.dataSource = self;
    colorSchemePicker.backgroundColor = [UIColor darkGrayColor];
    colorSchemePicker.separatorColor = [UIColor clearColor];
    colorSchemePicker.showsVerticalScrollIndicator = NO;
    [self.view addSubview:colorSchemePicker];
    
    // Set flag
    colorPickerIsVisible = NO;
}

- (void)initDatePicker {
    // Date picker
    datePicker = [[SinceDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width / 3 * 2, self.view.bounds.size.height - self.view.bounds.size.width)];
    datePicker.center = CGPointMake(self.view.center.x, (self.view.bounds.size.width + self.view.bounds.size.height) / 2);
    datePicker.alpha = 0.0f;
    [self.view addSubview:datePicker];
    
    // Set flag
    datePickerIsVisible = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [self resetGraphicView];
}

#pragma mark - Date and data methods

- (void)saveUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:sinceDate forKey:@"sinceDate"];
    NSData *colorSchemeData = [NSKeyedArchiver archivedDataWithRootObject:colorScheme];
    [[NSUserDefaults standardUserDefaults] setObject:colorSchemeData forKey:@"colorScheme"];
}

- (void)retrieveUserDefaults {
    sinceDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinceDate"];
    colorScheme = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"colorScheme"]];
    if (colorScheme == nil) {
        colorScheme = [ColorSchemes randomColorScheme];
    }
}

#pragma mark - Date picker

- (void)showDatePicker:(UIGestureRecognizer *)sender {
    if (!datePickerIsVisible) {
        datePicker.colorScheme = [colorScheme objectForKey:@"pickerColors"];
        datePicker.date = sinceDate;
        [UIView animateWithDuration:0.3f animations:^{
            graphicView.center = CGPointMake(graphicView.center.x, graphicView.center.y - 50);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3f animations:^{
                datePicker.alpha = 1.0f;
            }];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            datePicker.alpha = 0.0f;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3f animations:^{
                graphicView.center = self.view.center;
            } completion:^(BOOL finished){
                [self resetGraphicView];
            }];
            NSDate *chosenDate = [datePicker date];
            if (chosenDate) {
                sinceDate = chosenDate;
            }
        }];
    }
    datePickerIsVisible = !datePickerIsVisible;
}

#pragma mark - Graphic View

- (void)resetGraphicView {
    [graphicView resetView:[self componentsArrayWithDate:sinceDate] colors:colorScheme];
}

- (NSArray *)componentsArrayWithDate:(NSDate *)date {
    NSInteger intervalSinceDate = (NSInteger)[[NSDate date] timeIntervalSinceDate:date];
    NSMutableArray *componentsArr = [[NSMutableArray alloc] init];
    // Day count is the first entry in the array
    [componentsArr addObject:@(intervalSinceDate / 86400)];
    // Day percentage
    [componentsArr addObject:@(intervalSinceDate % 86400 / 86400.f)];
    // Week percentage
    [componentsArr addObject:intervalSinceDate > 86400 ? @(intervalSinceDate % 604800 / 604800.f) : [NSNull null]];
    // Month percentage
    [componentsArr addObject:intervalSinceDate > 604800 ? @(intervalSinceDate % 2592000 / 2592000.f) : [NSNull null]];
    // Year percentage
    [componentsArr addObject:intervalSinceDate > 2592000 ? @(intervalSinceDate % 31536000 / 31536000.f) : [NSNull null]];
    // 2 year percentage
    [componentsArr addObject:intervalSinceDate > 31536000 ? @(intervalSinceDate % 63072000 / 63072000.f) : [NSNull null]];
    // 5 year percentage
    [componentsArr addObject:intervalSinceDate > 63072000 ? @(intervalSinceDate % 157680000 / 157680000.f) : [NSNull null]];
    // 10 year percentage
    [componentsArr addObject:intervalSinceDate > 157680000 ? @(intervalSinceDate % 315360000 / 315360000.f) : [NSNull null]];
    // Return a hard copy of the array
    return [NSArray arrayWithArray:componentsArr];
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

#pragma mark - colorpicker tableview delegate/datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ColorSchemes colorSchemes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinceColorSchemePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colorSchemeCell"];
    if (cell == nil) {
        cell = [[SinceColorSchemePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorSchemeCell"];
        cell.colorScheme = [ColorSchemes colorSchemeWithName:[[ColorSchemes colorSchemes] objectAtIndex:indexPath.row]];
        cell.label.text = [[ColorSchemes colorSchemes] objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.bounds.size.width / 5 * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    colorScheme = [(SinceColorSchemePickerCell *)[tableView cellForRowAtIndexPath:indexPath] colorScheme];
    [self resetGraphicView];
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) {
        if (!datePickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if (!colorPickerIsVisible) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end
