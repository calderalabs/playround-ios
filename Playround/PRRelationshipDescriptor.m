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

@end

@implementation PRRelationshipDescriptor

- (NSString *)versionedRemotePath {
    return [PRModel versionedPathFromPath:self.remotePath];
}

- (RKObjectMapping *)objectMapping {
    return [(id)self.targetClass objectMapping];
}

+ (PRRelationshipDescriptor *)relationshipDescriptorWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath {
    PRRelationshipDescriptor *relationshipDescriptor = [[PRRelationshipDescriptor alloc] init];
    
    relationshipDescriptor.targetClass = targetClass;
    relationshipDescriptor.remotePath = remotePath;
    relationshipDescriptor.keyPath = keyPath;
    
    return relationshipDescriptor;
}

@end
