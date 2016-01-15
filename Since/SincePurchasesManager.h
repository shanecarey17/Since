//
//  SincePurchasesManager.h
//  Since
//
//  Created by Shane Carey on 4/23/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

extern NSString *const kMultipleDatesPurchaseIdentifier;

@interface SincePurchasesManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)hasPurchasedItemForKey:(NSString *)itemKey;

- (void)purchaseItemForKey:(NSString *)itemKey;

- (void)restorePurchases;

@end
