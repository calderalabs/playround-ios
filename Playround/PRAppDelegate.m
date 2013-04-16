//
//  PRAppDelegate.m
//  Playround
//
//  Created by Eugenio Depalo on 3/22/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRAppDelegate.h"
#import "PRAppDelegate+ObjectManager.h"

@implementation PRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [RKObjectManager setSharedManager:self.objectManager];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
