//
//  GMMenuObject.m
//
//
//  Created by Muneesh Sethi on 12-07-17.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//

#import "GMMenuObject.h"
#import "AppConfig.h"

@implementation GMMenuObject

@synthesize menuButtonSelector, menuButtonTarget, menuItemSprite;
@synthesize itemNormalSprite,itemSelectedSprite;
@synthesize buttonLabelNormal, buttonLabelSelected;
@synthesize menuPosition;

+(id) node 
{
    return [[[self alloc] init] autorelease];
}

-(id) init
{
    if  (self=[super init]) {
        
        itemNormalSpriteFileName = [[NSString alloc] init];
        itemSelectedSpriteFileName = [[NSString alloc] init];
    }
    return self;
}

-(void) menuItemTouched:(CCMenuItemImage*) sender
{
    NSMethodSignature * sig = nil;
    
    if( menuButtonTarget && menuButtonSelector ) {
        sig = [menuButtonTarget methodSignatureForSelector:menuButtonSelector];
        
        NSInvocation *invocation = nil;
        invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:menuButtonTarget];
        [invocation setSelector:menuButtonSelector];
#if NS_BLOCKS_AVAILABLE
        if ([sig numberOfArguments] == 3)
#endif
			[invocation setArgument:&sender atIndex:2];
        
        [invocation invoke];
    }
     
}  


-(CCMenuItemSprite*) createMenuItemButton:(id)sender label:(NSString*)label labelPos:(CGPoint)labelPos fontSize:(int)fontSize font:(NSString*)font normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName  menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag fontColor:(ccColor3B)fontColor
{
    
    itemNormalSpriteFileName = normalSpriteFileName;
    itemSelectedSpriteFileName = selectedSpriteFileName;
    
    buttonLabelNormal = [CCLabelTTF labelWithString:label fontName:font fontSize:fontSize];
    buttonLabelSelected = [CCLabelTTF labelWithString:label fontName:font fontSize:fontSize];

    
    itemNormalSprite = [CCSprite spriteWithFile:normalSpriteFileName];
    itemSelectedSprite = [CCSprite spriteWithFile:selectedSpriteFileName];

    itemNormalSprite.anchorPoint = ccp(0.5,0.5);
    itemSelectedSprite.anchorPoint = ccp(0.5,0.5);
    
    //CCLOG(@"Create menu item button with norm button:%@ selected button:%@",normalSpriteFileName, selectedSpriteFileName);
    
    buttonLabelNormal.color = fontColor;
    buttonLabelSelected.color = fontColor;
    buttonLabelNormal.position = labelPos;
    buttonLabelSelected.position = labelPos;
    
    
    [itemNormalSprite addChild:buttonLabelNormal];
    [itemSelectedSprite addChild:buttonLabelSelected];
   
    
    
    CCMenuItemSprite* menuItem = [CCMenuItemSprite itemWithNormalSprite:itemNormalSprite selectedSprite:itemSelectedSprite target:self selector:@selector(menuItemTouched:)];

    menuItem.anchorPoint = ccp(0.5,0.5);
    
    menuItem.isEnabled = menuButtonEnabled;
    menuItem.tag = buttonTag;  
    
    return menuItem;

}


//////////WITH SPRITE FRAMENAME & FONTCOLOR & MENUROTATION
-(CCMenuItemSprite*) createSingleMenuNoLabels:(id)sender normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint menuRotation:(float)menuRotation
{
    
    return [self createSingleMenu:sender label:@"" labelPos:ccp(0,0) fontSize:0 font:@"" normalSpriteFileName:normalSpriteFileName selectedSpriteFileName:selectedSpriteFileName menuButtonEnabled:menuButtonEnabled buttonTag:buttonTag menuPos:menuPos menuAnchorPoint:menuAnchorPoint fontColor:ccBLACK menuRotation:menuRotation];
    
}


//////////WITH SPRITE FRAMENAME & FONTCOLOR & MENUROTATION
-(CCMenuItemSprite*) createSingleMenu:(id)sender label:(NSString*)label labelPos:(CGPoint)labelPos fontSize:(int)fontSize font:(NSString*)font normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint fontColor:(ccColor3B)fontColor menuRotation:(float)menuRotation
{
    menuItemSprite = [self createMenuItemButton:self label:label labelPos:labelPos fontSize:fontSize font:font normalSpriteFileName:normalSpriteFileName selectedSpriteFileName:selectedSpriteFileName menuButtonEnabled:menuButtonEnabled buttonTag:buttonTag fontColor:fontColor];
    
    menuPosition = menuPos;
    
    CCMenu *menu = [CCMenu menuWithItems:nil];
    [menu addChild:menuItemSprite z:5];
    menu.position = ccp(menuPos.x,menuPos.y);
    menuItemSprite.rotation = menuRotation;
    menuItemSprite.anchorPoint = menuAnchorPoint;
    [self addChild:menu z:5];
    
    return menuItemSprite;

}

- (void) dealloc
{
    [itemNormalSpriteFileName release];
    [itemSelectedSpriteFileName release];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [self release];
	[super dealloc];
}


@end
