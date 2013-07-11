//
//  PRTeamDescriptor.h
//  Playround
//
//  Created by Eugenio Depalo on 6/24/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@class PRTeam;

@interface PRTeamDescriptor : PRModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, assign) NSInteger numberOfPlayers;

- (PRTeam *)newTeam;

@end
