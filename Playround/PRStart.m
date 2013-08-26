//
//  PRStart.m
//  Playround
//
//  Created by Eugenio Depalo on 7/10/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRStart.h"

@implementation PRStart

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return @"start";
}

+ (NSString *)remotePath {
    return [NSString stringWithFormat:@"%@/:round.objectID/starts", [PRRound remotePath]];
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping *mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
        @"round@response": @"round@PRRound",
    }];
    
    return mapping;
}

@end
