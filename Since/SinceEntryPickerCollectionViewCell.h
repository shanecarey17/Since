//
//  SinceEntryPickerCollectionViewCell.h
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinceEntryPickerCollectionViewCell;

@protocol SinceEntryDeleteDelegate <NSObject>

- (void)deleteButtonPressedForCell:(SinceEntryPickerCollectionViewCell *)cell;

@end

@interface SinceEntryPickerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *dayCountLabel;

@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL editing;

@property (weak, nonatomic) id<SinceEntryDeleteDelegate> delegate;

@end