//
//  PRArena.m
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRArena.h"

@implementation PRArena

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return @"arena";
}

+ (NSString *)remotePath {
    return @"/arenas";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping* mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
        @"name@response": @"name",
        @"latitude": @"latitude",
        @"longitude": @"longitude"
    }];
    
    return mapping;
}

@end
