//
//  PRParticipation.m
//  Playround
//
//  Created by Eugenio Depalo on 6/28/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRParticipation.h"
#import "PRPropertyMapping.h"

@implementation PRParticipation

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)remotePath {
    return nil;
}

+ (NSString *)keyPath {
    return @"participation";
}

+ (NSString *)remotePrimaryKey {
    return @"user.id";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping *mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
        @"team": @"team.descriptor.name",
        @"user": @"user@PRUser"
    }];
    
    PRPropertyMapping *userIdMapping = mapping[@"user"][[PRUser remotePrimaryKey]];
    userIdMapping.scope |= PRPropertyMappingScopeRequest;

    return mapping;
}

@end
