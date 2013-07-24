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

+ (NSString *)primaryKey {
    return @"objectID";
}

+ (NSString *)remotePrimaryKey {
    return @"id";
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    
    [mapping addAttributeMappingsFromDictionary:@{
        self.remotePrimaryKey: self.primaryKey
    }];
    
    return mapping;
}

+ (NSArray *)excludedRequestAttributes {
    return @[];
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
    for(NSString *keyPath in @[self.keyPath, self.pluralKeyPath])
        [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping
                                                                                          method:RKRequestMethodAny
                                                                                     pathPattern:self.versionedRemotePath
                                                                                         keyPath:keyPath
                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:self.objectMapping
                                                                                      method:RKRequestMethodAny
                                                                                 pathPattern:[NSString stringWithFormat:@"%@/:%@", self.versionedRemotePath, self.primaryKey]
                                                                                     keyPath:self.keyPath
                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    RKObjectMapping *inverseMapping = self.objectMapping.inverseMapping;
    
    for(NSString *attribute in self.excludedRequestAttributes)
        [inverseMapping removePropertyMapping:inverseMapping.propertyMappingsBySourceKeyPath[attribute]];
    
    [objectManager addRequestDescriptor:[RKRequestDescriptor requestDescriptorWithMapping:inverseMapping
                                                                              objectClass:self
                                                                              rootKeyPath:self.keyPath
                                                                                   method:RKRequestMethodPOST | RKRequestMethodPATCH]];
    
    if(self.supportedOperationTypes & PRModelOperationCreate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:self.versionedRemotePath
                                                                 method:RKRequestMethodPOST]];
    
    if(self.supportedOperationTypes & PRModelOperationRead)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:%@", self.versionedRemotePath, self.primaryKey]
                                                                 method:RKRequestMethodGET]];
    
    if(self.supportedOperationTypes & PRModelOperationUpdate)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:%@", self.versionedRemotePath, self.primaryKey]
                                                                 method:RKRequestMethodPATCH]];
    
    if(self.supportedOperationTypes & PRModelOperationDelete)
        [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:self
                                                            pathPattern:[NSString stringWithFormat:@"%@/:%@", self.versionedRemotePath, self.primaryKey]
                                                                 method:RKRequestMethodDELETE]];
    
    [self.relationships enumerateKeysAndObjectsUsingBlock:^(NSString *name, PRRelationshipDescriptor *relationship, BOOL *stop) {
        [objectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:relationship.objectMapping
                                                                                          method:RKRequestMethodAny
                                                                                    pathPattern:relationship.versionedRemotePath
                                                                                        keyPath:relationship.keyPath
                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
                
        [objectManager.router.routeSet addRoute:[RKRoute routeWithRelationshipName:name
                                                              objectClass:self
                                                              pathPattern:relationship.versionedRemotePath
                                                                   method:RKRequestMethodAny]];
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

- (void)createRelationship:(id)object name:(NSString *)name completion:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingOperation, NSError *error))completion {
    PRRelationshipDescriptor *relationshipDescriptor = self.class.relationships[name];

    NSError *error;
    id serializedObject;
    
    if([object isKindOfClass:[NSArray class]]) {
        NSArray *objectsToSerialize = object;
        NSMutableArray *serializedObjects = [NSMutableArray array];
        
        for(id objectToSerialize in objectsToSerialize) {
            [serializedObjects addObject:[RKObjectParameterization parametersWithObject:objectToSerialize requestDescriptor:relationshipDescriptor.requestDescriptor error:&error]];
             
             if(error)
                break;
        }
        
        serializedObject = serializedObjects;
    }
    else
        serializedObject = [RKObjectParameterization parametersWithObject:object requestDescriptor:relationshipDescriptor.requestDescriptor error:&error];
    
    NSAssert(!error, @"Error while creating relationship: %@", error.localizedDescription);
    
    NSMutableURLRequest *request = [PRObjectManager.sharedManager requestWithPathForRelationship:name ofObject:self method:RKRequestMethodPOST parameters:@{ relationshipDescriptor.keyPath: serializedObject }];
    
    RKObjectRequestOperation *operation = [PRObjectManager.sharedManager objectRequestOperationWithRequest:request success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if(completion)
            completion(operation, mappingResult, nil);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if(completion)
            completion(operation, nil, error);
    }];
    
    [PRObjectManager.sharedManager enqueueObjectRequestOperation:operation];
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

- (void)updateWithCompletion:(void (^)(RKObjectRequestOperation *, RKMappingResult *, NSError *))completion {
    [self performRequestWithMethod:RKRequestMethodPATCH completion:completion];
}

@end
