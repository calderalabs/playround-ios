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

@property (nonatomic, weak) Class targetClass;
@property (nonatomic, copy) NSString *remotePath;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, strong) RKRequestDescriptor *requestDescriptor;

@end

@implementation PRRelationshipDescriptor

- (NSString *)versionedRemotePath {
    return [PRModel versionedPathFromPath:self.remotePath];
}

- (RKObjectMapping *)objectMapping {
    return [(id)self.targetClass objectMapping];
}

+ (PRRelationshipDescriptor *)relationshipDescriptorWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath {
    return [[PRRelationshipDescriptor alloc] initWithTargetClass:targetClass
                                                      remotePath:remotePath
                                                         keyPath:keyPath];
}

- (id)initWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath {
    self = [super init];
    
    if(self) {
        self.targetClass = targetClass;
        self.remotePath = remotePath;
        self.keyPath = keyPath;
        
        self.requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:
                                                                  [self.targetClass objectMapping].inverseMapping
                                                                       objectClass:targetClass
                                                                       rootKeyPath:nil
                                                                            method:RKRequestMethodPOST];
    }
    
    return self;
}

@end
