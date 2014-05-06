//
//  HelloWorldLayer.m
//  IAPExample
//
//  Created by Muneesh Sethi on 2014-04-30.
//  Copyright Muneesh Sethi 2014. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the  Navigation Controller
#import "AppDelegate.h"
#import "AppConfig.h"
#import "GMAppManager.h"
#import "IAPHelperWrapper.h"
#import "GMAnalytics.h"
#import "MBProgressHUD.h"

#pragma mark - HelloWorldLayer

#define kTEST_PROGRESS_BAR 0

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
       
	}
    
    /////SETUP A VIEW CONTROLLER FOR THE MBPROGRESSHUD
    viewController = [[UIViewController alloc] init];
    [[[CCDirector sharedDirector] view] addSubview:viewController.view];
    hud = [[MBProgressHUD alloc] init];
    isShowingHud = NO;
    
    productsLoaded = NO;
    
    showingBuyButtonsAlready = NO;
    
    [self createScreenLayout];
	return self;
}


//////CREATE THE SCREEN LAYOUT
-(void) createScreenLayout
{
    
    CCLOG(@"CREATE SCREEN LAYOUT");
    
    //////CREATE SCREEN BACKGROUND
    [self createBackGround];
    
    //////SHOW USER KEYS
    [self createUserKeysLabel:self];
    
    /////ADD THE OBSERVERS
    [self addObservers];
    
    /////LOAD THE PRODUCTS FROM APPLE
    [self loadProductsFromApple];
    
  
}


//////CREATE THE BACKGROUND
-(void) createBackGround
{
    ///////BACKGROUND RECT
    CGRect backGroundRect = CGRectMake(0,0,winSize.width,winSize.height);
    
    /////CREATE BACKGROUND
    backGroundSprite = [self createSpriteWithFileRect:self spriteFileName:@"WhiteBox.png" spriteRect:backGroundRect spritePosition:ccp(winSize.width/2,winSize.height/2) opacity:185 anchorPoint:ccp(0.5,0.5) objectToAddTo:self displayLayer:-1];
    
    backGroundSpriteSize = backGroundSprite.contentSize;
    
}

//////SHOW USER KEYS
-(void) createUserKeysLabel:(id)sender
{
    /////CREATE NUMBER OF KEYS COUNT LABEL
    [self createLabel:self string:@"YOUR KEYS:" font:kFONT_MARKERFELT fontSize:18 fontColor:ccBLUE labelPosition:ccp(winSize.width * 0.75, winSize.height * 0.9) labelAnchorPoint:ccp(0.5,0.5) rotation:0 opacity:255 objectToAddTo:self displayLayer:2];
    int keyCount = [[GMAppManager sharedAppManager] returnKeysCount];
    keysCountLabel = [self createLabel:self string:[NSString stringWithFormat:@"%d", keyCount] font:kFONT_MARKERFELT fontSize:18 fontColor:ccBLUE labelPosition:ccp(winSize.width * 0.9, winSize.height * 0.9) labelAnchorPoint:ccp(0.5,0.5) rotation:0 opacity:255 objectToAddTo:self displayLayer:2];
    
    /////SHOW THE APP UNLOCKED STATUS
    if ([[GMAppManager sharedAppManager] isPaidAppEN])
    {
        appLockedLabel = [self createLabel:self string:@"APP UNLOCKED" font:kFONT_MARKERFELT fontSize:18 fontColor:ccGREEN labelPosition:ccp(winSize.width * 0.15, winSize.height * 0.9) labelAnchorPoint:ccp(0.5,0.5) rotation:0 opacity:255 objectToAddTo:self displayLayer:3];
    } else {
        appLockedLabel = [self createLabel:self string:@"APP LOCKED" font:kFONT_MARKERFELT fontSize:18 fontColor:ccRED labelPosition:ccp(winSize.width * 0.15, winSize.height * 0.9) labelAnchorPoint:ccp(0.5,0.5) rotation:0 opacity:255 objectToAddTo:self displayLayer:3];
    }
}


-(void) updateKeyCountLabel:(id)sender
{
     int keyCount = [[GMAppManager sharedAppManager] returnKeysCount];
    [keysCountLabel setString:[NSString stringWithFormat:@"%d", keyCount]];
}


-(void) updateAppUnlocked:(id)sender
{
    [appLockedLabel setString:@"APP UNLOCKED"];
    [appLockedLabel setColor:ccGREEN];
}


///////ADD IN OBSERVERS NEEDED TO TRACK STATE OF PRODUCTS
-(void) addObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productRestored:) name:kProductsRestoreNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateKeyCountLabel:) name:kNOTIF_REFRESH_USERS_KEYS object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(updateAppUnlocked:) name:kNOTIF_USER_JUST_PAID_FOR_APP object: nil];
    
}

