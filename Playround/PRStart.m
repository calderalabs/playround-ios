//
//  PRStart.m
//  Playround
//
//  Created by Eugenio Depalo on 7/10/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRStart.h"

@implementation PRStart

+ (NSString *)keyPath {
    return @"start";
}

+ (NSString *)remotePath {
    return [NSString stringWithFormat:@"%@/:round.objectID/starts", [PRRound remotePath]];
}

@end
