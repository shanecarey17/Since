//
//  SinceDataManager.h
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SinceDataManager : NSObject

+ (id)sharedManager;

- (void)retrieveData;

- (void)saveData;

- (NSMutableDictionary *)dataAtIndex:(NSInteger)index;

- (NSMutableDictionary *)newData;

- (void)addData:(NSDictionary *)data;

- (void)removeDataAtIndex:(NSInteger)index;

- (NSInteger)numEntries;

@end
