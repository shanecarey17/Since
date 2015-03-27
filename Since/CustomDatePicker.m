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
    
    CGFloat heightForCell;
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

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 300, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        // Customize self, add transparent gradient mask
        self.backgroundColor = [UIColor clearColor];
        
        // Set the height of the cell
        heightForCell = 100;
        
        // Initialize table views to 1/3 the area
        monthTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width / 3, self.frame.size.height)];
        dayTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x + (self.frame.size.width / 3), self.frame.origin.y , self.frame.size.width / 3, self.frame.size.height)];
        yearTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x + (2 * self.frame.size.width / 3), self.self.frame.origin.y , self.frame.size.width / 3, self.frame.size.height)];
        
        // Set delegates and datasources
        monthTableView.delegate = dayTableView.delegate = yearTableView.delegate = self;
        monthTableView.dataSource = dayTableView.dataSource = yearTableView.dataSource = self;
        
        // Customize
        monthTableView.separatorColor = dayTableView.separatorColor = yearTableView.separatorColor = [UIColor clearColor];
        monthTableView.backgroundColor = dayTableView.backgroundColor = yearTableView.backgroundColor = [UIColor clearColor];
        monthTableView.showsVerticalScrollIndicator = dayTableView.showsVerticalScrollIndicator = yearTableView.showsVerticalScrollIndicator = NO;
        
        // Scroll to center cell
        [monthTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:5000 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        [dayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:5000 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        [yearTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:5000 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        // Add subviews
        [self addSubview:monthTableView];
        [self addSubview:dayTableView];
        [self addSubview:yearTableView];
    }
    return self;
}

- (void)setColorScheme:(NSDictionary *)colorScheme {
    _colorScheme = colorScheme;
    
    [monthTableView reloadData];
    [dayTableView reloadData];
    [yearTableView reloadData];
}

- (NSDate *)date {
    // Get the cells
    NSInteger centerIndex = self.bounds.size.height / heightForCell / 2;
    DatePickerTableViewCell *monthCell = (DatePickerTableViewCell *)[monthTableView cellForRowAtIndexPath:[[monthTableView indexPathsForVisibleRows] objectAtIndex:centerIndex]];
    DatePickerTableViewCell *dayCell = (DatePickerTableViewCell *)[dayTableView cellForRowAtIndexPath:[[dayTableView indexPathsForVisibleRows] objectAtIndex:centerIndex]];
    DatePickerTableViewCell *yearCell = (DatePickerTableViewCell *)[yearTableView cellForRowAtIndexPath:[[yearTableView indexPathsForVisibleRows] objectAtIndex:centerIndex]];
    
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
    return 10000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return heightForCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Grab a cell
    NSString *cellID = @"customCell";
    DatePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DatePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    // Set the color scheme
    cell.colorScheme = self.colorScheme;
    
    // Customize cell text depending the tableview
    if (tableView == monthTableView) {
        cell.label.text = [months objectAtIndex:indexPath.row % 12];
    } else if (tableView == dayTableView) {
        cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.row % 31 + 1];
    } else {
        cell.label.text = [NSString stringWithFormat:@"%ld", 2015 - (indexPath.row % 50)];
    }
    
    // Return the cell
    return cell;
}

#pragma mark - tableview delegate

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (velocity.y == 0) {
        // Scroll to that index we selected in scrollViewDidScroll:
        [(UITableView *)scrollView scrollToRowAtIndexPath:[(UITableView *)scrollView indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    } else {
        // If there is velocity change the target offset
        CGFloat targetOffsetY = (*targetContentOffset).y;
        CGFloat offsetFromTop = (heightForCell - fmodf((float)self.bounds.size.height, (float)heightForCell)) / 2.0f;
        CGFloat adjustedTargetOffsetY = ((int)targetOffsetY / (int)heightForCell) * heightForCell + offsetFromTop;
        *targetContentOffset = CGPointMake((*targetContentOffset).x, adjustedTargetOffsetY);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Determine the direction we scroll
    CGFloat scrollVelocity = [[scrollView panGestureRecognizer] velocityInView:self].y;
    NSLog(@"%f", scrollVelocity);
    
    // Select the center cell depending on whether we scroll up or down
    NSArray *visibleIndexPaths = [(UITableView *)scrollView indexPathsForVisibleRows];
    NSInteger centerIndex = [visibleIndexPaths count] / 2;
    
    // If we scrolled down, decrease selected index
    if (scrollVelocity > 0) {
        centerIndex--;
    }
    
    [(UITableView *)scrollView selectRowAtIndexPath:visibleIndexPaths[centerIndex] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

@end
