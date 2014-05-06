//
//  IAPHelper.m
//
//
//  Created by Muneesh Sethi on 12-08-17.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//


#import "IAPHelper.h"
#import "AppConfig.h"
#import "GMAnalytics.h"


@implementation IAPHelper
@synthesize productIdentifiers = _productIdentifiers;
@synthesize products = _products;
@synthesize purchasedProducts = _purchasedProducts;
@synthesize request = _request;


////INIT PRODUCT LIST FROM LIST OF IDENTIFERS
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = [productIdentifiers retain];
        
        if (kIAPHELPER_CHECK_FOR_PREVIOUS_PURCHASE_PRODUCTS)
        {
            // Check for previously purchased products
            NSMutableSet * purchasedProducts = [NSMutableSet set];
            for (NSString * productIdentifier in _productIdentifiers) {
                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
                if (productPurchased) {
                    [purchasedProducts addObject:productIdentifier];
                    CCLOG(@"IAPHELPER INFO: Previously purchased: %@", productIdentifier);
                }
                CCLOG(@"IAPHELPER INFO: Not purchased: %@", productIdentifier);
            }
            self.purchasedProducts = purchasedProducts;
        }
    }
    return self;
}

/* ------------------------------------------------------PRODUCT REQUEST RELATED-----------------------------------*/
/////REQUEST PRODUCTS FROM APPLE
- (void)requestProducts {
    
    if (self.products == nil)
    {
        for (NSString * productIdentifier in _productIdentifiers) {
            CCLOG(@"REQUEST PRODUCT WITH IDENTIFIER %@", productIdentifier);
        }
        
        /////MS FIXEME
        //[[LocalyticsSession sharedLocalyticsSession] tagEvent:@"IAHELPER REQUEST PRODUCT LIST"];
    
        CCLOG(@"IAHELPER REQUEST PRODUCT LIST");
        self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
        _request.delegate = self;
        [_request start];
    }
    
}


////ONCE PRODUCT LIST IS RECEIVED
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    CCLOG(@"IAPHELPER INFO: RECEIVED PRODUCT RESULTS FROM SERVER..");
    self.products = response.products;
    self.request = nil;
    
  //  int count = [response.products count];
  //  CCLOG(@"IAPHELPER INFO: THE FOLLOWING PRODUCTS LOADED: COUNT IS %d", count);
    
    for (SKProduct *currentProduct in self.products)
    {
        CCLOG(@"%@", currentProduct.productIdentifier);
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        CCLOG(@"IAPHELPER INFO: Invalid product id: %@" , invalidProductId);
    }
    
}
/* ---------------------------------------------------------------------------------------------------------------*/


////CALLED BY SUPER CLASS
- (void)buyProduct:(SKProduct *)product {
    
    productAtCheckout = [[SKProduct alloc] init];
    productAtCheckout = product;    
    NSLog(@"IAPHELPER Buying %@...", product.productIdentifier);
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


//////CALLED BY SUPER CLASS WHEN RESTORING PURCHASE
- (void)restoreCompletedTransactions {
    CCLOG(@"SEND A RESTORE REQUEST");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    CCLOG(@"PRODUCT REQUEST ERRORED OUT %@",error);
    [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"PRODUCT REQUEST ERRORED OUT %@",error]];
}


/*!
 * @brief Verification with Apple's server completed successfully
 *
 * @param transaction The transaction being verified
 * @param isValid YES if Apple reported the transaction was valid; NO if Apple said it was not valid or if the server's validation reply was inconsistent with validity
 */
- (void)verificationControllerDidVerifyPurchase:(SKPaymentTransaction *)transaction isValid:(BOOL)isValid
{
    if (isValid) {
        
        
        CCLOG(@"IAHELPER PURCHASE IS VERIFIED BY APPLE SERVERS");
        [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"IAHELPER PURCHASE IS VERIFIED BY APPLE SERVERS"]];
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
        
    } else {
    
        NSString *message = @"Your purchase could not be verified with Apple's servers. Please try again later.";
        [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"IAHELPER PURCHASE NOT VERIFIED BY APPLE SERVERS"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
        [[[UIAlertView alloc] initWithTitle:@"Purchase Verification Failed"
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                      otherButtonTitles:nil] show];

    }
    if (transaction.transactionState != SKPaymentTransactionStatePurchasing)
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

/*!
 * @brief The attempt at verification could not be completed
 *
 * This does not mean that Apple reported the transaction was invalid, but
 * rather indicates a communication failure, a server error, or the like.
 *
 * @param transaction The transaction being verified
 * @param error An NSError describing the error. May be nil if the cause of the error was unknown (or if nobody has written code to report an NSError for that failure...)
 */
- (void)verificationControllerDidFailToVerifyPurchase:(SKPaymentTransaction *)transaction error:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    NSString *message = NSLocalizedString(@"Your purchase could not be verified with Apple's servers. Please try again later.", nil);
    if (error) {
        message = [message stringByAppendingString:@"\n\n"];
        message = [message stringByAppendingFormat:NSLocalizedString(@"The error was: %@.", nil), error.localizedDescription];
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Purchase Verification Failed", nil)
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                      otherButtonTitles:nil] show];
}



