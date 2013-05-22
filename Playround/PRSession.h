//
//  PRSession.h
//  Playround
//
//  Created by Eugenio Depalo on 5/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRUser.h"
#import "PRToken.h"

extern NSString *PRSessionDidLoginNotification;

@interface PRSession : NSObject

@property (nonatomic, strong) PRUser *user;

+ (void)setCurrent:(PRSession *)session;
+ (PRSession *)current;

- (void)facebookConnectWithCompletion:(void (^)(PRToken *token, NSError *error))completion;

@end
