//
//  SinceEntryPickerCollectionViewController.m
//  Since
//
//  Created by Shane Carey on 4/29/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceEntryPickerCollectionViewController.h"
#import "SinceEntryPickerCollectionViewCell.h"
#import "SinceDataManager.h"
#import "SincePurchasesManager.h"

@interface SinceEntryPickerCollectionViewController ()

{
    UICollectionViewCell *draggingCell;
    BOOL isEditing;
}

@end

@implementation SinceEntryPickerCollectionViewController

- (id)init {
    // Create the layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[SinceEntryPickerCollectionViewCell class] forCellWithReuseIdentifier:@"entryCell"];
    [self.collectionView  registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"addCell"];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.05 alpha:1.0];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataManager numEntries] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.dataManager numEntries]) {
        // Our final cell is used to add a new entry
        return [self addCellForIndexPath:indexPath];
    } else {
        // Get cell for stored entry
        NSDictionary *entry = [self.dataManager entryAtIndex:indexPath.row];
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
    UICollectionViewCell *addCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
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
    SinceEntryPickerCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"entryCell" forIndexPath:indexPath];
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
        if (indexPath.row == [self.dataManager numEntries]) {
            // Add an entry
            [self addEntry:indexPath];
        } else {
            // Select the chosen entry
            [self.dataManager setEntryActiveAtIndex:indexPath.row];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.height, self.collectionView.bounds.size.height);
}

#pragma mark - editing

- (void)editGestureRecieved:(UIGestureRecognizer *)gesture {
    if ([self.dataManager numEntries] > 1) {
        [self setEditing:YES];
        [self dragAndDrop:gesture];
    }
}

- (void)dragAndDrop:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            // Get the dragging cell
            CGPoint location = [gesture locationInView:self.collectionView];
            draggingCell = [self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathForItemAtPoint:location]];
            
            // Animate to faded and large
            [UIView animateWithDuration:0.3 animations:^{
                draggingCell.alpha = 0.7;
                draggingCell.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
            }];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint location = [gesture locationInView:self.collectionView];
            
            // Swap
            NSIndexPath *swapFromIndexPath = [self.collectionView indexPathForCell:draggingCell];
            NSIndexPath *swapToIndexPath = [self.collectionView indexPathForItemAtPoint:location];
            if (swapFromIndexPath && swapToIndexPath && swapToIndexPath.row != [self.dataManager numEntries]) {
                // If both cells are in place and we are not swapping to the add cell
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView moveItemAtIndexPath:swapFromIndexPath toIndexPath:swapToIndexPath];
                }completion:^(BOOL finished){
                    // Update data manager
                    [self.dataManager swapEntryFromIndex:swapFromIndexPath.row toIndex:swapToIndexPath.row];
                    
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
            
            if (self.collectionView.contentSize.width > self.collectionView.bounds.size.width) {
                // Scroll if there is need to (cells don't fill screen)
                if ([gesture locationInView:self.collectionView].x < [self.collectionView contentOffset].x + 50) {
                    
                    // Scroll left 100
                    CGFloat newXOffset = [self.collectionView contentOffset].x - 100 < 0 ? 0 :[self.collectionView contentOffset].x - 100;
                    [self.collectionView setContentOffset:CGPointMake(newXOffset, 0) animated:YES];
                    
                } else if ([gesture locationInView:self.collectionView].x > [self.collectionView contentOffset].x + self.collectionView.bounds.size.width - 50) {
                    
                    // Scroll right 100
                    CGFloat newXOffset = [self.collectionView contentOffset].x + 100 > [self.collectionView contentSize].width - self.collectionView.bounds.size.width ? [self.collectionView contentSize].width - self.collectionView.bounds.size.width : [self.collectionView contentOffset].x + 100;
                    [self.collectionView setContentOffset:CGPointMake(newXOffset, 0) animated:YES];
                }
                
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
    if ([self.dataManager numEntries] == 1) {
        // Don't allow editing if there is only one entry
        isEditing = NO;
    } else {
        isEditing = editing;
    }
    
    // Set all tableviewcells to the editing status
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        if ([cell.reuseIdentifier isEqualToString:@"entryCell"]) {
            [(SinceEntryPickerCollectionViewCell *)cell setEditing:isEditing];
        }
    }
}

- (void)deleteButtonPressedForCell:(UIButton *)button {
    // Tell the data manager to delete the entry and remove from collectionview
    CGPoint buttonPosition = [button convertPoint:CGPointZero toView:self.collectionView];
    NSIndexPath *deleteIndex = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    
    // Delete entry
    [self.dataManager removeEntryAtIndex:deleteIndex.row];
    
    // Remove from collectionview
    [self.collectionView deleteItemsAtIndexPaths:@[deleteIndex]];
    
    // Keep editing
    self.editing = YES;
}

- (void)addEntry:(NSIndexPath *)indexPath {
    if ([[SincePurchasesManager sharedManager] hasPurchasedItemForKey:kMultipleDatesPurchaseIdentifier]) {
        // User has purchased the in app purchase
        
        // Create a new entry
        [self.dataManager newEntry];
        
        // Animated insertion
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    } else {
        // User has not purchased the in app purchase
        [self showMultipleDatesPurchaseAlert];
    }
}

#pragma mark - multiple dates purchase

- (void)showMultipleDatesPurchaseAlert {
    // Show UIAlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Multiple Dates" message:@"Would you like to purchase the Mutiple Dates Upgrade for 99¢?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Purchase", @"Restore", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            // User will purchase item
            [[SincePurchasesManager sharedManager] purchaseItemForKey:kMultipleDatesPurchaseIdentifier];
            break;
            
        case 2:
            // User will restore purchases
            [[SincePurchasesManager sharedManager] restorePurchases];
            break;
            
        default:
            break;
    }
}

@end
