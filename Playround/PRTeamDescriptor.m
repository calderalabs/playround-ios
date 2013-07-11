//
//  PRTeamDescriptor.m
//  Playround
//
//  Created by Eugenio Depalo on 6/24/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRTeamDescriptor.h"
#import "PRTeam.h"

@implementation PRTeamDescriptor

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [super objectMapping];
    
    [mapping addAttributeMappingsFromDictionary:@{
         @"name": @"name",
         @"display_name": @"displayName",
         @"number_of_players": @"numberOfPlayers"
     }];
    
    return mapping;
}

- (PRTeam *)newTeam {
    PRTeam *team = [[PRTeam alloc] init];
    team.descriptor = self;
    return team;
}

@end
