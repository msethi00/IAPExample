//
//  GMAnalytics.m
//  
//
//  Created by Muneesh Sethi on 2013-10-11.
//  Copyright 2013 Muneesh Sethi. All rights reserved.
//

#import "GMAnalytics.h"
#import "AppConfig.h"



@implementation GMAnalytics

static GMAnalytics* sharedGMAnalytics = nil;

+(GMAnalytics*) sharedGMAnalytics
{
	if (sharedGMAnalytics == nil) {
        sharedGMAnalytics = [[super alloc] initGMAnalytics];
    }
    
    return sharedGMAnalytics;
}

+(id) node
{
    return [[[self alloc] init] autorelease];
}

-(id) initGMAnalytics
{
    if( (self=[super init]))
    {
    }
    return self;
}


-(void)tagEvent:(NSString*)event
{
    CCLOG(@"SEND ANALYTIC EVENT %@", event);
}

- (void) dealloc
{
    [self removeAllChildrenWithCleanup:YES];
    [self removeFromParentAndCleanup:YES];
    [self release];
	[super dealloc];
}

@end
