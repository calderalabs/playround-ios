//
//  PRObjectManager.m
//  Playround
//
//  Created by Eugenio Depalo on 5/3/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRObjectManager.h"
#import "PRHTTPRequestOperation.h"
#import "PRRound.h"
#import "PRUser.h"
#import "PRGame.h"
#import "PRArena.h"
#import "PRToken.h"

static NSString *kServiceName = @"playround.api";
static NSString *kAccountName = @"playround.account";

@implementation PRObjectManager

- (id)init {
    self = [self initWithHTTPClient:[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PR_API_BASE_URL]]];
    
    if(self) {
        [self.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self registerRequestOperationClass:[PRHTTPRequestOperation class]];
        [self setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
        self.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
        
        if(PR_API_ACCESS_TOKEN)
            self.accessToken = PR_API_ACCESS_TOKEN;
        else
            self.accessToken = self.class.defaultAccessToken;
    
        for(Class class in @[[PRRound class], [PRUser class], [PRGame class], [PRArena class], [PRToken class]])
            [class setObjectManager:self];
    }
    
    return self;
}

+ (NSString *)defaultAccessToken {
    return [SSKeychain passwordForService:kServiceName account:kAccountName];
}

+ (void)setDefaultAccessToken:(NSString *)accessToken {
    if(!accessToken)
        [SSKeychain deletePasswordForService:kServiceName account:kAccountName];
    else
        [SSKeychain setPassword:accessToken forService:kServiceName account:kAccountName];
}

- (void)setAccessToken:(NSString *)accessToken {
    [self setAccessToken:accessToken asDefault:NO];
}

- (void)setAccessToken:(NSString *)accessToken asDefault:(BOOL)asDefault {
    [self.HTTPClient setAuthorizationHeaderWithToken:accessToken];

    if(asDefault)
        self.class.defaultAccessToken = accessToken;
}

@end
