//
//  PRParticipation.m
//  Playround
//
//  Created by Eugenio Depalo on 6/28/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRParticipation.h"

@implementation PRParticipation

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [super objectMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"team": @"team.name",
        @"user.id": @"user.objectID"
    }];
    
    return mapping;
}

@end
