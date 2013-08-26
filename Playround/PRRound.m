//
//  PRRound.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRound.h"
#import "PRTeamDescriptor.h"
#import "PRRelationshipDescriptor.h"
#import "PRParticipation.h"

@implementation PRRound

+ (void)load {
    [self registerClass:self];
}

+ (NSString *)keyPath {
    return @"round";
}

+ (NSString *)remotePath {
    return @"/rounds";
}

+ (PRObjectMapping *)objectMapping {
    PRObjectMapping *mapping = [super objectMapping];

    [mapping addMappingsFromDictionary:@{
        @"state": @"state",
        @"created_at": @"createdAt",
        @"game_name@request": @"game.name",
        @"user@response": @"user@PRUser",
        @"game": @"game@PRGame",
        @"arena": @"arena@PRArena",
        @"teams": @"teams@PRTeam"
    }];
    
    [mapping[@"user"][@"teams"][@"participations"] removeMappingWithSourceKeyPath:@"team"];

    return mapping;
}

+ (NSDictionary *)relationships {
    return @{
        @"participations": [PRRelationshipDescriptor relationshipDescriptorWithTargetClass:[PRParticipation class]
                                                                                remotePath:@"/rounds/:objectID/participations"
                                                                                   keyPath:@"participations"]
    };
}

- (void)setGame:(PRGame *)game {
    if(game != _game) {
        _game = game;
        
        NSMutableArray *teams = [NSMutableArray array];
        
        for(PRTeamDescriptor *teamDescriptor in game.teamDescriptors)
            [teams addObject:[teamDescriptor newTeam]];
        
        self.teams = [NSArray arrayWithArray:teams];
    }
}

- (id)init {
    self = [super init];
    
    if(self) {
        self.arena = [[PRArena alloc] init];
    }
    
    return self;
}

- (PRTeam *)winningTeam {
    NSUInteger winningTeamIndex = [self.teams indexOfObjectPassingTest:^BOOL(PRTeam *team, NSUInteger idx, BOOL *stop) {
        return team.winner;
    }];
    
    return winningTeamIndex != NSNotFound ? self.teams[winningTeamIndex] : nil;
}

- (NSString *)stateDisplayName {
    if([self.state isEqualToString:@"waiting_for_players"])
        return @"Waiting for players";
    else if([self.state isEqualToString:@"ongoing"])
        return @"Ongoing";
    else if([self.state isEqualToString:@"over"])
        return @"Over";
    
    return nil;
}

- (BOOL)hasParticipant:(PRUser *)user {
    for(PRTeam *team in self.teams)
        if([[team.participations valueForKeyPath:@"user.objectID"] containsObject:user.objectID])
            return YES;
    
    return NO;
}

- (PRParticipation *)addParticipant:(PRUser *)user toTeam:(PRTeam *)team prepend:(BOOL)prepend {
    for(PRTeam *t in self.teams)
        [t removeParticipant:user];
    
    return [team addParticipant:user prepend:prepend];
}

- (void)removeParticipant:(PRUser *)user fromTeam:(PRTeam *)team {
    [team removeParticipant:user];
}

- (void)removeAllParticipantsFromTeam:(PRTeam *)team {
    [team removeAllParticipants];
}

@end
