//
//  SinceEntryPickerCollectionView.m
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceEntryPickerCollectionView.h"
#import "SinceEntryPickerCollectionViewCell.h"
#import "SinceDataManager.h"

@interface SinceEntryPickerCollectionView () <UICollectionViewDataSource>
{
    BOOL isEditing;
}

@end

@implementation SinceEntryPickerCollectionView

- (id)initWithFrame:(CGRect)frame {
    // Create the layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(frame.size.height, frame.size.height);
    
    // Initialize
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerClass:[SinceEntryPickerCollectionViewCell class] forCellWithReuseIdentifier:@"entryCell"];
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"addCell"];
        self.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[SinceDataManager sharedManager] numEntries] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[SinceDataManager sharedManager] numEntries]) {
        // Our final cell is used to add a new entry
        return [self addCellForIndexPath:indexPath];
    } else {
        // Get cell for stored entry
        NSDictionary *entry = [[SinceDataManager sharedManager] entryAtIndex:indexPath.row];
        NSInteger dayCount = [[NSDate date] timeIntervalSinceDate:[entry objectForKey:@"sinceDate"]] / 86400;
        NSString *title = [entry objectForKey:@"title"];
        return [self entryCellForIndexPath:indexPath dayCount:dayCount title:title];
    }
}

- (UICollectionViewCell *)addCellForIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *addCell = [self dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
    UILabel *plusLabel = [[UILabel alloc] initWithFrame:addCell.contentView.frame];
    plusLabel.text = @"+";
    plusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:addCell.contentView.frame.size.height / 4];
    plusLabel.textColor = [UIColor whiteColor];
    plusLabel.numberOfLines = 0;
    plusLabel.textAlignment = NSTextAlignmentCenter;
    [addCell.contentView addSubview:plusLabel];
    return addCell;
}

- (SinceEntryPickerCollectionViewCell *)entryCellForIndexPath:(NSIndexPath *)indexPath dayCount:(NSInteger)count title:(NSString *)title {
    SinceEntryPickerCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"entryCell" forIndexPath:indexPath];
    [cell.dayCountLabel setText:[NSString stringWithFormat:@"%ld", labs(count)]];
    [cell.titleLabel setText:title];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonPressedForCell:) forControlEvents:UIControlEventTouchDown];
    cell.editing = isEditing;
    return cell;
}

#pragma mark - editing

- (BOOL)isEditing {
    return isEditing;
}

- (void)setEditing:(BOOL)editing {
    // Set the ivar
    if ([[SinceDataManager sharedManager] numEntries] == 1) {
        // Don't allow editing if there is only one entry
        isEditing = NO;
    } else {
        isEditing = editing;
    }
    
    // Set all tableviewcells to the editing status
    for (SinceEntryPickerCollectionViewCell *cell in [self visibleCells]) {
        if ([cell isKindOfClass:[SinceEntryPickerCollectionViewCell class]]) {
            cell.editing = isEditing;
        }
    }
}

- (void)deleteButtonPressedForCell:(UIButton *)button {
    // Tell the data manager to delete the entry
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self];
    NSIndexPath *deleteIndex = [self indexPathForItemAtPoint:buttonPosition];
    [[SinceDataManager sharedManager] removeDataAtIndex:deleteIndex.row];
    [self deleteItemsAtIndexPaths:@[deleteIndex]];
    
    // Keep editing
    self.editing = YES;
}

@end
