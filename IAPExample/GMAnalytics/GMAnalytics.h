//
//  GMAnalytics.h
// 
//
//  Created by Muneesh Sethi on 2013-10-11.
//  Copyright 2013 Muneesh Sethi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GMCCLayer.h"

@interface GMAnalytics : CCLayer {
    
}

+(GMAnalytics*) sharedGMAnalytics;
+(id) node;
-(void)tagEvent:(NSString*)event;

@end
