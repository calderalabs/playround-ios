//
//  PRRelationshipDescriptor.m
//  Playround
//
//  Created by Eugenio Depalo on 6/20/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRelationshipDescriptor.h"
#import "PRModel.h"

@interface PRRelationshipDescriptor ()

@property (nonatomic, strong) RKRequestDescriptor *requestDescriptor;
@property (nonatomic, strong) RKResponseDescriptor *responseDescriptor;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) NSString *versionedRemotePath;

@end

@implementation PRRelationshipDescriptor

+ (PRRelationshipDescriptor *)relationshipDescriptorWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath {
    return [[PRRelationshipDescriptor alloc] initWithTargetClass:targetClass
                                                      remotePath:remotePath
                                                         keyPath:keyPath];
}


- (id)initWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath {
    self = [super init];
    
    if(self) {
        self.keyPath = keyPath;
        self.versionedRemotePath = [PRModel versionedPathFromPath:remotePath];
        
        PRObjectMapping *mapping = (PRObjectMapping *)[(id)targetClass objectMapping];
        
        self.responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping.responseMapping
                                                            method:RKRequestMethodAny
                                                       pathPattern:self.versionedRemotePath
                                                           keyPath:keyPath
                                                                          statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        
        self.requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping.requestMapping
                                                                       objectClass:targetClass
                                                                       rootKeyPath:nil
                                                                            method:RKRequestMethodPOST];
    }
    
    return self;
}

@end
