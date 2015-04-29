//
//  SinceEntryPickerCollectionViewController.h
//  Since
//
//  Created by Shane Carey on 4/29/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SinceDataManager;

@interface SinceEntryPickerCollectionViewController : UICollectionViewController

@property (weak, nonatomic) SinceDataManager *dataManager;

@property (nonatomic, getter=isEditing) BOOL editing;

@end
