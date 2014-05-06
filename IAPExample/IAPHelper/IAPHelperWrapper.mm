//
//  InAppPurchases.m
//  bubblePop4
//
//  Created by Muneesh Sethi on 12-08-17.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//

#import "IAPHelperWrapper.h"
#import "AppConfig.h"
#import "GMAnalytics.h"
#import "GMAppManager.h"


@implementation IAPHelperWrapper


static IAPHelperWrapper *_sharedHelper;

+ (IAPHelperWrapper *) sharedHelper {
    
    if (_sharedHelper !=nil) {
        return _sharedHelper;
    }
    
    _sharedHelper = [[IAPHelperWrapper alloc] init];
    return _sharedHelper;
}

-(id) init {
    NSSet *productIdentifiers = [NSSet setWithObjects:
        
        kIAP_9KEYS,
        kIAP_27KEYS,
        kIAP_UNLOCK_PAID_VERSION_PRODUCT,
        nil];
    
    if (self = [super initWithProductIdentifiers:productIdentifiers]) {
        gmAppMananger = [GMAppManager sharedAppManager];
        
        [self addObservers];
    }
    
    return  self;
}


- (void)productPurchased:(NSNotification *)notification {
 
     [NSObject cancelPreviousPerformRequestsWithTarget:self];

 
     NSString *productIdentifier = (NSString *) notification.object;
     CCLOG(@"Purchased: %@", productIdentifier);
 
     int keysCount = 0;
 
    
     if ([productIdentifier isEqualToString:kIAP_9KEYS])
     {
         keysCount = 9;
         [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"BOUGHT 9 KEYS"]];
         CCLOG(@"BOUGHT 9 KEYS");
     } else if ([productIdentifier isEqualToString:kIAP_27KEYS])
     {
         keysCount = 27;
         [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"BOUGHT 27 KEYS"]];
         CCLOG(@"BOUGHT 27 KEYS");
     } else if ([productIdentifier isEqualToString:kIAP_UNLOCK_PAID_VERSION_PRODUCT])
     {
         [gmAppMananger setPaidAppEN];
         [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIF_USER_JUST_PAID_FOR_APP object:self];
         [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"BOUGHT FULL VERSION OF APP"]];
         CCLOG(@"BOUGHT FULL VERSION OF APP");
 
     } else {
         CCLOG(@"ERROR PRODUCT IDENTIFIER DIDNT MATCH ANYTHING IN DB");
     }
     
     /////THIS WILL SET OFF A NOTIF ALSO
     [gmAppMananger addMoreKeys:keysCount];
 
     
     CCLOG(@"SAVING DATA AFTER PRODUCT PURCHASED IN IAPWRAPPER");
     [gmAppMananger saveAllData];
 }


- (void)productRestored:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    
    NSString *productIdentifier = (NSString *) notification.object;
    CCLOG(@"Restore: %@", productIdentifier);
    
    if ([productIdentifier isEqualToString:kIAP_UNLOCK_PAID_VERSION_PRODUCT])
    {
        [gmAppMananger setPaidAppEN];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIF_USER_JUST_PAID_FOR_APP object:self];
        [[GMAnalytics sharedGMAnalytics] tagEvent:[NSString stringWithFormat:@"RESTORE FULL VERSION OF APP"]];
        CCLOG(@"RESTORE FULL VERSION OF APP");
        
    }
}
 
-(void) addObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productRestored:) name:kProductsRestoreNotification object: nil];
    
}

- (void) dealloc
{
    [self release];
	[super dealloc];
}




@end
