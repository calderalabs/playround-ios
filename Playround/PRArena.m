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
    return @"arena";
}

+ (NSString *)remotePath {
    return @"/arenas";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping* mapping = [super objectMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"name": @"name",
        @"latitude": @"latitude",
        @"longitude": @"longitude"
    }];
    
    return mapping;
}

@end
