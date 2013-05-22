//
//  PRSession.h
//  Playround
//
//  Created by Eugenio Depalo on 5/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRUser.h"

@interface PRSession : NSObject

@property (nonatomic, strong) PRUser *user;

+ (void)setCurrent:(PRSession *)session;
+ (PRSession *)current;

- (void)facebookConnectWithCompletion:(void (^)(PRUser *user, NSError *error))completion;

@end
