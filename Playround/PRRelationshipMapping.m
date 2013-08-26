//
//  PRRelationshipMapping.m
//  Playround
//
//  Created by Eugenio Depalo on 8/26/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRelationshipMapping.h"
#import "PRObjectMapping.h"

@interface PRRelationshipMapping ()

@property (nonatomic, copy) PRObjectMapping *objectMapping;

@end

@implementation PRRelationshipMapping

- (RKPropertyMapping *)requestMapping {
    if(self.scope & PRPropertyMappingScopeRequest)
        return [RKRelationshipMapping relationshipMappingFromKeyPath:self.destinationKeyPath toKeyPath:self.sourceKeyPath withMapping:self.objectMapping.requestMapping];
    
    return nil;
}

- (RKPropertyMapping *)responseMapping {
    if(self.scope & PRPropertyMappingScopeResponse)
        return [RKRelationshipMapping relationshipMappingFromKeyPath:self.sourceKeyPath toKeyPath:self.destinationKeyPath withMapping:self.objectMapping.responseMapping];
    
    return nil;
}

- (void)setObjectClass:(Class)objectClass {
    if(objectClass != _objectClass) {
        _objectClass = objectClass;
        
        PRObjectMapping *objectMapping = (PRObjectMapping *)[(id)objectClass objectMapping];
        self.objectMapping = objectMapping;
    }
}

- (id)objectForKeyedSubscript:(id)key {
    return [self.objectMapping objectForKeyedSubscript:key];
}

@end
