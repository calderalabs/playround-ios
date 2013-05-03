//
//  PRGame.m
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRGame.h"

@implementation PRGame

+ (NSString *)keyPath {
    return @"game";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

@end
