//
//  ColorPickerTableViewController.m
//  Since
//
//  Created by Shane Carey on 4/29/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceColorPickerTableViewController.h"
#import "SinceColorSchemePickerCell.h"
#import "SinceColorSchemes.h"
#import "SinceDataManager.h"

@interface SinceColorPickerTableViewController ()

@end

@implementation SinceColorPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[SinceColorSchemes colorSchemes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinceColorSchemePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colorSchemeCell"];
    if (cell == nil) {
        // Initialize cell
        cell = [[SinceColorSchemePickerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorSchemeCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Provide data
    NSArray *schemes = [SinceColorSchemes colorSchemes];
    cell.colorScheme = [schemes objectAtIndex:indexPath.row];
    cell.label.text = [schemes objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *colorScheme = [(SinceColorSchemePickerCell *)[tableView cellForRowAtIndexPath:indexPath] colorScheme];
    [self.dataManager setActiveEntryObject:colorScheme forKey:@"colorScheme"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.superview.bounds.size.width * 2 / 5;
}

@end
