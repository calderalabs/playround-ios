//
//  PRRound.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRUser.h"
#import "PRArena.h"
#import "PRGame.h"
#import "PRTeam.h"
#import "PRParticipation.h"

@interface PRRound : PRModel

@property (nonatomic, strong) PRUser *user;
@property (nonatomic, strong) PRArena *arena;
@property (nonatomic, strong) PRGame *game;
@property (nonatomic, copy) NSArray *teams;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, strong, readonly) PRTeam *winningTeam;
@property (nonatomic, copy, readonly) NSString *stateDisplayName;

- (BOOL)hasParticipant:(PRUser *)user;
- (PRParticipation *)addParticipant:(PRUser *)user toTeam:(PRTeam *)team prepend:(BOOL)prepend;
- (void)removeParticipant:(PRUser *)user fromTeam:(PRTeam *)team;
- (void)removeAllParticipantsFromTeam:(PRTeam *)team;

@end
