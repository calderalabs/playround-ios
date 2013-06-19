//
//  PRToken.m
//  Playround
//
//  Created by Eugenio Depalo on 5/2/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRToken.h"

@implementation PRToken

+ (NSString *)remotePath {
    return @"/tokens";
}

+ (NSString *)keyPath {
    return @"token";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationCreate;
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping* mapping = [super objectMapping];
    
    [mapping addRelationshipMappingWithSourceKeyPath:@"user" mapping:[PRUser objectMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"value": @"value",
        @"facebook_access_token": @"facebookAccessToken"
    }];
    
    return mapping;
}

@end
