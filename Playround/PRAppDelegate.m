//
//  PRAppDelegate.m
//  Playround
//
//  Created by Eugenio Depalo on 3/22/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRAppDelegate.h"
#import "PRObjectManager.h"

@implementation PRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PRObjectManager.sharedManager = [[PRObjectManager alloc] init];
 
    [self.window makeKeyAndVisible];
    [self.window.rootViewController performSegueWithIdentifier:@"Login" sender:self];
    
    return YES;
}

@end
