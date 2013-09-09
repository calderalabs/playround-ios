//
//  PRObjectManager.m
//  Playround
//
//  Created by Eugenio Depalo on 5/3/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRObjectManager.h"
#import "PRRound.h"
#import "PRUser.h"
#import "PRGame.h"
#import "PRArena.h"
#import "PRToken.h"
#import "PRSession.h"
#import "PRStart.h"
#import "PRWinning.h"
#import "PRParticipation.h"

static NSString *kAccountName = @"playround.token";

@interface PRObjectManager ()

- (void)sessionDidLogin:(NSNotification *)notification;

@end

@implementation PRObjectManager

- (id)init {
    self = [self initWithHTTPClient:[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PR_API_BASE_URL]]];
    
    if(self) {
        [self.HTTPClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
        self.requestSerializationMIMEType = RKMIMETypeJSON;
        self.accessToken = self.class.defaultAccessToken;
        
        for(Class class in PRModel.modelClasses)
            [class setObjectManager:self];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(sessionDidLogin:) name:PRSessionDidLoginNotification object:PRSession.current];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)sessionDidLogin:(NSNotification *)notification {
    PRToken *token = notification.userInfo[@"token"];
    [self setAccessToken:token.value asDefault:YES];
}

+ (NSString *)defaultAccessToken {
    return [SSKeychain passwordForService:NSBundle.mainBundle.bundleIdentifier account:kAccountName];
}

+ (void)setDefaultAccessToken:(NSString *)accessToken {
    if(!accessToken)
        [SSKeychain deletePasswordForService:NSBundle.mainBundle.bundleIdentifier account:kAccountName];
    else
        [SSKeychain setPassword:accessToken forService:NSBundle.mainBundle.bundleIdentifier account:kAccountName];
}

- (void)setAccessToken:(NSString *)accessToken {
    [self setAccessToken:accessToken asDefault:NO];
}

- (void)setAccessToken:(NSString *)accessToken asDefault:(BOOL)asDefault {
    if(accessToken)
        [self.HTTPClient setAuthorizationHeaderWithToken:accessToken];
    else
        [self.HTTPClient clearAuthorizationHeader];
    
    if(asDefault)
        self.class.defaultAccessToken = accessToken;
}

@end
