//
//  SincePurchasesManager.h
//  Since
//
//  Created by Shane Carey on 4/23/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#define kMultipleDatesPurchaseIdentifier @"com.shanecarey.since.multipledates"

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SincePurchasesManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)hasPurchasedItemForKey:(NSString *)itemKey;

- (void)purchaseItemForKey:(NSString *)itemKey;

- (void)restorePurchases;

@end
