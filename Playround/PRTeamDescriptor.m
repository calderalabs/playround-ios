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

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return nil;
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping *mapping = [super objectMapping];
    
    [mapping addMappingsFromDictionary:@{
         @"name@response": @"name",
         @"display_name@response": @"displayName",
         @"number_of_players@response": @"numberOfPlayers"
    }];
    
    return mapping;
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationNone;
}

- (PRTeam *)newTeam {
    PRTeam *team = [[PRTeam alloc] init];
    team.descriptor = self;
    return team;
}

@end
