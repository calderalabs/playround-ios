//
//  PRSession.m
//  Playround
//
//  Created by Eugenio Depalo on 5/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRSession.h"
#import "PRFacebookUser.h"

NSString *PRSessionDidLoginNotification = @"PRSessionDidLoginNotification";

static PRSession *sCurrentSession;

@interface PRSession ()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation PRSession

+ (void)setCurrent:(PRSession *)session {
    sCurrentSession = session;
}

+ (PRSession *)current {
    if(!sCurrentSession) {
        sCurrentSession = [[PRSession alloc] init];
    }
    
    return sCurrentSession;
}

- (id)init {
    self = [super init];
    
    if(self) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didReadCurrentUser:) name:PRUserDidReadCurrentNotification object:[PRUser class]];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)didReadCurrentUser:(NSNotification *)notification {
    self.user = notification.userInfo[@"user"];
}

- (void)loginWithToken:(PRToken *)token completion:(void (^)(PRToken *user, NSError *error))completion {
    [token createWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *result, NSError *error) {
        if(!error) {
            self.user = token.user;
            
            [NSNotificationCenter.defaultCenter postNotificationName:PRSessionDidLoginNotification object:self userInfo:@{ @"token": token }];
            completion(token, nil);
        }
        else
            completion(nil, error);
    }];
}

- (void)facebookConnectWithCompletion:(void (^)(PRToken *user, NSError *error))completion {
    [[PRFacebookUser defaultUser] createAccessTokenWithCompletion:^(NSString *accessToken, NSError *error) {
        if(!error) {
            PRToken *token = [[PRToken alloc] init];
            token.facebookAccessToken = accessToken;
            [self loginWithToken:token completion:completion];
        }
        else {
            completion(nil, error);
        }
    }];
}

@end
