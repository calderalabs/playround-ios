//
//  PRWinning.h
//  Playround
//
//  Created by Eugenio Depalo on 7/11/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRRound.h"
#import "PRTeam.h"

@interface PRWinning : PRModel

@property (nonatomic, strong) PRRound *round;
@property (nonatomic, strong) PRTeam *team;

@end