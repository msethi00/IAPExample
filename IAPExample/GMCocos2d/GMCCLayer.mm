//
//  GMCCLayer.m
//  
//
//  Created by Muneesh Sethi on 2013-08-28.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GMCCLayer.h"
#import "GMMenuObject.h"
#import "GMAppManager.h"
#import "Reachability.h"
#import "AppConfig.h"
#import "GMAnalytics.h"


@implementation GMCCLayer

+(id) node
{
    return [[[self alloc] init] autorelease];
}

-(id) init
{
    
    if (self = [super init])
    {
        /////INSTANCE OF GAME MANAGER
        appManager = [GMAppManager sharedAppManager];

        gmAnalytics = [GMAnalytics sharedGMAnalytics];
        
        ////GET THE WINDOW SIZE
        winSize = [CCDirector sharedDirector].winSize;

    }
    return self;
}


/*----------------------NOTIF RELATED ----------------------------------------------------*/
-(void) postNotif:(NSString*)notif
{
    [self postNotif:notif object:self];
}

-(void) postNotif:(NSString*)notif object:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notif object:object];
}

-(void) addNotifObserver:(NSString*)notif selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notif object:nil];
}

-(void) addNotifObserver:(NSString*)notif target:(id)target selector:(SEL)selector object:(id)object
{
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:notif object:object];
}
-(void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*----------------------SPRITE SIZE ----------------------------------------------------*/
-(CGSize) objectSizeBySpriteFileName:(NSString*)spriteFileName
{
    CCSprite *tempSprite = [CCSprite spriteWithFile:spriteFileName];
    CGSize spriteSize = tempSprite.contentSize;
    return spriteSize;
}

-(CGSize) objectSizeByLabel:(NSString*)label fontName:(NSString*)fontName fontSize:(float)fontSize
{
    CCLabelTTF *tempLabel = [CCLabelTTF labelWithString:label fontName:fontName fontSize:fontSize];
    CGSize labelSize = tempLabel.contentSize;
    return labelSize;
}
/*--------------------------------------------------------------------------------------*/


/*----------------------LABELS ---------------------------------------------------------*/
-(CCLabelTTF*) createLabel:(id)sender string:(NSString*)string font:(NSString*)font fontSize:(float)fontSize fontColor:(ccColor3B)fontColor labelPosition:(CGPoint)labelPosition labelAnchorPoint:(CGPoint)labelAnchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer
{
   return [self createLabel:self string:string font:font fontSize:fontSize fontColor:fontColor labelPosition:labelPosition labelAnchorPoint:labelAnchorPoint rotation:0 opacity:255 objectToAddTo:objectToAddTo displayLayer:displayLayer];
}

-(CCLabelTTF*) createLabel:(id)sender string:(NSString*)string font:(NSString*)font fontSize:(float)fontSize fontColor:(ccColor3B)fontColor labelPosition:(CGPoint)labelPosition labelAnchorPoint:(CGPoint)labelAnchorPoint rotation:(float)rotation opacity:(float)opacity objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:string fontName:font fontSize:fontSize];
    label.color = fontColor;
    [label setPosition:labelPosition];
    [objectToAddTo addChild:label z:displayLayer];
    label.anchorPoint = labelAnchorPoint;
    label.rotation = rotation;
    label.opacity = opacity;
    
    return label;
}
/*--------------------------------------------------------------------------------------*/

/*----------------------MENU   ---------------------------------------------------------*/

-(GMMenuObject*) createMenuNoLabels:(id)sender normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer buttonTarget:(id)buttonTarget selector:(SEL)selector menuRotation:(float)menuRotation
{
    
    return [self createMenu:sender label:@"" labelPos:ccp(0,0) fontSize:0 font:@"" normalSpriteFileName:normalSpriteFileName selectedSpriteFileName:selectedSpriteFileName menuButtonEnabled:menuButtonEnabled buttonTag:buttonTag menuPos:menuPos menuAnchorPoint:menuAnchorPoint objectToAddTo:objectToAddTo displayLayer:displayLayer buttonTarget:buttonTarget selector:selector fontColor:ccBLACK menuRotation:menuRotation];

}

