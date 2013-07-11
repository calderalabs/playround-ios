//
//  PRParticipation.h
//  Playround
//
//  Created by Eugenio Depalo on 6/28/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRUser.h"

@interface PRParticipation : PRModel

@property (nonatomic, strong) PRUser *user;

@end
