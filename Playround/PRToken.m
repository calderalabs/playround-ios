//
//  PRToken.m
//  Playround
//
//  Created by Eugenio Depalo on 5/2/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRToken.h"

@implementation PRToken

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)remotePath {
    return @"/tokens";
}

+ (NSString *)keyPath {
    return @"token";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationCreate;
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping* mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
        @"value": @"value",
        @"facebook_access_token@request": @"facebookAccessToken",
        @"user@response": @"user@PRUser"
    }];
    
    return mapping;
}

@end
