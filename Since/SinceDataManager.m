//
//  SinceDataManager.m
//  Since
//
//  Created by Shane Carey on 4/16/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SinceDataManager.h"
#import "ColorSchemes.h"

@interface SinceDataManager ()

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation SinceDataManager

+ (id)sharedManager {
    
    // Singleton initialization
    static SinceDataManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[self alloc] init];
        manager.dataArray = [[NSMutableArray alloc] init];
    });
    return manager;
}

- (void)retrieveData {
    // Retrieve data from plist
    NSString *filePath = [self filePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // We have already updated to new data storage
        _dataArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    } else {
        // Write current data into array (possibly from previous version using user defaults)
        NSDate *sinceDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"sinceDate"];
        if (sinceDate == nil) {
            sinceDate = [NSDate dateWithTimeIntervalSinceNow:-250560];
        }
        NSString *colorScheme = @"Mono";
        NSString *title = @"Since I...";
        // Add this data to the stored data
        NSMutableDictionary *currData = [NSMutableDictionary dictionaryWithObjects:@[sinceDate, colorScheme, title] forKeys:@[@"sinceDate", @"colorScheme", @"title"]];
        [_dataArray addObject:currData];
    }
}

- (void)saveData {
    // Save data to plist
    NSString *filePath = [self filePath];
    [_dataArray writeToFile:filePath atomically:YES];
}

- (NSInteger)numEntries {
    return [_dataArray count];
}

- (NSMutableDictionary *)dataAtIndex:(NSInteger)index {
    return [_dataArray objectAtIndex:index];
}

- (NSMutableDictionary *)newData {
    NSString *colorScheme = [[ColorSchemes colorSchemes] objectAtIndex:arc4random() % [[ColorSchemes colorSchemes] count]];
    NSDate *sinceDate = [NSDate dateWithTimeIntervalSinceNow:-250560];
    NSString *title = @"Since";
    NSMutableDictionary *newEntry = [[NSMutableDictionary alloc] initWithObjects:@[colorScheme, sinceDate, title] forKeys:@[@"colorScheme", @"sinceDate", @"title"]];
    return newEntry;
}

- (void)addData:(NSDictionary *)data {
    [_dataArray addObject:data];
}

- (void)removeDataAtIndex:(NSInteger)index {
    [_dataArray removeObjectAtIndex:index];
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"sinceData.plist"];
}

@end
