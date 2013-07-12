//
//  PRWinning.m
//  Playround
//
//  Created by Eugenio Depalo on 7/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRWinning.h"

@implementation PRWinning

+ (NSString *)keyPath {
    return @"winning";
}

+ (NSString *)remotePath {
    return [NSString stringWithFormat:@"%@/:round.objectID/winnings", [PRRound remotePath]];
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [super objectMapping];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"round" mapping:[PRRound objectMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"team_name": @"team.descriptor.name"
    }];
    
    return mapping;
}

+ (NSArray *)excludedRequestAttributes {
    return [[super excludedRequestAttributes] arrayByAddingObjectsFromArray:@[
        @"round"
    ]];
}

@end
