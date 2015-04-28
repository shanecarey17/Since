//
//  SinceDataManager.m
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceDataManager.h"
#import "SinceColorSchemes.h"

@interface SinceDataManager ()

@property (strong, nonatomic) NSMutableDictionary *activeEntry;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end


@implementation SinceDataManager

+ (id)sharedManager {
    // Singleton initialization
    static SinceDataManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[self alloc] init];
        manager.dataArray = [[NSMutableArray alloc] init];
    });
    return manager;
}

- (void)setActiveEntry:(NSMutableDictionary *)activeEntry {
    _activeEntry = activeEntry;
    
    // Notify delegate that active entry has changed
    [_controller setEntry:_activeEntry];
}

#pragma mark - file system access

- (void)retrieveData {
    // Retrieve data from plist
    NSString *filePath = [self filePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // We have already updated to new data storage
        NSArray *retrievedArray = [[NSArray alloc] initWithContentsOfFile:filePath];
        [_dataArray addObjectsFromArray:retrievedArray];
        
    } else {
        // Write current data into array (possibly from previous version using user defaults)
        NSDate *sinceDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinceDate"];
        if (sinceDate == nil) {
            sinceDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
            sinceDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:sinceDate]];
        }
        NSString *colorScheme = @"Citrus";
        NSString *title = @"Since";
        
        // Add this data to the stored data
        NSMutableDictionary *currData = [NSMutableDictionary dictionaryWithObjects:@[sinceDate, colorScheme, title] forKeys:@[@"sinceDate", @"colorScheme", @"title"]];
        _dataArray = [[NSMutableArray alloc] initWithObjects:currData, nil];
    }
    self.activeEntry = [_dataArray firstObject];
}

- (void)saveData {
    // Save data to plist
    NSString *filePath = [self filePath];
    [_dataArray writeToFile:filePath atomically:YES];
}

- (NSString *)filePath {
    // Return file path to save/retrieve data
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"sinceData.plist"];
}

#pragma mark - data structure methods

- (NSInteger)numEntries {
    // Return total number of entries
    return [_dataArray count];
}

- (NSMutableDictionary *)entryAtIndex:(NSInteger)index {
    // Return entry at given index
    return [_dataArray objectAtIndex:index];
}

- (void)setActiveEntryAtIndex:(NSInteger)index {
    // Return the entry at that index
    self.activeEntry = [_dataArray objectAtIndexedSubscript:index];
}

- (void)newEntry {
    // Create the entry data
    NSDate *sinceDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    sinceDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:sinceDate]];
    
    NSString *colorScheme = [[SinceColorSchemes colorSchemes] objectAtIndex:arc4random() % [[SinceColorSchemes colorSchemes] count]];
    NSString *title = @"Since";
    
    // Create the entry and add it to our array
    NSMutableDictionary *newEntry = [[NSMutableDictionary alloc] initWithObjects:@[colorScheme, sinceDate, title] forKeys:@[@"colorScheme", @"sinceDate", @"title"]];
    [_dataArray addObject:newEntry];
    
    // Set new entry active
    self.activeEntry = newEntry;
}

- (void)removeEntryAtIndex:(NSInteger)index {
    // If we are deleting the active entry
    if (index == [_dataArray indexOfObject:_activeEntry]) {
        if ([_dataArray count] == 1) {
            self.activeEntry = nil;
        } else if (index > 0) {
            self.activeEntry = [_dataArray objectAtIndex:index - 1];
        } else if (index == 0) {
            self.activeEntry = [_dataArray objectAtIndex:index + 1];
        }
    }
    
    // Remove data at given index
    [_dataArray removeObjectAtIndex:index];
}

- (void)setActiveEntryObject:(id)object forKey:(id<NSCopying>)key {
    [_activeEntry setObject:object forKey:key];
    self.activeEntry = _activeEntry;
}

- (void)swapEntryFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [_dataArray exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
}

@end
