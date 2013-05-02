//
//  PRUser.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRUser.h"

static PRUser *sCurrentUser = nil;

@implementation PRUser

+ (NSString *)keyPath {
    return @"users";
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
        @"id": @"objectID",
        @"name": @"name",
        @"picture_url": @"pictureURL"
    }];
    
    return mapping;
}


+ (PRUser *)current {
    return sCurrentUser;
}

+ (void)setCurrent:(PRUser *)session {
    sCurrentUser = session;
}

+ (void)currentWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    PRUser *current = [[self alloc] init];
    current.objectID = @"me";
    
    [current getWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *result, NSError *error) {
        if(!error)
            self.current = result.firstObject;
        
        if(completion)
            completion(operation, result, error);
    }];
}

@end
