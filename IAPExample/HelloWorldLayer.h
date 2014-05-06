//
//  HelloWorldLayer.h
//  IAPExample
//
//  Created by Muneesh Sethi on 2014-04-30.
//  Copyright Muneesh Sethi 2014. All rights reserved.
//



// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GMCCLayer.h"


@class MBProgressHUD;

// HelloWorldLayer
@interface HelloWorldLayer : GMCCLayer
{
    /////USER'S LABEL COUNT
    CCLabelTTF *keysCountLabel;
    
    /////APP LOCKED/UNLOCKED LABEL
    CCLabelTTF *appLockedLabel;
    
    /////BACKGROUND
    CCSprite *backGroundSprite;
    CGSize backGroundSpriteSize;
    
    /////A FLAG TO CHECK IF PRODUCTS ARE ALREADY LOADED
    BOOL productsLoaded;

    /////PRODUCTS TABLE
    NSMutableDictionary *productsTable;
    
    /////A FLAG TO CHECK IF BUY BUTTONS ALREADY SHOWING
    BOOL showingBuyButtonsAlready;
    
    /////INSTANCE OF VIEW CONTROLLER FOR THE PROGRESS HUD
    UIViewController *viewController;
    MBProgressHUD *hud;
    BOOL isShowingHud;
    
    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
