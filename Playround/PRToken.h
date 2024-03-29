//
//  PRToken.h
//  Playround
//
//  Created by Eugenio Depalo on 5/2/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"
#import "PRUser.h"

@interface PRToken : PRModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) PRUser *user;
@property (nonatomic, copy) NSString *facebookAccessToken;

@end
