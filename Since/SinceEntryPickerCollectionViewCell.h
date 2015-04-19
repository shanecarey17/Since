//
//  SinceEntryPickerCollectionViewCell.h
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinceEntryPickerCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *dayCountLabel;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *deleteButton;

@property (nonatomic) BOOL editing;

@end
