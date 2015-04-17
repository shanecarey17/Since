//
//  ColorPickerView.m
//  Since
//
//  Created by Shane Carey on 4/15/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceColorSchemePickerTableView.h"
#import "ColorSchemes.h"
#import "SinceColorSchemePickerCell.h"

@interface SinceColorSchemePickerTableView () <UITableViewDataSource>

@end

@implementation SinceColorSchemePickerTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
        self.separatorColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - datasource

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
    cell.colorScheme = [sortedKeys objectAtIndex:indexPath.row];
    cell.label.text = [sortedKeys objectAtIndex:indexPath.row];
    
    return cell;
}

@end
