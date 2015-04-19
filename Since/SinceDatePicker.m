//
//  CustomDatePicker.m
//  Since
//
//  Created by Shane Carey on 3/25/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define kNumCell 10000
#define kCenterCell kNumCell / 2
#define kCellHeight 100.0

#import "SinceDatePicker.h"
#import "SinceDatePickerCell.h"

@interface SinceDatePicker () <UITableViewDataSource, UITableViewDelegate>

{
    UITableView *monthTableView;
    UITableView *dayTableView;
    UITableView *yearTableView;
}

@end

@implementation SinceDatePicker

static NSArray *months = nil;

+ (void)initialize {
    [super initialize];
    if (!months) {
        months = @[@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"];
    }
}

- (id)init {
    // Constant frame for optimal looks and performance (otherwise something goes wrong with tableviewcell alignment)
    self = [super initWithFrame:CGRectMake(0, 0, 250, 300)];
    if (self) {
        // Self
        self.backgroundColor = [UIColor clearColor];
        
        // Create the mask
        CAGradientLayer *alphaMask = [self createAlphaMask];
        [self.layer setMask:alphaMask];
        
        // Set up the columns of the date picker
        [self initColumns];
    }
    return self;
}

- (CAGradientLayer *)createAlphaMask {
    // Customize self, add transparent gradient mask
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.locations = @[@0.3, @0.333, @0.666, @0.7];
    mask.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor];
    mask.frame = self.bounds;
    mask.startPoint = CGPointMake(0, 0);
    mask.endPoint = CGPointMake(0, 1);
    return mask;
}

- (void)initColumns {
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

#pragma mark - action methods

- (void)setColorScheme:(NSString *)colorScheme {
    _colorScheme = colorScheme;
    
    [monthTableView reloadData];
    [dayTableView reloadData];
    [yearTableView reloadData];
}

- (void)setDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitYear fromDate:date];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger monthIndex = kCenterCell - (kCenterCell % 12) + [dateComponents month] - 1;
    NSInteger dayIndex = kCenterCell - (kCenterCell % 31) + [dateComponents day] - 1;
    NSInteger yearIndex = kCenterCell + [nowComponents year] - [dateComponents year];
    
    [monthTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:monthIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [dayTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dayIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [yearTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:yearIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (NSDate *)date {
    // Get the cells
    NSInteger centerIndex = self.bounds.size.height / kCellHeight / 2;
    SinceDatePickerCell *monthCell = (SinceDatePickerCell *)[monthTableView cellForRowAtIndexPath:[[monthTableView indexPathsForVisibleRows] objectAtIndex:centerIndex]];
    SinceDatePickerCell *dayCell = (SinceDatePickerCell *)[dayTableView cellForRowAtIndexPath:[[dayTableView indexPathsForVisibleRows] objectAtIndex:centerIndex]];
    SinceDatePickerCell *yearCell = (SinceDatePickerCell *)[yearTableView cellForRowAtIndexPath:[[yearTableView indexPathsForVisibleRows] objectAtIndex:centerIndex]];
    
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
    return kNumCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Grab a cell
    NSString *cellID = @"customCell";
    SinceDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SinceDatePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    // Set the color scheme
    cell.colorScheme = _colorScheme;
    
    // Customize cell text depending the tableview
    if (tableView == monthTableView) {
        cell.label.text = [months objectAtIndex:indexPath.row % 12];
    } else if (tableView == dayTableView) {
        cell.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row % 31 + 1];
    } else {
        NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        cell.label.text = [NSString stringWithFormat:@"%ld", (long)[nowComponents year] - (indexPath.row % 50)];
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
        // Determine the offset of the scrollview
        CGFloat mod = fmodf(scrollView.contentOffset.y, kCellHeight);
        CGFloat targetMod = 0.0; // TODO fix this for general
        
        // Using the calculated offset, lets decide if we are within half the cell height above or below the target
        if (mod == targetMod) {
            // Great no work!
            return;
        } else if (mod < targetMod) {
            // Move up
            targetContentOffset->y += targetMod - mod;
        } else if (mod > targetMod + (kCellHeight / 2)) {
            // Move up past the next cell
            targetContentOffset->y += targetMod - mod + kCellHeight;
        } else {
            // Move down
            targetContentOffset->y -= mod - targetMod;
        }
        
    } else {
        // If there is velocity change the target offset by subtracting the mod and adding the target mod
        CGFloat mod = fmodf(targetContentOffset->y, kCellHeight);
        CGFloat targetMod = (kCellHeight - fmodf(self.bounds.size.height, kCellHeight)) / 2;
        targetMod = 0.0;
        targetContentOffset->y += targetMod - mod;
    }
}

@end
