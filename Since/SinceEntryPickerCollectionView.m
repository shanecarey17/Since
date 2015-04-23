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

@interface SinceEntryPickerCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    BOOL isEditing;
    
    UICollectionViewCell *draggingCell;
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
        self.delegate = self;
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
        SinceEntryPickerCollectionViewCell *cell = [self entryCellForIndexPath:indexPath dayCount:dayCount title:title];
        
        // Hold to edit
        UILongPressGestureRecognizer *holdToEdit = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editGestureRecieved:)];
        holdToEdit.minimumPressDuration = 1.0;
        holdToEdit.cancelsTouchesInView = YES;
        [cell addGestureRecognizer:holdToEdit];
        
        return cell;
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

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing) {
        // Stop editing the picker
        self.editing = NO;
    } else {
        // Let's do something with the cell we chose
        if (indexPath.row == [[SinceDataManager sharedManager] numEntries]) {
            // Create a new entry
            [[SinceDataManager sharedManager] newEntry];
            
            // Animated insertion
            NSIndexPath *insertIndex = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
            [collectionView insertItemsAtIndexPaths:@[insertIndex]];
            [collectionView reloadItemsAtIndexPaths:@[insertIndex]];
            [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        } else {
            // Select the chosen entry
            [[SinceDataManager sharedManager] setActiveEntryAtIndex:indexPath.row];
        }
    }
}

#pragma mark - editing

- (void)editGestureRecieved:(UIGestureRecognizer *)gesture {
    if (!isEditing) {
        [self setEditing:YES];
    }
    
    [self dragAndDrop:gesture];
}

- (void)dragAndDrop:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            // Get the dragging cell
            CGPoint location = [gesture locationInView:self];
            draggingCell = [self cellForItemAtIndexPath:[self indexPathForItemAtPoint:location]];
            
            // Animate to faded and large
            [UIView animateWithDuration:0.3 animations:^{
                draggingCell.alpha = 0.7;
                draggingCell.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
            }];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint location = [gesture locationInView:self];
            
            // Swap
            NSIndexPath *swapFromIndexPath = [self indexPathForCell:draggingCell];
            NSIndexPath *swapToIndexPath = [self indexPathForItemAtPoint:location];
            if (swapFromIndexPath && swapToIndexPath && swapToIndexPath.row != [[SinceDataManager sharedManager] numEntries]) {
                // If both cells are in place and we are not swapping to the add cell
                [self performBatchUpdates:^{
                    [self moveItemAtIndexPath:swapFromIndexPath toIndexPath:swapToIndexPath];
                }completion:^(BOOL finished){
                    // Update data manager
                    [[SinceDataManager sharedManager] swapEntryFromIndex:swapFromIndexPath.row toIndex:swapToIndexPath.row];
                    
                    if (gesture.state == UIGestureRecognizerStatePossible) {
                        // The update finished after the gesture ended
                        [UIView animateWithDuration:0.5 animations:^{
                            draggingCell.alpha = 1.0;
                            draggingCell.layer.transform = CATransform3DIdentity;
                        }completion:^(BOOL finished){
                            draggingCell = nil;
                        }];
                    } else {
                        // Keep cell in appearance
                        draggingCell.alpha = 0.7;
                        draggingCell.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
                    }
                }];
            }
            
            // Scroll
            if ([gesture locationInView:self].x < [self contentOffset].x + 50) {
                
                // Scroll left 100
                CGFloat newXOffset = [self contentOffset].x - 100 < 0 ? 0 :[self contentOffset].x - 100;
                [self setContentOffset:CGPointMake(newXOffset, 0) animated:YES];
                
            } else if ([gesture locationInView:self].x > [self contentOffset].x + self.bounds.size.width - 50) {
                
                // Scroll right 100
                CGFloat newXOffset = [self contentOffset].x + 100 > [self contentSize].width - self.bounds.size.width ? [self contentSize].width - self.bounds.size.width : [self contentOffset].x + 100;
                [self setContentOffset:CGPointMake(newXOffset, 0) animated:YES];
                
            }
            
            break;
        }
        
        case UIGestureRecognizerStateEnded: {
            // Animate back to normal appearance
            [UIView animateWithDuration:0.5 animations:^{
                draggingCell.alpha = 1.0;
                draggingCell.layer.transform = CATransform3DIdentity;
            }completion:^(BOOL finished){
                draggingCell = nil;
            }];
            
            break;
        }
            
        default:
            break;
    }
}

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
    [[SinceDataManager sharedManager] removeEntryAtIndex:deleteIndex.row];
    [self deleteItemsAtIndexPaths:@[deleteIndex]];
    
    // Keep editing
    self.editing = YES;
}

@end
