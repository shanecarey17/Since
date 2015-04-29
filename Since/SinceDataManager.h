//
//  SinceDataManager.h
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinceDataManagerDelegate

@required

- (void)activeEntryWasChangedToEntry:(NSDictionary *)entry;

@end


@interface SinceDataManager : NSObject

@property (weak, nonatomic) id<SinceDataManagerDelegate> delegate;

- (id)init;

- (void)forceDelegateCall;

- (NSDictionary *)entryAtIndex:(NSInteger)index;

- (void)setEntryActiveAtIndex:(NSInteger)index;

- (void)newEntry;

- (void)removeEntryAtIndex:(NSInteger)index;

- (void)setActiveEntryObject:(id)object forKey:(id<NSCopying>)key;

- (void)swapEntryFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

- (NSInteger)numEntries;

@end
