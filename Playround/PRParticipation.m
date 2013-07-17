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
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"user" mapping:[PRUser objectMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"user.id": @"user.objectID"
    }];
    
    return mapping;
}

+ (NSArray *)excludedRequestAttributes {
    return [[super excludedRequestAttributes] arrayByAddingObjectsFromArray:@[
        @"user"
    ]];
}

- (id)init {
    self = [super init];
    
    if(self) {
        self.user = [[PRUser alloc] init];
    }
    
    return self;
}

@end
