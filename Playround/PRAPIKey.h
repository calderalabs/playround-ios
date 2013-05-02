//
//  PRAPIKey.h
//  Playround
//
//  Created by Eugenio Depalo on 5/2/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRModel.h"

@interface PRAPIKey : PRModel

@property (nonatomic, copy) NSString *accessToken;

+ (PRAPIKey *)current;
- (id)initWithAccessToken:(NSString *)accessToken;
- (void)updateHTTPToken;

@end
