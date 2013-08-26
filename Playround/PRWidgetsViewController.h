//
//  PRWidgetsViewController.h
//  Playround
//
//  Created by Eugenio Depalo on 8/26/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRound.h"

@interface PRWidgetsViewController : UIViewController

+ (void)registerClass:(Class)controllerClass forGame:(NSString *)game;
+ (Class)classForGame:(NSString *)game;
+ (PRWidgetsViewController *)newControllerForGame:(NSString *)game;

@property (nonatomic, retain) PRRound *round;

@end
