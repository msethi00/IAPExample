//
//  GMGameManager.h
//
//
//  Created by Muneesh Sethi on 12-06-11.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GMAppManager : CCLayer {

    
    ////TREASURE BOX
    NSMutableDictionary *treasures;
    
    ////PURCHASES
    int justPurchasedProductIndex;
    
    ////WINSIZE RELATED
    CGSize winSize;
    CGSize realWinSize;
    
    ////HAS SAVED DATA BEEN LOADED YET
    BOOL loadedSavedData;

}

+(GMAppManager*) sharedAppManager;

/////////////////////////////////////////////////////////////////////////////////////////////

-(void) loadSavedData;
-(void) saveAllData;

/////// KEYS RELATED
-(int) returnKeysCount;
-(void) addMoreKeys:(int)moreKeys;
-(void) decrementKeys:(int)minusKeys;

////PURCHASES
@property (nonatomic) int justPurchasedProductIndex;

////WINSIZE RELATED
@property (nonatomic) CGSize winSize;
@property (nonatomic) CGSize realWinSize;

////TREASURES RELATED
@property (nonatomic,retain) NSMutableDictionary *treasures;

////PAID APP
-(int) isPaidAppEN;
-(void) setPaidAppEN;

@end
