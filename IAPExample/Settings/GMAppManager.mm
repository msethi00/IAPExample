//
//  GMGameManager.m
//  
//
//  Created by Muneesh Sethi on 12-06-11.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//


#import "GMAppManager.h"
#import "AppConfig.h"
#import "Notifs.h"


@implementation GMAppManager
@synthesize justPurchasedProductIndex;
@synthesize winSize,realWinSize;
@synthesize treasures;


static GMAppManager* sharedAppManager = nil;

+(GMAppManager*) sharedAppManager
{
	if (sharedAppManager == nil) {
        sharedAppManager = [[super alloc] initAppManager];
    }
    
    return sharedAppManager;
}

+(id) node
{
    return [[[self alloc] init] autorelease];
}

-(id) initAppManager 
{
    if( (self=[super init]))
    {
       
    }
    
     loadedSavedData = NO;
    
    return self;
}

-(void) loadSavedData
{
    
    if (!loadedSavedData)
    {
        
        loadedSavedData = YES;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path;
    
    
        path = [documentsDirectory stringByAppendingPathComponent:@"treasures.plist"];
        if ([fileManager fileExistsAtPath:path]) {
        //CCLOG(@"LOADING FILE FROM PLIST FILE %@", path);
        treasures = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        } else {
        //CCLOG(@"LOADING FILE FROM DEFAULTS");
            [self defaultTreasures];
        }
    }

}

-(void) saveAllData
{
    //CCLOG(@"GAME MANGER SAVING ALL DATA");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableDictionary *savedObjList = [[[NSMutableDictionary alloc] init] autorelease];
    
    [savedObjList setValue:treasures forKey:@"treasures"];
    
    for (NSString* key in savedObjList) {
        
        NSMutableString *fileName = [[[NSMutableString alloc] initWithString:key] autorelease];
        
        [fileName appendString:@".plist"];
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        
        if (![fileManager fileExistsAtPath:path]) {
            [fileManager createFileAtPath:path contents:nil attributes:nil];
            //CCLOG(@"FILE DOESNT EXIST AT PATH %@ SO CREATE IT",path);
        }
        
        [[savedObjList valueForKey:key] writeToFile:path atomically:YES];
        //CCLOG(@"SAVE FILE AT PATH %@", path);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////// KEYS RELATED
-(int) returnKeysCount
{
    return [[treasures objectForKey:kTREASURE_KEYS] intValue];
}

-(void) addMoreKeys:(int)moreKeys
{
    int currentStones = [self returnKeysCount] + moreKeys;
    [treasures setObject:[NSNumber numberWithInt:currentStones] forKey:kTREASURE_KEYS];
    /////POST NOTIF TAHT USERKEYS HAS CHANGED
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIF_REFRESH_USERS_KEYS object:self];
}
-(void) decrementKeys:(int)minusKeys
{
    int currentKeys = [self returnKeysCount] - minusKeys;
    if (currentKeys < 0)
    {
        currentKeys = 0;
    }
    [treasures setObject:[NSNumber numberWithInt:currentKeys] forKey:kTREASURE_KEYS];
    /////POST NOTIF TAHT USERKEYS HAS CHANGED
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIF_REFRESH_USERS_KEYS object:self];
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////TREASURE BOX RELATED
-(void) defaultTreasures
{
    treasures = [[NSMutableDictionary alloc] init];
    /////KEYS
    CCLOG(@"SETTING DEFAULT KEYS %d", kTREASURE_DEFAULT_KEYS);
    [treasures setObject:[NSNumber numberWithInt:kTREASURE_DEFAULT_KEYS] forKey:kTREASURE_KEYS];

}

-(int) isPaidAppEN
{
    return [[treasures objectForKey:@"PAID"] intValue];
}

-(void) setPaidAppEN
{
    [treasures setObject:@"1" forKey:@"PAID"];
}


////////////////////////////////////////////////////////////////////////////////////////////////////]

- (void) dealloc
{
    
    [treasures release];
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [self release];
	[super dealloc];
}

@end