//////SHOW THE PRODUCTS
-(void) loadProductsFromApple
{
    ////SHOW THE BUY BUTTONS AND ALSO REQUEST LIST OF PRODUCTS
    
    CGPoint progressBarOffset;
    progressBarOffset = ccp(0,0);

    
    if ([self checkNetworkStatus] == 0) {
        CCLOG(@"No internet connection!");
    }
    
    /////SET TO 1 TO TEST JUST THE PROGRESS BAR
    if (kTEST_PROGRESS_BAR)
    {
        [self showProgressHUD:NSLocalizedString(@"Loading Keys",nil) hudOffset:progressBarOffset];
    } else {
        
        if ([IAPHelperWrapper sharedHelper].products == nil) {
            
            [[IAPHelperWrapper sharedHelper] requestProducts];
            [self showProgressHUD:NSLocalizedString(@"Loading Keys",nil) hudOffset:progressBarOffset];
        } else {
            [self productsLoaded:nil];
        }
    }
}

//////PRODUCTS LOADED SELECTOR RUNS FROM NOTIF OR AUTOMATICALLY IF PRODUCTS ARE ALREADY LOADED FROM BEFORE
- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissHUD:self];
    CCLOG(@"PRODUCTS ARE LOADED!!");
    productsLoaded = YES;
    
    productsTable = [[NSMutableDictionary alloc] init];
    NSArray *products = [IAPHelperWrapper sharedHelper].products;
    
    for (SKProduct* product in products)
    {
        [productsTable setObject:product forKey:product.productIdentifier];
    }
    
    if (showingBuyButtonsAlready == NO)
    {
        showingBuyButtonsAlready = YES;
        [self showBuyButtonLabels];
    }
}



///////SHOW THE BUY BUTTON LABELS
-(void) showBuyButtonLabels
{
    /////CREATE THE BUY MORE BUTTONS
    CGSize spriteSize = [self objectSizeBySpriteFileName:@"MoreKeysButtonBlank.png"];
    
    [self createMenu:self label:@"BUY 9 KEYS" labelPos:ccp(spriteSize.width/2, spriteSize.height/2) fontSize:12 font:kFONT_MARKERFELT normalSpriteFileName:@"MoreKeysButtonBlank.png" selectedSpriteFileName:@"MoreKeysButtonBlankTouched.png" menuButtonEnabled:YES buttonTag:123 menuPos:ccp(winSize.width/2, winSize.height * 0.8) menuAnchorPoint:ccp(0.5,0.5) objectToAddTo:self displayLayer:4 buttonTarget:self selector:@selector(buy9Keys:) fontColor:ccBLACK menuRotation:0];
    
    [self createMenu:self label:@"BUY 27 KEYS" labelPos:ccp(spriteSize.width/2, spriteSize.height/2) fontSize:12 font:kFONT_MARKERFELT normalSpriteFileName:@"MoreKeysButtonBlank.png" selectedSpriteFileName:@"MoreKeysButtonBlankTouched.png" menuButtonEnabled:YES buttonTag:123 menuPos:ccp(winSize.width/2, winSize.height * 0.6) menuAnchorPoint:ccp(0.5,0.5) objectToAddTo:self displayLayer:4 buttonTarget:self selector:@selector(buy27Keys:) fontColor:ccBLACK menuRotation:0];
    
    [self createMenu:self label:@"UNLOCK APP" labelPos:ccp(spriteSize.width/2, spriteSize.height/2) fontSize:12 font:kFONT_MARKERFELT normalSpriteFileName:@"MoreKeysButtonBlank.png" selectedSpriteFileName:@"MoreKeysButtonBlankTouched.png" menuButtonEnabled:YES buttonTag:123 menuPos:ccp(winSize.width/2, winSize.height * 0.4) menuAnchorPoint:ccp(0.5,0.5) objectToAddTo:self displayLayer:4 buttonTarget:self selector:@selector(unlockApp:) fontColor:ccBLACK menuRotation:0];
    
    [self createMenuNoLabels:self normalSpriteFileName:@"RestorePreviousPurchaseButton.png" selectedSpriteFileName:@"RestorePreviousPurchaseButtonTouched.png" menuButtonEnabled:YES buttonTag:123 menuPos:ccp(winSize.width/2, winSize.height * 0.1) menuAnchorPoint:ccp(0.5,0.5) objectToAddTo:self displayLayer:4 buttonTarget:self selector:@selector(restorePurchase:) menuRotation:0];

}

-(void) buy9Keys:(id)sender
{
    CCLOG(@"BUY 9 KEYS");
    SKProduct *product = [productsTable objectForKey:kIAP_9KEYS];
    
    [[IAPHelperWrapper sharedHelper] buyProduct:product];
    
    
}
-(void) buy27Keys:(id)sender
{
    CCLOG(@"BUY 27 KEYS");
    SKProduct *product = [productsTable objectForKey:kIAP_27KEYS];
    
    [[IAPHelperWrapper sharedHelper] buyProduct:product];

}
-(void) unlockApp:(id)sender
{
    CCLOG(@"UNLOCK APP");
    SKProduct *product = [productsTable objectForKey:kIAP_UNLOCK_PAID_VERSION_PRODUCT];
    
    [[IAPHelperWrapper sharedHelper] buyProduct:product];
}
      