-(GMMenuObject*) createMenu:(id)sender label:(NSString*)label labelPos:(CGPoint)labelPos  fontSize:(int)fontSize font:(NSString*)font normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer buttonTarget:(id)buttonTarget selector:(SEL)selector fontColor:(ccColor3B)fontColor menuRotation:(float)menuRotation
{
    GMMenuObject *menu = [GMMenuObject node];
    [menu createSingleMenu:sender label:label labelPos:labelPos fontSize:fontSize font:font normalSpriteFileName:normalSpriteFileName selectedSpriteFileName:selectedSpriteFileName menuButtonEnabled:menuButtonEnabled buttonTag:buttonTag menuPos:menuPos menuAnchorPoint:menuAnchorPoint fontColor:fontColor menuRotation:menuRotation];
    [objectToAddTo addChild:menu z:displayLayer];
    [menu setMenuButtonTarget:buttonTarget];
    [menu setMenuButtonSelector:selector];
    
    return menu;
}

/*--------------------------------------------------------------------------------------*/

/*----------------------SPRITE   ---------------------------------------------------------*/

-(CCSprite*) createSprite:(id)sender spriteFileName:(NSString*)spriteFileName spritePosition:(CGPoint)spritePosition imgRotation:(float)imgRotation objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer
{
   return [self createSprite:sender spriteFileName:spriteFileName spritePosition:spritePosition anchorPoint:ccp(0.5,0.5) imgRotation:imgRotation objectToAddTo:objectToAddTo displayLayer:displayLayer];
}

-(CCSprite*) createSprite:(id)sender spriteFileName:(NSString*)spriteFileName spritePosition:(CGPoint)spritePosition anchorPoint:(CGPoint)anchorPoint imgRotation:(float)imgRotation objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer
{
    CCSprite *sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",spriteFileName]];
    [sprite setPosition:spritePosition];
    sprite.rotation = imgRotation;
    sprite.anchorPoint = anchorPoint;
    [objectToAddTo addChild:sprite z:displayLayer];
    return sprite;
}

-(CCSprite*) createSpriteWithFileRect:(id)sender spriteFileName:(NSString*)spriteFileName spriteRect:(CGRect)spriteRect spritePosition:(CGPoint)spritePosition opacity:(float)opacity anchorPoint:(CGPoint)anchorPoint objectToAddTo:(id)objectToAddTo displayLayer:(int)displayLayer
{
    CCSprite *sprite = [CCSprite spriteWithFile:spriteFileName rect:spriteRect];
    [sprite setPosition:spritePosition];
    [objectToAddTo addChild:sprite z:displayLayer];
    sprite.opacity = opacity;
    sprite.anchorPoint = anchorPoint;
    return sprite;
}

/*--------------------------------------------------------------------------------------*/


/*----------------------UIALERTVIEW ---------------------------------------------------------*/
-(void) createAlert:(id)sender title:(NSString*)title msg:(NSString*)msg
{
    [self createAlert:self title:title msg:msg delegate:nil];
}

-(void) createAlert:(id)sender title:(NSString*)title msg:(NSString*)msg delegate:(id)delegate
{
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title
                                                     message:msg
                                                    delegate:delegate
                                           cancelButtonTitle:@"CANCEL"
                                           otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
   
}

/*--------------------------------------------------------------------------------------*/



/*----------------------NETWORK STATUS---------------------------------------------------------*/
-(NetworkStatus) checkNetworkStatus
 {
 /*
 Reachability *reach = [Reachability reachabilityForInternetConnection];
 NetworkStatus netStatus = [reach currentReachabilityStatus];
 CCLOG(@"NET STATUS IS %u",netStatus);
 return netStatus;
 */
     Reachability* wifiReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
     NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
     CCLOG(@"NET STATUS IS %u",netStatus);


     /////MS OVERRIDE UNTIL A WORKING SOLUTION CAN BE FOUND
     netStatus = ReachableViaWiFi;

return netStatus;

}
/*--------------------------------------------------------------------------------------*/



-(void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [self release];
    [super dealloc];
}

@end
