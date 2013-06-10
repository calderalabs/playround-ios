//
//  PRGame.h
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@interface PRGame : PRModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSURL *pictureURL;
@property (nonatomic, assign) NSUInteger numberOfTeams;

@end
