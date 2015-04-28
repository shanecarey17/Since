//
//  ColorPickerView.m
//  Since
//
//  Created by Shane Carey on 4/15/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceColorSchemePickerTableView.h"
#import "SinceDataManager.h"
#import "SinceColorSchemes.h"
#import "SinceColorSchemePickerCell.h"

@interface SinceColorSchemePickerTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SinceColorSchemePickerTableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
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
    [[SinceDataManager sharedManager] setActiveEntryObject:colorScheme forKey:@"colorScheme"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.superview.bounds.size.width * 2 / 5;
}

@end
