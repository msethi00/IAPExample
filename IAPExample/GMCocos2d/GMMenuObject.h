//
//  GMMenuObject.h
//
//
//  Created by Muneesh Sethi on 12-07-17.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GMMenuObject : CCLayer {
    
    
    id menuButtonTarget;
    SEL menuButtonSelector;
    
    ////CREATE THIS A PROPERTY SO THAT THE SPRITE CAN BE MANIPULATED/ANIMATED
    CCSprite* itemNormalSprite;
    CCSprite* itemSelectedSprite;
    NSString* itemNormalSpriteFileName;
    NSString* itemSelectedSpriteFileName;
    
    ////CREATE THIS AS A PROPERTY SO THAT MENUITEM CAN BE EASILY ENABLED OR DISABLED.
    CCMenuItemSprite *menuItemSprite;
    
    ////BUTTON LABEL
    CCLabelTTF *buttonLabelNormal;
    CCLabelTTF *buttonLabelSelected;
    
    //////KEEP TRACK OF MENU POSITION
    CGPoint menuPosition;
    
}

+(id) node;

@property (nonatomic,retain) id menuButtonTarget;
@property (nonatomic) SEL menuButtonSelector;
@property (nonatomic,retain) CCMenuItemSprite *menuItemSprite;
@property (nonatomic,retain) CCSprite* itemNormalSprite;
@property (nonatomic,retain) CCSprite* itemSelectedSprite;

/////BUTTON LABELS
@property (nonatomic,retain) CCLabelTTF *buttonLabelNormal;
@property (nonatomic,retain) CCLabelTTF *buttonLabelSelected;

-(CCMenuItemSprite*) createSingleMenuNoLabels:(id)sender normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint menuRotation:(float)menuRotation;

-(CCMenuItemSprite*) createSingleMenu:(id)sender label:(NSString*)label labelPos:(CGPoint)labelPos fontSize:(int)fontSize font:(NSString*)font normalSpriteFileName:(NSString*)normalSpriteFileName selectedSpriteFileName:(NSString*)selectedSpriteFileName menuButtonEnabled:(BOOL)menuButtonEnabled buttonTag:(int)buttonTag menuPos:(CGPoint)menuPos menuAnchorPoint:(CGPoint)menuAnchorPoint fontColor:(ccColor3B)fontColor menuRotation:(float)menuRotation;


//////KEEP TRACK OF MENU POSITION
@property (nonatomic) CGPoint menuPosition;

@end
