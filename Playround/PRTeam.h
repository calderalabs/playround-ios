//
//  PRTeam.h
//  Playround
//
//  Created by Eugenio Depalo on 7/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRUser.h"
#import "PRTeamDescriptor.h"

@interface PRTeam : PRModel {
    NSMutableArray *_participations;
}

@property (nonatomic, strong) PRTeamDescriptor *descriptor;
@property (nonatomic, copy, readonly) NSArray *participations;

- (void)addParticipant:(PRUser *)user prepend:(BOOL)prepend;
- (void)removeParticipant:(PRUser *)user;
- (void)removeAllParticipants;

@end
