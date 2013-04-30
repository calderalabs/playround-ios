//
//  PRModel.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@implementation PRModel

+ (RKObjectMapping *)objectMapping {
    return [RKObjectMapping mappingForClass:self];
}

+ (NSString *)keyPath {
    NSAssert(NO, @"You must override +keyPath in PRModel subclasses.");
    return nil;
}

+ (NSString *)remotePath {
    NSAssert(NO, @"You must override +remotePath in PRModel subclasses.");
    return nil;
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationAll;
}

+ (void)setObjectManager:(RKObjectManager *)objectManager {
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping
                                                                                 pathPattern:nil
                                                                                     keyPath:self.keyPath
                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    PRModelOperationType operationTypes = [self supportedOperationTypes];
    
    if(operationTypes & PRModelOperationCreate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:self.remotePath
                                                                 method:RKRequestMethodPOST]];
    
    if(operationTypes & PRModelOperationRead)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.remotePath]
                                                                 method:RKRequestMethodGET]];
    
    if(operationTypes & PRModelOperationUpdate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.remotePath]
                                                                 method:RKRequestMethodPUT]];
    
    if(operationTypes & PRModelOperationDelete)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.remotePath]
                                                                 method:RKRequestMethodDELETE]];
}

+ (void)allWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [self allWhere:nil completion:completion];
}

+ (void)allWhere:(NSDictionary *)parameters
         completion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [[RKObjectManager sharedManager] getObjectsAtPath:self.remotePath
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  if(completion)
                                                      completion(operation, mappingResult, nil);
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  if(completion)
                                                      completion(operation, nil, error);
                                              }];
}

- (void)getWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [[RKObjectManager sharedManager] getObject:self path:nil parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if(completion)
            completion(operation, mappingResult, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion)
            completion(operation, nil, error);
    }];
}

@end
