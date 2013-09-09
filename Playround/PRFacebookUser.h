//
//  PRFacebookUser.h
//  Playround
//
//  Created by Eugenio Depalo on 8/27/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

@interface PRFacebookUser : NSObject

+ (PRFacebookUser *)defaultUser;

- (void)createAccessTokenWithCompletion:(void (^)(NSString *accessToken, NSError *error))completion;
- (void)readFriendsWithCompletion:(void (^)(NSArray *friends, NSError *error))completion;

@end
