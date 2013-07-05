//
//  PRArena.h
//  Playround
//
//  Created by Eugenio Depalo on 4/17/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@interface PRArena : PRModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
