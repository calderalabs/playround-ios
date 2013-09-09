//
//  PRFacebookUser.m
//  Playround
//
//  Created by Eugenio Depalo on 8/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRFacebookUser.h"

static NSString *kAccountName = @"playround.facebook.token";

static PRFacebookUser *defaultUser = nil;

@interface PRFacebookUser ()

@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccountType *accountType;
@property (nonatomic, retain, readonly) ACAccount *account;
@property (nonatomic, copy) NSString *accessToken;

@end

@implementation PRFacebookUser

+ (PRFacebookUser *)defaultUser {
    if(!defaultUser)
        defaultUser = [[PRFacebookUser alloc] init];
    
    return defaultUser;
}

- (ACAccount *)account {
    return [self.accountStore accountsWithAccountType:self.accountType].lastObject;
}

- (id)init {
    self = [super init];
    
    if(self) {
        self.accountStore = [[ACAccountStore alloc] init];
        self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        self.accessToken = [SSKeychain passwordForService:NSBundle.mainBundle.bundleIdentifier account:kAccountName];
    }
    
    return self;
}

- (void)createAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion {
    [self.accountStore requestAccessToAccountsWithType:self.accountType
                                               options:@{
                                                   ACFacebookAppIdKey: PR_FACEBOOK_APP_ID,
                                                   ACFacebookPermissionsKey: @[@"email"]
                                               }
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    if(granted) {
                                                        self.accessToken = self.account.credential.oauthToken;
                                                        [SSKeychain setPassword:self.accessToken forService:NSBundle.mainBundle.bundleIdentifier account:kAccountName];
                                                        completion(self.accessToken, nil);
                                                    }
                                                    else {
                                                        completion(nil, error);
                                                    }
                                                });
                                            }];
}

- (void)readFriendsWithCompletion:(void (^)(NSArray *friends, NSError *error))completion {
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://graph.facebook.com/me/friends"]
                                               parameters:@{ @"access_token": self.accessToken }];
    
    request.account = self.account;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *response, NSError *error) {
        if(!error)
            completion([NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error][@"data"], nil);
        else
            completion(nil, error);
    }];
}

@end
