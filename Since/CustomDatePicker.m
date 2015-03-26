//
//  CustomDatePicker.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "CustomDatePicker.h"
#import "DatePickerTableViewCell.h"

@interface CustomDatePicker () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *monthTableView;
    UITableView *dayTableView;
    UITableView *yearTableView;
}

@end

@implementation CustomDatePicker

static NSArray *months = nil;

+ (void)initialize {
    [super initialize];
    if (!months) {
        months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialize table views to 1/3 the area
        monthTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width / 3, frame.size.height)];
        dayTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x + (frame.size.width / 3), frame.origin.y , frame.size.width / 3, frame.size.height)];
        yearTableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x + (2 * frame.size.width / 3), frame.origin.y , frame.size.width / 3, frame.size.height)];
        
        // Set delegates and datasources
        monthTableView.delegate = dayTableView.delegate = yearTableView.delegate = self;
        monthTableView.dataSource = dayTableView.dataSource = yearTableView.dataSource = self;
        
        // Customize
        monthTableView.separatorColor = dayTableView.separatorColor = yearTableView.separatorColor = [UIColor clearColor];
        monthTableView.backgroundColor = dayTableView.backgroundColor = yearTableView.backgroundColor = [UIColor clearColor];
        monthTableView.showsVerticalScrollIndicator = dayTableView.showsVerticalScrollIndicator = yearTableView.showsVerticalScrollIndicator = NO;
        monthTableView.scrollEnabled = dayTableView.scrollEnabled = yearTableView.scrollEnabled = NO;
        
        // Add subviews
        [self addSubview:monthTableView];
        [self addSubview:dayTableView];
        [self addSubview:yearTableView];
    }
    return self;
}

- (void)setColorScheme:(NSDictionary *)colorScheme {
    _colorScheme = colorScheme;
    self.backgroundColor = [colorScheme objectForKey:@"backgroundColor"];
}

- (NSDate *)date {
    // Get the cells
    DatePickerTableViewCell *monthCell = (DatePickerTableViewCell *)[monthTableView cellForRowAtIndexPath:[monthTableView indexPathForSelectedRow]];
    DatePickerTableViewCell *dayCell = (DatePickerTableViewCell *)[dayTableView cellForRowAtIndexPath:[dayTableView indexPathForSelectedRow]];
    DatePickerTableViewCell *yearCell = (DatePickerTableViewCell *)[yearTableView cellForRowAtIndexPath:[yearTableView indexPathForSelectedRow]];
    
    // Get the strings
    NSString *monthString = monthCell.label.text;
    NSString *dayString = dayCell.label.text;
    NSString *yearString = yearCell.label.text;
    
    // Formatted string
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d yyyy"];
    NSDate *dateFromString = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@ %@", monthString, dayString, yearString]];

    // Return nil if our date is in the future
    if ([dateFromString timeIntervalSinceNow] > 0) {
        return nil;
    }
    
    // Otherwise return our new date
    return dateFromString;
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == monthTableView) {
        return 12;
    } else if (tableView == dayTableView) {
        return 30;
    } else return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size.height / 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Grab a cell
    NSString *cellID = @"customCell";
    DatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.colorScheme = self.colorScheme;
    }
    
    // Customize cell text depending the tableview
    if (tableView == monthTableView) {
        cell.label.text = [months objectAtIndex:indexPath.row];
    } else if (tableView == dayTableView) {
        cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    } else {
        cell.label.text = [NSString stringWithFormat:@"%ld", 2015 - indexPath.row];
    }
    
    // Return the cell
    return cell;
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
