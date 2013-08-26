//
//  PRWidgetsViewController.m
//  Playround
//
//  Created by Eugenio Depalo on 8/26/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRWidgetsViewController.h"

static NSMutableDictionary *controllerMappings = nil;

@implementation PRWidgetsViewController

+ (void)registerClass:(Class)controllerClass forGame:(NSString *)game {
    if(!controllerMappings)
        controllerMappings = [NSMutableDictionary dictionary];
    
    controllerMappings[game] = controllerClass;
}

+ (Class)classForGame:(NSString *)game {
    return controllerMappings[game];
}

+ (PRWidgetsViewController *)newControllerForGame:(NSString *)game {
    Class controllerClass = controllerMappings[game];
    PRWidgetsViewController *controller = nil;
    
    if(controllerClass)
        controller = [[controllerClass alloc] init];
    
    return controller;
}

- (id)init {
    return [self initWithNibName:NSStringFromClass(self.class) bundle:nil];
}

- (void)awakeFromNib {
    self.navigationItem.title = @"Tools";
}

@end
