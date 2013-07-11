//
//  PRGame.m
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRGame.h"
#import "PRTeamDescriptor.h"

@implementation PRGame

+ (NSString *)keyPath {
    return @"game";
}

+ (NSString *)remotePath {
    return @"/games";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping* mapping = [super objectMapping];
    
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"teams"
                                                                            toKeyPath:@"teamDescriptors"
                                                                          withMapping:[PRTeamDescriptor objectMapping]]];
    
    [mapping addAttributeMappingsFromDictionary:@{
         @"name": @"name",
         @"display_name": @"displayName",
         @"picture_url": @"pictureURL",
    }];
    
    return mapping;
}

@end
