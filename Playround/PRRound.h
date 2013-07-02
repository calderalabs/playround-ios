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

@interface PRRound : PRModel {
    NSMutableArray *_participations;
}

@property (nonatomic, strong) PRUser *user;
@property (nonatomic, strong) PRArena *arena;
@property (nonatomic, strong) PRGame *game;
@property (nonatomic, copy, readonly) NSArray *participations;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSString *state;

- (void)addParticipant:(PRUser *)user team:(PRTeam *)team prepend:(BOOL)prepend;
- (void)addParticipant:(PRUser *)user team:(PRTeam *)team;
- (void)removeParticipant:(PRUser *)user;
- (void)removeAllParticipants;
- (NSArray *)participationsForTeam:(PRTeam *)team;

@end
