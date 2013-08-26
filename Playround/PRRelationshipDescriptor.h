//
//  PRRelationshipDescriptor.h
//  Playround
//
//  Created by Eugenio Depalo on 6/20/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

@interface PRRelationshipDescriptor : NSObject

@property (nonatomic, strong, readonly) RKRequestDescriptor *requestDescriptor;
@property (nonatomic, strong, readonly) RKResponseDescriptor *responseDescriptor;
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, copy, readonly) NSString *versionedRemotePath;

+ (PRRelationshipDescriptor *)relationshipDescriptorWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath;

- (id)initWithTargetClass:(Class)targetClass remotePath:(NSString *)remotePath keyPath:(NSString *)keyPath;

@end
