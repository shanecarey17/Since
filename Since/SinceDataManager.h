//
//  SinceDataManager.h
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinceViewController.h"

@interface SinceDataManager : NSObject

@property (strong, nonatomic) SinceViewController *controller;

+ (SinceDataManager *)sharedManager;

- (void)retrieveData;

- (void)saveData;

- (NSMutableDictionary *)entryAtIndex:(NSInteger)index;

- (void)setActiveEntryAtIndex:(NSInteger)index;

- (void)newEntry;

- (void)removeEntryAtIndex:(NSInteger)index;

- (void)swapEntryFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (NSInteger)numEntries;

@end
