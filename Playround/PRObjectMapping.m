//
//  PRObjectMapping.m
//  Playround
//
//  Created by Eugenio Depalo on 8/22/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRObjectMapping.h"
#import "PRPropertyMapping.h"
#import "PRRelationshipMapping.h"

@interface PRObjectMapping ()

@property (nonatomic, assign) Class objectClass;
@property (nonatomic, retain) NSMutableArray *propertyMappings;

- (PRPropertyMapping *)mappingWithSourceKeyPath:(NSString *)keyPath;

@end

@implementation PRObjectMapping

+ (PRObjectMapping *)mappingForClass:(Class)objectClass {
    return [[self alloc] initWithClass:objectClass];
}

- (id)copyWithZone:(NSZone *)zone {
    PRObjectMapping *copy = [[[self class] allocWithZone:zone] init];
    
    copy.objectClass = self.objectClass;
    copy.propertyMappings = self.propertyMappings;
    
    return copy;
}

- (id)initWithClass:(Class)objectClass {
    self = [super init];
    
    if(self) {
        self.objectClass = objectClass;
        self.propertyMappings = [NSMutableArray array];
    }

    return self;
}

- (PRPropertyMapping *)mappingWithSourceKeyPath:(NSString *)keyPath {
    for(PRPropertyMapping *propertyMapping in self.propertyMappings)
        if([propertyMapping.sourceKeyPath isEqualToString:keyPath])
            return propertyMapping;
    
    return nil;
}

- (RKObjectMapping *)requestMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    
    for(PRPropertyMapping *propertyMapping in self.propertyMappings) {
        RKPropertyMapping *requestMapping = propertyMapping.requestMapping;
        
        if(requestMapping)
            [objectMapping addPropertyMapping:requestMapping];
    }
    
    return objectMapping;
}

- (RKObjectMapping *)responseMapping {
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:self.objectClass];
    
    for(PRPropertyMapping *propertyMapping in self.propertyMappings) {
        RKPropertyMapping *responseMapping = propertyMapping.responseMapping;
        
        if(responseMapping)
            [objectMapping addPropertyMapping:responseMapping];
    }
    
    return objectMapping;
}

- (void)addMappingsFromDictionary:(NSDictionary *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *source, NSString *destination, BOOL *stop) {
        NSArray *sourceComponents = [source componentsSeparatedByString:@"@"];
        NSArray *destinationComponents = [destination componentsSeparatedByString:@"@"];
        NSString *sourceKeyPath = sourceComponents[0];
        NSString *scopeName = sourceComponents.count > 1 ? sourceComponents[1] : @"both";
        NSString *destinationKeyPath = destinationComponents[0];
        NSString *relationshipClassName = destinationComponents.count > 1 ? destinationComponents[1] : nil;
        
        PRPropertyMapping *propertyMapping;
        
        if(relationshipClassName) {
            PRRelationshipMapping *relationshipMapping = [[PRRelationshipMapping alloc] init];
            relationshipMapping.objectClass = NSClassFromString(relationshipClassName);
            
            propertyMapping = relationshipMapping;
        }
        else
            propertyMapping = [[PRPropertyMapping alloc] init];
        
        propertyMapping.sourceKeyPath = sourceKeyPath;
        propertyMapping.destinationKeyPath = destinationKeyPath;
        
        PRPropertyMappingScope scope;
        
        if([scopeName isEqualToString:@"request"])
            scope = PRPropertyMappingScopeRequest;
        else if([scopeName isEqualToString:@"response"])
            scope = PRPropertyMappingScopeResponse;
        else if([scopeName isEqualToString:@"both"])
            scope = PRPropertyMappingScopeBoth;
        else
            NSAssert(NO, @"Invalid mapping scope for attribute with"
                         @"source key path: %@ and destination key path: %@", sourceKeyPath, destinationKeyPath);
        
        propertyMapping.scope = scope;
        
        [self.propertyMappings addObject:propertyMapping];
    }];
}

- (void)removeMappingWithSourceKeyPath:(NSString *)keyPath {
    [self.propertyMappings removeObject:[self mappingWithSourceKeyPath:keyPath]];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self mappingWithSourceKeyPath:key];
}

@end
