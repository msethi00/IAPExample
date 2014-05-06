//
//  InApp"GameObjectsInclude.h"
//  
//
//  Created by Muneesh Sethi on 12-08-17.
//  Copyright 2012 Gamicks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IAPHelper.h"

@class GMAppManager;

@interface IAPHelperWrapper : IAPHelper {
    GMAppManager *gmAppMananger;
}


+ (IAPHelperWrapper *) sharedHelper;
@end
