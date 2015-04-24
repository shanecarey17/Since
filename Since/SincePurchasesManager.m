//
//  SincePurchasesManager.m
//  Since
//
//  Created by Shane Carey on 4/23/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import <Security/Security.h>

#import "SincePurchasesManager.h"

@interface SincePurchasesManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation SincePurchasesManager

+ (id)sharedManager {
    // Singleton initialization
    static SincePurchasesManager *manager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (BOOL)hasPurchasedItemForKey:(NSString *)itemKey {
    BOOL hasPurchasedItem = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:itemKey] boolValue];
    return hasPurchasedItem;
}

- (void)purchaseItemForKey:(NSString *)itemKey {
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:itemKey]];
        productsRequest.delegate = self;
        [productsRequest start];
    } else {
        // Cannot make purchases
    }
    
}

- (void)restorePurchases {
    // User is restoring purchases
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)setItemAllowedForKey:(NSString *)itemKey {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:itemKey];
}

#pragma mark - Store Kit Protocols

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSInteger count = [response.products count];
    if(count > 0){
        // Purchase
        SKPayment *payment = [SKPayment paymentWithProduct:[response.products objectAtIndex:0]];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchased: case SKPaymentTransactionStateRestored:
                // User has purchased or restored item
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self setItemAllowedForKey:transaction.payment.productIdentifier];
                break;
                
            case SKPaymentTransactionStateFailed:
                // User cancelled the transaction
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [[[UIAlertView alloc] initWithTitle:@"Purchases Restored" message:@"Your purchases have been restored" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];

}

@end
