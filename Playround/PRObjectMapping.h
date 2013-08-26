//
//  PRObjectMapping.h
//  Playround
//
//  Created by Eugenio Depalo on 8/22/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

@interface PRObjectMapping : NSObject <NSCopying>

@property (nonatomic, strong, readonly) RKObjectMapping *requestMapping;
@property (nonatomic, strong, readonly) RKObjectMapping *responseMapping;

+ (PRObjectMapping *)mappingForClass:(Class)objectClass;

- (id)initWithClass:(Class)objectClass;
- (void)addMappingsFromDictionary:(NSDictionary *)dictionary;
- (void)removeMappingWithSourceKeyPath:(NSString *)keyPath;
- (id)objectForKeyedSubscript:(id)key;

@end
