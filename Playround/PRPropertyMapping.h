//
//  PRPropertyMapping.h
//  Playround
//
//  Created by Eugenio Depalo on 8/26/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

typedef enum {
    PRPropertyMappingScopeRequest = 1 << 0,
    PRPropertyMappingScopeResponse = 1 << 1,
    PRPropertyMappingScopeBoth = (1 << 2) - 1
} PRPropertyMappingScope;

@interface PRPropertyMapping : NSObject

@property (nonatomic, copy) NSString *sourceKeyPath;
@property (nonatomic, copy) NSString *destinationKeyPath;
@property (nonatomic, assign) PRPropertyMappingScope scope;
@property (nonatomic, retain, readonly) RKPropertyMapping *requestMapping;
@property (nonatomic, retain, readonly) RKPropertyMapping *responseMapping;

@end
