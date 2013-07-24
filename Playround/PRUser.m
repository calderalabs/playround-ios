//
//  PRUser.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRUser.h"
#import "PRRelationshipDescriptor.h"

NSString *PRUserDidReadCurrentNotification = @"PRUserDidReadCurrentNotification";

@implementation PRUser

+ (NSString *)keyPath {
    return @"user";
}

+ (NSString *)remotePath {
    return @"/users";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationRead;
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping* mapping = [super objectMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"name": @"name",
        @"picture_url": @"pictureURL"
    }];
    
    return mapping;
}

+ (NSDictionary *)relationships {
    return @{
        @"buddies": [PRRelationshipDescriptor relationshipDescriptorWithTargetClass:self
                                                                         remotePath:@"/users/:objectID/buddies"
                                                                            keyPath:@"buddies"
                    ]
    };
}

+ (void)readCurrentWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    PRUser *current = [[self alloc] init];
    current.objectID = @"me";
    
    [current readWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *result, NSError *error) {
        if(!error)
            [NSNotificationCenter.defaultCenter postNotificationName:PRUserDidReadCurrentNotification
                                                              object:self
                                                            userInfo:@{ @"user": result.firstObject }];
        
        if(completion)
            completion(operation, result, error);
    }];
}

@end
