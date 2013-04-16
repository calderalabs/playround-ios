//
//  PRRound.h
//  Playround
//
//  Created by Eugenio Depalo on 4/16/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRUser.h"

@interface PRRound : PRModel

@property (nonatomic, strong) PRUser *user;
@property (nonatomic, copy) NSString *objectID;
@property (nonatomic, copy) NSDate *createdAt;
@property (nonatomic, copy) NSString *status;

@end
