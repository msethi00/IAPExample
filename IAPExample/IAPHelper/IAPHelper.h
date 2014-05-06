//
//  IAPHelper.h
//
//
//  Created by Muneesh Sethi on 12-08-17.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"
#import "cocos2d.h"
#import "RRVerificationController.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductsRestoreNotification         @"ProductsRestored"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"


@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, RRVerificationControllerDelegate> {
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
    
    SKProduct *productAtCheckout;
    
}

@property (retain) NSSet *productIdentifiers;
@property (retain) NSArray * products;
@property (retain) NSMutableSet *purchasedProducts;
@property (retain) SKProductsRequest *request;

- (void)requestProducts;
- (void)restoreCompletedTransactions;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProduct:(SKProduct *)product;

@end

