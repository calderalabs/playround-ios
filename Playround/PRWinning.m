//
//  PRWinning.m
//  Playround
//
//  Created by Eugenio Depalo on 7/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRWinning.h"

@implementation PRWinning

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return @"winning";
}

+ (NSString *)remotePath {
    return [NSString stringWithFormat:@"%@/:round.objectID/winnings", [PRRound remotePath]];
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping *mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
        @"round@response": @"round@PRRound",
        @"team_name": @"team.descriptor.name"
    }];
    
    return mapping;
}

@end
