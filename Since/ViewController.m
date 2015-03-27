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

#import "ViewController.h"
#import "CounterGraphicView.h"
#import "CustomDatePicker.h"
#import "ColorSchemes.h"

@interface ViewController ()
{
    // Data
    NSDate *sinceDate;
    
    // UI elements
    CounterGraphicView *graphicView;
    CustomDatePicker *datePicker;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide the navigation controller
    self.navigationController.navigationBarHidden = YES;
    
    // Get our components since the last occurrence
    sinceDate = [self retrieveSinceDate];
    
    // Register for notifications that we entered/exited the app
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetGraphicView) name:@"UIApplicationWillEnterForegroundNotification" object:nil];
    
    // Test view class
    graphicView = [[CounterGraphicView alloc] initWithSuperView:self.view];
    UITapGestureRecognizer *tapToShow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    tapToShow.numberOfTapsRequired = 2;
    [graphicView addGestureRecognizer:tapToShow];
}

- (void)viewDidAppear:(BOOL)animated {
    [graphicView resetView:[self componentsArrayWithDate:sinceDate] colors:[ColorSchemes colorSchemeWithName:@"scheme1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Date and data methods

- (NSDate *)retrieveSinceDate {
    return [NSDate dateWithTimeIntervalSinceNow:-384756];
}

- (void)showDatePicker {
    if (datePicker == nil) {
        datePicker = [[CustomDatePicker alloc] init];
        UITapGestureRecognizer *tapToHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePicker)];
        tapToHide.numberOfTapsRequired = 2;
        [datePicker addGestureRecognizer:tapToHide];
    }
    
    datePicker.colorScheme = [[ColorSchemes colorSchemeWithName:@"scheme1"] objectForKey:@"pickerColors"];
    datePicker.alpha = 0.0f;
    [self.view addSubview:datePicker];
    datePicker.center = self.view.center;
    [UIView animateWithDuration:0.3f animations:^{
        graphicView.alpha = 0.0f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.3f animations:^{
            datePicker.alpha = 1.0f;
        }];
    }];
}

- (void)hideDatePicker {
    [UIView animateWithDuration:0.3f animations:^{
        datePicker.alpha = 0.0f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.3f animations:^{
            graphicView.alpha = 1.0f;
        }];
        NSDate *chosenDate = [datePicker date];
        if (chosenDate) {
            sinceDate = chosenDate;
        }
        [graphicView resetView:[self componentsArrayWithDate:sinceDate] colors:[ColorSchemes colorSchemeWithName:@"scheme1"]];
    }];
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

#pragma mark - Drawing methods

- (void)resetGraphicView {
    [graphicView resetView:[self componentsArrayWithDate:sinceDate] colors:[ColorSchemes colorSchemeWithName:@"scheme1"]];
}

@end
