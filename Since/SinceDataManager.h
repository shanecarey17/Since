//
//  SinceDataManager.h
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SinceDataManagerDelegate <NSObject>

- (void)activeEntryWasChangedToEntry:(NSMutableDictionary *)entry;

@end

@interface SinceDataManager : NSObject

@property (strong, nonatomic) id<SinceDataManagerDelegate> delegate;

+ (SinceDataManager *)sharedManager;

- (void)retrieveData;

- (void)saveData;

- (NSMutableDictionary *)entryAtIndex:(NSInteger)index;

- (void)setActiveEntryAtIndex:(NSInteger)index;

- (void)newData;

- (void)removeDataAtIndex:(NSInteger)index;

- (NSInteger)numEntries;

@end
