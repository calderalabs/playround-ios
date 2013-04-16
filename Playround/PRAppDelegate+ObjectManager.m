//
//  PRAppDelegate+ObjectManager.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRAppDelegate+ObjectManager.h"
#import "PRRound.h"

@implementation PRAppDelegate (ObjectManager)

- (RKObjectManager *)objectManager {
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:PR_API_BASE_URL]];
    
    for(Class class in @[[PRRound class], [PRUser class]])
        [class setObjectManager:objectManager];
    
    return objectManager;
}

@end
