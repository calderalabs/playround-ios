//
//  PRRound.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRound.h"

@implementation PRRound

+ (NSString *)keyPath {
    return @"round";
}

+ (NSString *)remotePath {
    return @"/rounds";
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping* mapping = [super objectMapping];

    [mapping addRelationshipMappingWithSourceKeyPath:@"user" mapping:[PRUser objectMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"game" mapping:[PRGame objectMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"arena" mapping:[PRArena objectMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"state": @"state",
        @"created_at": @"createdAt"
    }];

    return mapping;
}

@end
