//
//  PRRelationshipDescriptor.h
//  Playround
//
//  Created by Eugenio Depalo on 6/20/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

@interface PRRelationshipDescriptor : NSObject

@property (nonatomic, weak, readonly) Class targetClass;
@property (nonatomic, strong, readonly) RKObjectMapping *objectMapping;
@property (nonatomic, copy, readonly) NSString *versionedRemotePath;
@property (nonatomic, copy, readonly) NSString *keyPath;

+ (PRRelationshipDescriptor *)relationshipDescriptorWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath;

@end
