//
//  PRGame.m
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRGame.h"

@implementation PRGame

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return @"game";
}

+ (NSString *)remotePath {
    return @"/games";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping* mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
         @"name@response": @"name",
         @"display_name@response": @"displayName",
         @"picture_url@response": @"pictureURL",
         @"teams": @"teamDescriptors@PRTeamDescriptor"
    }];
    
    return mapping;
}

@end
