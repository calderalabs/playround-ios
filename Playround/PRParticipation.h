//
//  PRParticipation.h
//  Playround
//
//  Created by Eugenio Depalo on 6/28/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRUser.h"
#import "PRTeam.h"

@interface PRParticipation : PRModel

@property (nonatomic, strong) PRUser *user;
@property (nonatomic, strong) PRTeam *team;

@end
