//
//  PRAPIKey.m
//  Playround
//
//  Created by Eugenio Depalo on 5/2/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRAPIKey.h"

static NSString *kServiceName = @"playround.api";
static NSString *kAccountName = @"playround.account";

@implementation PRAPIKey

+ (NSString *)remotePath {
    return @"/tokens";
}

+ (NSString *)keyPath {
    return @"tokens";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationCreate;
}

+ (void)setObjectManager:(RKObjectManager *)objectManager {
    [super setObjectManager:objectManager];
    [self.current updateHTTPToken];
}

+ (PRAPIKey *)current {
    NSString *accessToken = [SSKeychain passwordForService:kServiceName account:kAccountName];
    
    if(!accessToken)
        return nil;
    
    return [[self alloc] initWithAccessToken:accessToken];
}

+ (void)setCurrent:(PRAPIKey *)apiKey {
    if(!apiKey)
        [SSKeychain deletePasswordForService:kServiceName account:kAccountName];
    else
        [SSKeychain setPassword:apiKey.accessToken forService:kServiceName account:kAccountName];
    
    [apiKey updateHTTPToken];
}

- (void)updateHTTPToken {
    [RKObjectManager.sharedManager.HTTPClient setDefaultHeader:@"Authorization"
                                                         value:[NSString stringWithFormat:@"Token token=\"%@\"", self.accessToken]];
}

- (id)initWithAccessToken:(NSString *)accessToken {
    self = [self init];
    
    if(self) {
        self.accessToken = accessToken;
    }
    
    return self;
}

@end
