//
//  PRTeam.m
//  Playround
//
//  Created by Eugenio Depalo on 6/24/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRTeam.h"

@implementation PRTeam

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    
    [mapping addAttributeMappingsFromDictionary:@{
         @"name": @"name",
         @"display_name": @"displayName",
         @"number_of_players": @"numberOfPlayers"
     }];
    
    return mapping;
}

@end
