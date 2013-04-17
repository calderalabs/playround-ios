//
//  PRArena.m
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRArena.h"

@implementation PRArena

+ (NSString *)keyPath {
    return @"arenas";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

@end