////CALLBACK METHOD AFTER BUY BUTTON PRESSED AND PURCHASE IS SUCESSFUL
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    CCLOG(@"IAPHELPER INFO: completeTransaction for product %@", transaction.payment.productIdentifier);
    
    [self recordTransaction: transaction status:@"NEWTRANS"];
   // [self provideContent: transaction.payment.productIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}



- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    CCLOG(@"IAPHELPER INFO: restoreTransaction...");
    
    [self recordTransaction: transaction status:@"RESTORETRANS"];
   // [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsRestoreNotification object:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction status:(NSString*)status
{
    [self recordTransaction:transaction status:status];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    CCLOG(@"IAPHELPER INFO: Failed purchase transaction. Wait for more details...");
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
		if(transaction.error.code == SKErrorUnknown) {
            CCLOG(@"IAPHELPER INFO: Unknown Error (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            
            [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"IAHELPER PURCHASE ERROR CODE: UNKNOWN"]];
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        }
        
        if(transaction.error.code == SKErrorClientInvalid) {
            CCLOG(@"IAPHELPER INFO: Client invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            
            [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"IAHELPER PURCHASE ERROR CODE: CLIENT INVALID"]];
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        }
        
        if(transaction.error.code == SKErrorPaymentInvalid) {
            CCLOG(@"IAPHELPER INFO: Payment invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
            
          
            [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"IAHELPER PURCHASE ERROR CODE: PAYMENT INVALID"]];
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        }
        
        if(transaction.error.code == SKErrorPaymentNotAllowed) {
            CCLOG(@"IAPHELPER INFO: Payment not allowed (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
        
            [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"IAHELPER PURCHASE ERROR CODE: PAYMENT NOT ALLOWED"]];
            UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                    message: @"There was an error purchasing this item please try again."
                                                                  delegate : self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [failureAlert show];
            [failureAlert release];
        } else {
            CCLOG(@"IAPHELPER INFO: Transaction error: %@", transaction.error.localizedDescription);
        }
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    [RRVerificationController sharedInstance].itcContentProviderSharedSecret = kIAP_SECRETKEY;
    
    BOOL checkReceipts = YES;
    

    for (SKPaymentTransaction *transaction in transactions)
    {
        CCLOG(@"Transaction state is %i",transaction.transactionState);
        
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                CCLOG(@"IAHELPER PAYMENT QUEUE STATUS PURCHASING");
                break;
            case SKPaymentTransactionStatePurchased:
                CCLOG(@"IAHELPER PAYMENT QUEUE STATUS PURCHASED");
                if (checkReceipts == YES)
                {
                    CCLOG(@"CHECKING RECEIPTS");
                    if ([[RRVerificationController sharedInstance] verifyPurchase:transaction
                                                                 withDelegate:self
                                                                        error:NULL] == FALSE) {
                        [self failedTransaction:transaction status:@"FAILEDVALIDATIONNEW"];
                        CCLOG(@"IAHELPER PAYMENT QUEUE STATUS PURCHASED FAILED VALIDATION");
                    }
                } else {
                    CCLOG(@"NOT CHECKING RECEIPTS");
                    [self completeTransaction:transaction];
                }
                break;
            case SKPaymentTransactionStateFailed:
                CCLOG(@"IAHELPER PAYMENT QUEUE STATUS PURCHASE FAILED");
                
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    /// user has cancelled
                    CCLOG(@"USER CANCELLED PAYMENT");
                     [self failedTransaction:transaction status:@"USERCANCELLED"];
                }
                else if (transaction.error.code == SKErrorPaymentNotAllowed) {
                    // payment not allowed
                    CCLOG(@"USER NOT ALLOWED TO MAKE PURCHASES");
                     [self failedTransaction:transaction status:@"NOTALLOWED"];
                }
                else {
                    // real error
                    CCLOG(@"PURCHASE HAD UNKNOWN ERRORS");
                     [self failedTransaction:transaction status:@"UNKNOWN"];
                    // show error
                }
               
                break;
            case SKPaymentTransactionStateRestored:
                CCLOG(@"IAHELPER PAYMENT QUEUE STATUS PURCHASE RESTORE");
                if (checkReceipts == YES)
                {
                    CCLOG(@"CHECKING RESTORE RECEIPTS");
                    if ([[RRVerificationController sharedInstance] verifyPurchase:transaction
                                                                 withDelegate:self
                                                                        error:NULL] == FALSE) {
                        [self failedTransaction:transaction status:@"FAILEDVALIDATIONRESTORE"];
                        CCLOG(@"IAHELPER PAYMENT QUEUE STATUS PURCHASE RESTORE FAILED VALIDATION");
                    }
                } else {
                    [self restoreTransaction:transaction];
                }
                break;
            default:
                break;
        }
    }
}




//////RECORD TRANSACTIONS TO SERVER
- (void)recordTransaction:(SKPaymentTransaction *)transaction status:(NSString*)status {
    // TODO: Record the transaction on the server side...
    
    NSString *productId = transaction.payment.productIdentifier;
    int productCount = transaction.payment.quantity;
    NSString *transactionId = transaction.transactionIdentifier;
    NSDate *transactionDate = transaction.transactionDate;
    NSData *transactionReceipt = transaction.transactionReceipt;
    
    
}


// In dealloc
- (void)dealloc
{
    [productAtCheckout release];
    [_productIdentifiers release];
    _productIdentifiers = nil;
    [_products release];
    _products = nil;
    [_purchasedProducts release];
    _purchasedProducts = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}
 

@end
