//
//  PRRound.m
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRRound.h"
#import "PRTeamDescriptor.h"

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
    [mapping addRelationshipMappingWithSourceKeyPath:@"teams" mapping:[PRTeam objectMapping]];
    
    [mapping addAttributeMappingsFromDictionary:@{
        @"state": @"state",
        @"created_at": @"createdAt",
        @"game_name": @"game.name",
    }];

    return mapping;
}

+ (NSArray *)excludedRequestAttributes {
    return [[super excludedRequestAttributes] arrayByAddingObjectsFromArray:@[
        @"game", @"user"
    ]];
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

- (BOOL)hasParticipant:(PRUser *)user {
    for(PRTeam *team in self.teams)
        if([[team.participations valueForKeyPath:@"user.objectID"] containsObject:user.objectID])
            return YES;
    
    return NO;
}

- (void)addParticipant:(PRUser *)user team:(PRTeam *)team prepend:(BOOL)prepend {
    for(PRTeam *t in self.teams)
        [t removeParticipant:user];
    
    [team addParticipant:user prepend:prepend];
}

- (void)removeParticipant:(PRUser *)user team:(PRTeam *)team {
    [team removeParticipant:user];
}

- (void)removeAllParticipantsFromTeam:(PRTeam *)team {
    [team removeAllParticipants];
}

@end