-(void) restorePurchase:(id)sender
{
    CCLOG(@"RESTORE APP");
    [[IAPHelperWrapper sharedHelper] restoreCompletedTransactions];
}
      


-(void) showRestoreButton
{
    
    float fontSize = 14;

    CGSize buttonSize = [self objectSizeBySpriteFileName:@"RestorePreviousPurchaseButton.png"];
    [self createMenu:self label:NSLocalizedString(@"Restore Purchase",nil) labelPos:ccp(buttonSize.width/2,buttonSize.height * 0.55) fontSize:fontSize font:kFONT_MARKERFELT normalSpriteFileName:@"RestorePreviousPurchaseButtonBlank" selectedSpriteFileName:@"RestorePreviousPurchaseButtonBlankTouched" menuButtonEnabled:YES buttonTag:123 menuPos:ccp(backGroundSpriteSize.width/2,backGroundSpriteSize.height * 0.1) menuAnchorPoint:ccp(0.5,0.5) objectToAddTo:backGroundSprite displayLayer:5 buttonTarget:self selector:@selector(restoreButtonTouched:) fontColor:ccRED menuRotation:0];
    

}



//////RESTORE BUTTON WAS TOUCHED. RESTORE COMPLETED TRANSACTIONS
-(void) restoreButtonTouched:(id)sender
{
    //  [self showProgressHUD:@"PROCESSING ORDER" hudOffset:ccp(0,0)];
    CCLOG(@"RESTORE PAID VERSION CHECK BUTTON TOUCHED");
    [[IAPHelperWrapper sharedHelper] restoreCompletedTransactions];
    [gmAnalytics tagEvent:[NSString stringWithFormat:@"Restore Button Touched."]];
}



- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissHUD:self];
    
    
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"THANKS!!",nil)
                                                     message:NSLocalizedString(@"Enjoy your sounds!",nil)
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:NSLocalizedString(@"OK",nil), nil] autorelease];
    
    [alert show];
    
    
    ////SHOW USER KEYS
    [self updateKeyCountLabel:self];
    
}


- (void)productRestored:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissHUD:self];
    
    
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"THANKS!!",nil)
                                                     message:NSLocalizedString(@"Your purchase was restored",nil)
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:NSLocalizedString(@"OK",nil), nil] autorelease];
    
    [alert show];
    
    
    ///SHOW USER KEYS
    [self updateKeyCountLabel:self];
    
}



- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissHUD:self];
    
    [gmAnalytics tagEvent:[NSString stringWithFormat:@"Buy More Keys Failed"]];
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Purchase Failed!",nil)
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"OK",nil), nil] autorelease];
        
        [alert show];
    }
    
}



//////PROGRESS HUD RELATED
-(void) showProgressHUD:(NSString*)hudMsg hudOffset:(CGPoint)hudOffset
{
    hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    hud.labelText = hudMsg;
    hud.yOffset = hudOffset.y;
    hud.xOffset = hudOffset.x;
    
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:20.0];
    isShowingHud = YES;
}

- (void)timeout:(id)arg {
    
    hud.labelText = NSLocalizedString(@"Timeout!",nil);
    hud.detailsLabelText = NSLocalizedString(@"Please try again later",nil);
    hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:viewController.view animated:YES];
    hud = nil;
    
}




/////NETWORK STATUS
-(NetworkStatus) checkNetworkStatus
{
    /*
     Reachability *reach = [Reachability reachabilityForInternetConnection];
     NetworkStatus netStatus = [reach currentReachabilityStatus];
     */
    
    
    ////FIXME --- SEE WHAT PARSE USES
    Reachability* wifiReach = [[Reachability reachabilityWithHostName: @"www.facebook.com"] retain];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    

    /////MS OVERRIDE UNTIL A WORKING SOLUTION CAN BE FOUND
    netStatus = ReachableViaWiFi;
    
    return netStatus;
}

////DO A CLEANUP OF ALL NOTIFICATIONS
-(void) notificationCleanup
{
    CCLOG(@"BUYMORE ALERT NOTIFICATION CLEANUP DONE");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) registerWithTouchDispatcher
{
    // call the base implementation (default touch handler)
	//[super registerWithTouchDispatcher];
	
	// or use the targeted touch handler instead
    [[CCDirector sharedDirector].touchDispatcher  addTargetedDelegate:self priority:0 swallowsTouches:NO];
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}


-(void) dealloc
{
    [viewController release];
    [productsTable release];
    [hud release];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [self release];
    [super dealloc];
}



#pragma mark GameKit delegate


@end
