//
//  PRSession.m
//  Playround
//
//  Created by Eugenio Depalo on 5/9/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRSession.h"

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
        self.accountStore = [[ACAccountStore alloc] init];
        
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

- (void)facebookConnectWithCompletion:(void (^)(PRToken *user, NSError *error))completion {
    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

    [self.accountStore requestAccessToAccountsWithType:facebookAccountType
                                               options:@{
                                                   ACFacebookAppIdKey: PR_FACEBOOK_APP_ID,
                                                   ACFacebookPermissionsKey: @[@"email"]
                                               }
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if(granted) {
                                                        NSArray *accounts = [self.accountStore accountsWithAccountType:facebookAccountType];
                                                        ACAccount *account = accounts.lastObject;
                                                        PRToken *token = [[PRToken alloc] init];
                                                        token.facebookAccessToken = account.credential.oauthToken;
                                                        
                                                        [token createWithCompletion:^(RKObjectRequestOperation *operation, RKMappingResult *result, NSError *error) {
                                                            if(!error) {
                                                                [NSNotificationCenter.defaultCenter postNotificationName:PRSessionDidLoginNotification object:self userInfo:@{ @"token": token }];
                                                                completion(token, nil);
                                                            }
                                                            else
                                                                completion(nil, error);
                                                        }];
                                                    }
                                                    else {
                                                        completion(nil, error);
                                                    }
                                                });
                                            }];
}

@end
