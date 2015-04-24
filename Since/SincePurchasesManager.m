//
//  SincePurchasesManager.m
//  Since
//
//  Created by Shane Carey on 4/23/15.
//  Copyright (c) 2015 Shane Carey. All rights reserved.
//

#import "SincePurchasesManager.h"
#import "SinceLoadingView.h"

@interface SincePurchasesManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) SinceLoadingView *loadingView;

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
    return [[NSUserDefaults standardUserDefaults] boolForKey:itemKey];
}

- (void)purchaseItemForKey:(NSString *)itemKey {
    if ([SKPaymentQueue canMakePayments]) {
        // Process request
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:itemKey]];
        productsRequest.delegate = self;
        [productsRequest start];
        
        // Show the spinner
        [self setUpSpinner];
    } else {
        // Cannot make purchases
    }
    
}

- (void)restorePurchases {
    // User is restoring purchases
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    // Show spinner
    [self setUpSpinner];
}

- (void)setItemAllowedForKey:(NSString *)itemKey {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:itemKey];
}

- (void)setUpSpinner {
    _loadingView = [[SinceLoadingView alloc] init];
    [_loadingView show];
}

- (void)dismissSpinner {
    [_loadingView hide];
    _loadingView = nil;
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
            case SKPaymentTransactionStatePurchased:
                // User has purchased item
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self setItemAllowedForKey:transaction.payment.productIdentifier];
                [self dismissSpinner];
                break;
            
            case SKPaymentTransactionStateRestored:
                // User has restored item
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self setItemAllowedForKey:transaction.payment.productIdentifier];
                [self dismissSpinner];
                break;
                
            case SKPaymentTransactionStateFailed:
                // User cancelled the transaction
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self dismissSpinner];
                break;
                
            case SKPaymentTransactionStateDeferred:
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    [[[UIAlertView alloc] initWithTitle:@"Purchases Restored" message:@"Your purchases have been restored" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}

@end
