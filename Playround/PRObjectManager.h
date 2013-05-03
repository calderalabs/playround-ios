//
//  PRObjectManager.h
//  Playround
//
//  Created by Eugenio Depalo on 5/3/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "RKObjectManager.h"

@interface PRObjectManager : RKObjectManager

- (void)setAccessToken:(NSString *)accessToken;
- (void)setAccessToken:(NSString *)accessToken asDefault:(BOOL)asDefault;
+ (NSString *)defaultAccessToken;
+ (void)setDefaultAccessToken:(NSString *)accessToken;

@end
