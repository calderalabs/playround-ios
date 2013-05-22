//
//  PRModel.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRObjectManager.h"

@interface PRModel ()

- (void)performRequestWithMethod:(RKRequestMethod)method completion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion;

@end

@implementation PRModel

+ (RKObjectMapping *)objectMapping {
    return [RKObjectMapping mappingForClass:self];
}

+ (NSString *)keyPath {
    NSAssert(NO, @"You must override +keyPath in PRModel subclasses.");
    return nil;
}

+ (NSString *)pluralKeyPath {
    return [NSString stringWithFormat:@"%@s", self.keyPath];
}

+ (NSString *)remotePath {
    NSAssert(NO, @"You must override +remotePath in PRModel subclasses.");
    return nil;
}

+ (NSString *)versionedRemotePath {
    return [NSString stringWithFormat:@"/v1%@", self.remotePath];
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationAll;
}

+ (void)setObjectManager:(PRObjectManager *)objectManager {
    for(NSString *keyPath in @[self.keyPath, self.pluralKeyPath])
        [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping
                                                                                 pathPattern:nil
                                                                                     keyPath:keyPath
                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:self.objectMapping.inverseMapping
                                                                              objectClass:self rootKeyPath:self.keyPath]];
    
    if(self.supportedOperationTypes & PRModelOperationCreate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:self.versionedRemotePath
                                                                 method:RKRequestMethodPOST]];
    
    if(self.supportedOperationTypes & PRModelOperationRead)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.versionedRemotePath]
                                                                 method:RKRequestMethodGET]];
    
    if(self.supportedOperationTypes & PRModelOperationUpdate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.versionedRemotePath]
                                                                 method:RKRequestMethodPUT]];
    
    if(self.supportedOperationTypes & PRModelOperationDelete)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.versionedRemotePath]
                                                                 method:RKRequestMethodDELETE]];
}

+ (void)allWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [self allWhere:nil completion:completion];
}

+ (void)allWhere:(NSDictionary *)parameters
         completion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [[PRObjectManager sharedManager] getObjectsAtPath:self.versionedRemotePath
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  if(completion)
                                                      completion(operation, mappingResult, nil);
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  if(completion)
                                                      completion(operation, nil, error);
                                              }];
}

- (void)performRequestWithMethod:(RKRequestMethod)method completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion {
    RKObjectRequestOperation *operation = [PRObjectManager.sharedManager appropriateObjectRequestOperationWithObject:self method:method path:nil parameters:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                NSLog(@"%@", operation.HTTPRequestOperation.responseString);
        if(completion)
            completion(operation, mappingResult, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion)
            completion(operation, nil, error);
    }];
    
    [PRObjectManager.sharedManager enqueueObjectRequestOperation:operation];
}

- (void)readWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [self performRequestWithMethod:RKRequestMethodGET completion:completion];
}

- (void)createWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [self performRequestWithMethod:RKRequestMethodPOST completion:completion];
}

@end
