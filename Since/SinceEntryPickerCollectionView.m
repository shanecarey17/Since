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

@interface SinceEntryPickerCollectionView () <UICollectionViewDataSource, SinceEntryDeleteDelegate> {
    
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
        UICollectionViewCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
        UILabel *plusLabel = [[UILabel alloc] initWithFrame:addCell.contentView.frame];
        plusLabel.text = @"+";
        plusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:36];
        plusLabel.textColor = [UIColor whiteColor];
        plusLabel.numberOfLines = 0;
        plusLabel.textAlignment = NSTextAlignmentCenter;
        [addCell.contentView addSubview:plusLabel];
        return addCell;
    } else {
        // Get cell for stored entry
        SinceEntryPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"entryCell" forIndexPath:indexPath];
        NSDictionary *entry = [[SinceDataManager sharedManager] dataAtIndex:indexPath.row];
        cell.dayCountLabel.text = [NSString stringWithFormat:@"%ld", (NSInteger)[[NSDate date] timeIntervalSinceDate:[entry objectForKey:@"sinceDate"]] / 86400];
        //cell.titleLabel.text = [entry objectForKey:@"title"];
        cell.delegate = self;
        cell.editing = isEditing;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

#pragma mark - deleting cells

- (BOOL)isEditing {
    return isEditing;
}

- (void)setEditing:(BOOL)editing {
    if ([[SinceDataManager sharedManager] numEntries] == 1) {
        // If we are down to one we can't delete anymore
        isEditing = NO;
    } else {
        // Otherwise we do whatever we chose
        isEditing = editing;
    }
    
    // Set all tableviewcells to the editing status
    for (int i = 0; i < [self numberOfSections]; i++) {
        for (int j = 0; j < [self numberOfItemsInSection:i]; j++) {
            UICollectionViewCell *cell = [self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            if ([cell isKindOfClass:[SinceEntryPickerCollectionViewCell class]]) {
                [(SinceEntryPickerCollectionViewCell *)cell setEditing:isEditing];
            }
        }
    }
}

- (void)deleteButtonPressedForCell:(SinceEntryPickerCollectionViewCell *)cell {
    NSIndexPath *deleteIndex = [self indexPathForCell:cell];
    [[SinceDataManager sharedManager] removeDataAtIndex:deleteIndex.row];
    [self deleteItemsAtIndexPaths:@[deleteIndex]];
    
    self.editing = YES;
}

@end
