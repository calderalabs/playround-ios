//
//  PRRound.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRound.h"
#import "PRParticipation.h"

@implementation PRRound

+ (NSString *)keyPath {
    return @"round";
}

+ (NSString *)remotePath {
    return @"/rounds";
}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping* mapping = [super objectMapping];

    [mapping addRelationshipMappingWithSourceKeyPath:@"user" mapping:[PRUser objectMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"game" mapping:[PRGame objectMapping]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"arena" mapping:[PRArena objectMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"state": @"state",
        @"created_at": @"createdAt"
    }];

    return mapping;
}

- (NSArray *)participations {
    return [NSArray arrayWithArray:_participations];
}

- (void)addParticipant:(PRUser *)user team:(PRTeam *)team {
    [self addParticipant:user team:team prepend:NO];
}

- (void)addParticipant:(PRUser *)user team:(PRTeam *)team prepend:(BOOL)prepend {
    PRParticipation *participation = [[PRParticipation alloc] init];
    
    participation.user = user;
    participation.team = team;
    
    [_participations removeObjectsAtIndexes:[_participations indexesOfObjectsPassingTest:^BOOL(PRParticipation *p, NSUInteger idx, BOOL *stop) {
        return [p.user.objectID isEqualToString:user.objectID];
    }]];
    
    if(prepend) {
        NSUInteger firstParticipationIndex = [_participations indexOfObjectPassingTest:^BOOL(PRParticipation *p, NSUInteger idx, BOOL *stop) {
            return [p.team.name isEqualToString:participation.team.name];
        }];
        
        if(firstParticipationIndex == NSNotFound)
            firstParticipationIndex = 0;
        
        [_participations insertObject:participation atIndex:firstParticipationIndex];
    }
    else {
        [_participations addObject:participation];
    }
    
    NSArray *teamParticipations = [self participationsForTeam:team];
    
    if(teamParticipations.count > team.numberOfPlayers) {
        NSArray *exceedingTeamParticipations = [teamParticipations objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(team.numberOfPlayers, teamParticipations.count - team.numberOfPlayers)]];
        
        [_participations removeObjectsInArray:exceedingTeamParticipations];
    }
}

- (void)removeParticipant:(PRUser *)user {
    [_participations removeObjectAtIndex:[_participations indexOfObjectPassingTest:^BOOL(PRParticipation *participation, NSUInteger idx, BOOL *stop) {
        return [participation.user.objectID isEqualToString:user.objectID];
    }]];
}

- (void)removeAllParticipants {
    [_participations removeAllObjects];
}

- (NSArray *)participationsForTeam:(PRTeam *)team {
    return [self.participations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"team.name == %@", team.name]];
}

- (id)init {
    self = [super init];
    
    if(self) {
        _participations = [NSMutableArray array];
    }
    
    return self;
}

@end
