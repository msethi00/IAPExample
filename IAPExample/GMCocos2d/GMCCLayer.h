//
//  GMCCLayer.h
//  
//
//  Created by Muneesh Sethi on 2013-08-28.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Reachability.h"

@class MsgBubbleObject;
@class GMMenuObject;
@class GMAppManager;
@class Reachability;
@class TopBarMenu;
@class GMAnalytics;

@interface GMCCLayer : CCLayer {
    
    ////INSTANCE OF SHARED GAME MANAGER
    GMAppManager *appManager;
 
    ////INSTANCE OF GMANALYTICS
    GMAnalytics *gmAnalytics;
    
    ////GET THE WINDOW SIZE
    CGSize winSize;

}



/*--------------------NOTIFS -----------------------------------------------------------*/
-(void) postNotif:(NSString*)notif;
-(void) postNotif:(NSString*)notif object:(id)object;
-(void) addNotifObserver:(NSString*)notif selector:(SEL)selector;
-(void) addNotifObserver:(NSString*)notif target:(id)target selector:(SEL)selector object:(id)object;
-(void) removeObservers;

/*--------------------OBJECT SIZE -----------------------------------------------------------*/
-(CGSize) objectSizeBySpriteFileName:(NSString*)spriteFileName;
-(CGSize) objectSizeByLabel:(NSString*)label fontName:(NSString*)fontName fontSize:(float)fontSize;


/*----------------------LABEL ---------------------------------------------------------*/
-(CCLabelTTF*) createLabel:(id)sender string:(NSString*)string font:(NSString*)font fontSize:(float)fontSize fontColor:(ccColor3B)fontColor labelPosition:(CGPoint)labelPosition labelAnchorPoint:(CGPoint)labelAnchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer;

-(CCLabelTTF*) createLabel:(id)sender string:(NSString*)string font:(NSString*)font fontSize:(float)fontSize fontColor:(ccColor3B)fontColor labelPosition:(CGPoint)labelPosition labelAnchorPoint:(CGPoint)labelAnchorPoint rotation:(float)rotation opacity:(float)opacity objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer;



/*----------------------MENU ---------------------------------------------------------*/

-(GMMenuObject*) createMenuNoLabels:(id)sender normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer buttonTarget:(id)buttonTarget selector:(SEL)selector menuRotation:(float)menuRotation;

-(GMMenuObject*) createMenu:(id)sender label:(NSString*)label labelPos:(CGPoint)labelPos  fontSize:(int)fontSize font:(NSString*)font normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer buttonTarget:(id)buttonTarget selector:(SEL)selector fontColor:(ccColor3B)fontColor menuRotation:(float)menuRotation;

/*----------------------SPRITE   ---------------------------------------------------------*/
-(CCSprite*) createSprite:(id)sender spriteFileName:(NSString*)spriteFileName spritePosition:(CGPoint)spritePosition imgRotation:(float)imgRotation objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer;

-(CCSprite*) createSprite:(id)sender spriteFileName:(NSString*)spriteFileName spritePosition:(CGPoint)spritePosition anchorPoint:(CGPoint)anchorPoint imgRotation:(float)imgRotation objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer;

-(CCSprite*) createSpriteWithFileRect:(id)sender spriteFileName:(NSString*)spriteFileName spriteRect:(CGRect)spriteRect spritePosition:(CGPoint)spritePosition opacity:(float)opacity anchorPoint:(CGPoint)anchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer;


/*----------------------UIALERTVIEW ---------------------------------------------------------*/
-(void) createAlert:(id)sender title:(NSString*)title msg:(NSString*)msg;
-(void) createAlert:(id)sender title:(NSString*)title msg:(NSString*)msg delegate:(id)delegate;

/*----------------------NETWORK STATUS---------------------------------------------------------*/
-(NetworkStatus) checkNetworkStatus;



@end
