//
//  PRToken.m
//  Playround
//
//  Created by Eugenio Depalo on 5/2/13.
//  Copyright (c) 2013 Eugenio Depalo. All rights reserved.
//

#import "PRToken.h"

@implementation PRToken

+ (NSString *)remotePath {
    return @"/tokens";
}

+ (NSString *)keyPath {
    return @"token";
}

+ (PRModelOperationType)supportedOperationTypes {
    return PRModelOperationCreate;
}

@end
