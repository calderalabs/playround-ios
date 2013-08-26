//
//  PRPropertyMapping.m
//  Playround
//
//  Created by Eugenio Depalo on 8/26/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRPropertyMapping.h"

@implementation PRPropertyMapping

- (RKPropertyMapping *)requestMapping {
    if(self.scope & PRPropertyMappingScopeRequest)
        return [RKAttributeMapping attributeMappingFromKeyPath:self.destinationKeyPath toKeyPath:self.sourceKeyPath];
    
    return nil;
}

- (RKPropertyMapping *)responseMapping {
    if(self.scope & PRPropertyMappingScopeResponse)
        return [RKAttributeMapping attributeMappingFromKeyPath:self.sourceKeyPath toKeyPath:self.destinationKeyPath];
    
    return nil;
}

@end
