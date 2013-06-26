//
//  PRModel.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRObjectManager.h"
#import "PRRelationshipDescriptor.h"

@interface PRModel ()

- (void)performRequestWithMethod:(RKRequestMethod)method completion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion;

@end

@implementation PRModel

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"id": @"objectID"
    }];
    
    return mapping;
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

+ (NSString *)versionedPathFromPath:(NSString *)path {
    return [NSString stringWithFormat:@"/v1%@", path];
}

+ (NSString *)versionedRemotePath {
    return [self versionedPathFromPath:self.remotePath];
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationAll;
}

+ (NSDictionary *)relationships {
    return @{};
}

+ (void)setObjectManager:(PRObjectManager *)objectManager {
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping
                                                                                 pathPattern:self.versionedRemotePath
                                                                                     keyPath:self.pluralKeyPath
                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping
                                                                                 pathPattern:[NSString stringWithFormat:@"%@/:objectID", self.versionedRemotePath]
                                                                                     keyPath:self.keyPath
                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:self.objectMapping.inverseMapping
                                                                              objectClass:self
                                                                              rootKeyPath:self.keyPath]];
    
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
    
    [self.relationships enumerateKeysAndObjectsUsingBlock:^(NSString *name, PRRelationshipDescriptor *relationship, BOOL *stop) {
        [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:relationship.objectMapping
                                                                                    pathPattern:relationship.versionedRemotePath
                                                                                        keyPath:relationship.keyPath
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
        
        [objectManager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:name
                                                              objectClass:self
                                                              pathPattern:relationship.versionedRemotePath
                                                                   method:RKRequestMethodGET]];
    }];
}

+ (void)allWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [self allWhere:nil completion:completion];
}

+ (void)allWhere:(NSDictionary *)parameters
         completion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [PRObjectManager.sharedManager getObjectsAtPath:self.versionedRemotePath
                                           parameters:parameters
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  if(completion)
                                                      completion(operation, mappingResult, nil);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  if(completion)
                                                      completion(operation, nil, error);
                                              }];
}

- (void)readRelationship:(NSString *)relationship completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion {
    [self readRelationship:relationship where:nil completion:completion];
}

- (void)readRelationship:(NSString *)relationship
                   where:(NSDictionary *)parameters
              completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion {
    [PRObjectManager.sharedManager getObjectsAtPathForRelationship:relationship
                                                          ofObject:self
                                                        parameters:parameters
                                                           success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                               if(completion)
                                                                   completion(operation, mappingResult, nil);
                                                           }
                                                           failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                               if(completion)
                                                                   completion(operation, nil, error);
                                                           }];
}

- (void)performRequestWithMethod:(RKRequestMethod)method completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion {
    RKObjectRequestOperation *operation = [PRObjectManager.sharedManager appropriateObjectRequestOperationWithObject:self method:method path:nil parameters:nil];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
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
